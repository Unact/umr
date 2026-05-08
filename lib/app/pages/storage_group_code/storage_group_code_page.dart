import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/storage_group_codes_repository.dart';
import '/app/utils/page_helpers.dart';

part 'storage_group_code_state.dart';
part 'storage_group_code_view_model.dart';

class StorageGroupCodePage extends StatelessWidget {
  final ApiStorageGroupCode storageGroupCode;

  StorageGroupCodePage({
    required this.storageGroupCode,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StorageGroupCodeViewModel>(
      create: (context) => StorageGroupCodeViewModel(
        RepositoryProvider.of<StorageGroupCodesRepository>(context),
        storageGroupCode: storageGroupCode
      ),
      child: _StorageGroupCodeView(),
    );
  }
}

class _StorageGroupCodeView extends StatefulWidget {
  @override
  _StorageGroupCodeViewState createState() => _StorageGroupCodeViewState();
}

class _StorageGroupCodeViewState extends State<_StorageGroupCodeView> {
  final player = AudioPlayer();
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showScanView(Function(String) onRead) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: onRead,
          onError: (errorMessage) {
            PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
          },
          child: Text('Отсканируйте код', style: const TextStyle(color: Colors.white, fontSize: 20))
        ),
        fullscreenDialog: true
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StorageGroupCodeViewModel, StorageGroupCodeState>(
      builder: (context, state) {
        return Scaffold(
          persistentFooterButtons: _buildFooterButtons(context),
          appBar: AppBar(
            title: Text('Формирование АК'),
          ),
          body: _buildBody(context)
        );
      },
      listener:(context, state) async {
        switch (state.status) {
          case StorageGroupCodeStateStatus.inProgress:
            await _progressDialog.open();
            break;
          case StorageGroupCodeStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case StorageGroupCodeStateStatus.success:
            await _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          case StorageGroupCodeStateStatus.scanFailure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            await player.play(AssetSource('beep_error.mp3'));
            break;
          case StorageGroupCodeStateStatus.scanSuccess:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            await player.play(AssetSource('beep_success.mp3'));
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    StorageGroupCodeViewModel vm = context.read<StorageGroupCodeViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(
              title: const Text('Код'),
              trailing: Text(vm.state.storageGroupCode.groupCode, style: TextStyle(fontSize: 13))
            ),
            InfoRow(
              title: const Text('Завершен'),
              trailing: Text(Format.dateTimeStr(vm.state.storageGroupCode.packaged), style: TextStyle(fontSize: 13))
            )
          ])
        ),
        _buildStorageGroupCodeCodeTiles(context)
      ],
    );
  }

  Widget _buildStorageGroupCodeCodeTiles(BuildContext context) {
    StorageGroupCodeViewModel vm = context.read<StorageGroupCodeViewModel>();

    return ExpansionTile(
      title: const Text('Коды', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: vm.state.storageGroupCode.packaged != null ?
        null :
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              tooltip: 'Добавить код',
              icon: const Icon(Icons.barcode_reader),
              onPressed: () => showScanView(vm.scan)
            ),
            IconButton(
              tooltip: 'Удалить код',
              icon: const Icon(Icons.delete),
              onPressed: () => showScanView(vm.deleteScan)
            )
          ].whereType<Widget>().toList()
        ),
      children: vm.state.storageGroupCode.codes
        .map((e) => _buildStorageGroupCodeSaleOrderTile(context, e)).toList()
    );
  }

  Widget _buildStorageGroupCodeSaleOrderTile(
    BuildContext context,
    ApiStorageGroupCodeCode storageGroupCodeCode
  ) {
    return ListTile(
      dense: true,
      title: Text(storageGroupCodeCode.code.split('\u001d')[0]),
    );
  }

  List<Widget> _buildFooterButtons(BuildContext context) {
    StorageGroupCodeViewModel vm = context.read<StorageGroupCodeViewModel>();

    if (vm.state.storageGroupCode.packaged != null) return [];

    return [
      TextButton(
        onPressed: vm.completeScan,
        child: const Text('Завершить')
      )
    ];
  }
}
