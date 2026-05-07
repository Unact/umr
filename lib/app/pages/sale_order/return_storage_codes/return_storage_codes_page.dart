import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/utils/page_helpers.dart';
import '../sale_order_page.dart';

part 'return_storage_codes_state.dart';
part 'return_storage_codes_view_model.dart';

class ReturnStorageCodesPage extends StatelessWidget {
  final SaleOrderViewModel saleOrderVm;
  final List<ApiSaleOrderReturnStorageLineCode> returnStorageCodes;

  ReturnStorageCodesPage({
    required this.saleOrderVm,
    required this.returnStorageCodes,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ReturnStorageCodesViewModel>(
      create: (context) => ReturnStorageCodesViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrderVm,
        returnStorageCodes: returnStorageCodes
      ),
      child: _ReturnStorageCodesView(),
    );
  }
}

class _ReturnStorageCodesView extends StatefulWidget {
  @override
  _ReturnStorageCodesViewState createState() => _ReturnStorageCodesViewState();
}

class _ReturnStorageCodesViewState extends State<_ReturnStorageCodesView> {
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);
  final player = AudioPlayer();

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showScan() async {
    ReturnStorageCodesViewModel vm = context.read<ReturnStorageCodesViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: vm.scan,
          onError: (errorMessage) {
            PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Text('Отсканируйте код', style: Styles.scanTitleText)
              )
            ]
          )
        ),
        fullscreenDialog: true
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReturnStorageCodesViewModel, ReturnStorageCodesState>(
      builder: (context, state) {
        return Scaffold(
          persistentFooterButtons: _buildFooterButtons(context),
          appBar: AppBar(
            title: Text('Сканирование возврата'),
          ),
          body: _buildBody(context)
        );
      },
      listener: (context, state) async {
        ReturnStorageCodesViewModel vm = context.read<ReturnStorageCodesViewModel>();

        switch (state.status) {
          case ReturnStorageCodesStateStatus.needUserConfirmation:
            await PageHelpers.showConfirmationDialog(context, vm.completeScan, state.message);
            break;
          case ReturnStorageCodesStateStatus.scanFailure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            await player.play(AssetSource('beep_error.mp3'));
            break;
          case ReturnStorageCodesStateStatus.scanSuccess:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            await player.play(AssetSource('beep_success.mp3'));
            break;
          case ReturnStorageCodesStateStatus.inProgress:
            _progressDialog.open();
            break;
          case ReturnStorageCodesStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case ReturnStorageCodesStateStatus.success:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          case ReturnStorageCodesStateStatus.scanDeleteFailure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case ReturnStorageCodesStateStatus.scanDeleteSuccess:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        _buildOrderLinesTile(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    ReturnStorageCodesViewModel vm = context.read<ReturnStorageCodesViewModel>();

    return ExpansionTile(
      title: const Text('Сканирование позиций', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: vm.state.finished ? null : IconButton(
        tooltip: 'Отсканировать код маркировки',
        icon: const Icon(Icons.barcode_reader),
        onPressed: showScan
      ),
      children: vm.saleOrderVm.state.saleOrder.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiSaleOrderLine line) {
    ReturnStorageCodesViewModel vm = context.read<ReturnStorageCodesViewModel>();

    if (vm.state.finished) {
      final amount = vm.state.returnStorageCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

      return ListTile(
        dense: true,
        title: Text(line.goodsName),
        trailing: Text('${amount.toInt()} из ${line.vol.toInt()}')
      );
    } else {
      final amount = vm.state.returnStorageCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

      return ListTile(
        dense: true,
        leading: amount == line.vol ?
          Icon(Icons.check, color: Colors.green) :
          Icon(Icons.hourglass_empty, color: Colors.yellow),
        title: Text(line.goodsName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${amount.toInt()} из ${line.vol.toInt()}'),
            !vm.state.finished ? IconButton(
              onPressed: () => vm.clearOrderLineCodes(line),
              icon: Icon(Icons.delete),
              tooltip: 'Удалить КМ',
            ) : null
          ].whereType<Widget>().toList()
        )
      );
    }
  }

  List<Widget> _buildFooterButtons(BuildContext context) {
    ReturnStorageCodesViewModel vm = context.read<ReturnStorageCodesViewModel>();

    if (vm.state.finished) return [];

    return [
      TextButton(
        onPressed: vm.tryCompleteScan,
        child: const Text('Завершить')
      )
    ];
  }
}
