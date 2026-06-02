import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';
import 'package:umr/app/pages/supply/supply_page.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/supplies_repository.dart';
import '/app/utils/page_helpers.dart';
import '/app/widgets/widgets.dart';

part 'storage_codes_state.dart';
part 'storage_codes_view_model.dart';

class StorageCodesPage extends StatelessWidget {
  final List<ApiSupplyStorageLineCode> storageCodes;
  final SupplyViewModel supplyVm;

  StorageCodesPage({
    required this.supplyVm,
    required this.storageCodes,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StorageCodesViewModel>(
      create: (context) => StorageCodesViewModel(
        RepositoryProvider.of<SuppliesRepository>(context),
        supplyVm,
        storageCodes: storageCodes
      ),
      child: _StorageCodesView(),
    );
  }
}

class _StorageCodesView extends StatefulWidget {
  @override
  _StorageCodesViewState createState() => _StorageCodesViewState();
}

class _StorageCodesViewState extends State<_StorageCodesView> {
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);
  final player = AudioPlayer();

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showScan() async {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    final result = await showDialog<bool?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        bool? pieceScan = false;

        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleAlertDialog(
              title: const Text('Укажите тип'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    DropdownButtonFormField(
                      isExpanded: true,
                      menuMaxHeight: 200,
                      decoration: const InputDecoration(labelText: 'Тип'),
                      initialValue: pieceScan,
                      items: [
                        DropdownMenuItem(
                          value: true,
                          child: Text('Штука')
                        ),
                        DropdownMenuItem(
                          value: false,
                          child: Text('Упаковка')
                        ),
                      ],
                      onChanged: (newVal) => setState(() => pieceScan = newVal)
                    )
                  ]
                )
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: pieceScan == null ?
                    null :
                    () => Navigator.of(context).pop(pieceScan),
                  child: const Text(Strings.ok)
                ),
                TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(null))
              ],
            );
          }
        );
      }
    );

    if (result == null) return;

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: (scanResult) => vm.scan(scanResult, result),
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
    return BlocConsumer<StorageCodesViewModel, StorageCodesState>(
      builder: (context, state) {
        return Scaffold(
          persistentFooterButtons: _buildFooterButtons(context),
          appBar: AppBar(
            title: Text('Поставка'),
          ),
          body: _buildBody(context)
        );
      },
      listener: (context, state) async {
        StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

        switch (state.status) {
          case StorageCodesStateStatus.needUserConfirmation:
            await PageHelpers.showConfirmationDialog(context, vm.completeScan, state.message);
            break;
          case StorageCodesStateStatus.scanFailure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            await player.play(AssetSource('beep_error.mp3'));
            break;
          case StorageCodesStateStatus.scanSuccess:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            await player.play(AssetSource('beep_success.mp3'));
            break;
          case StorageCodesStateStatus.inProgress:
            _progressDialog.open();
            break;
          case StorageCodesStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case StorageCodesStateStatus.success:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(
              title: const Text('Статус'),
              trailing: Text(
                vm.supplyVm.state.supply.linked ? 'КМ ЧЗ привязаны' : 'КМ ЧЗ не привязаны'
              )
            ),
            InfoRow(
              title: const Text('Отсканирован'),
              trailing: Text(Format.dateTimeStr(vm.supplyVm.state.supply.scanned))
            ),
            InfoRow(title: const Text('Уровень доверия'), trailing: Text(vm.supplyVm.state.supply.trustLevelName ?? ''))
          ])
        ),
        _buildOrderLinesTile(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    return ExpansionTile(
      title: const Text('Сканирование позиций', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: vm.supplyVm.state.supply.scanned != null ? null : IconButton(
        tooltip: 'Отсканировать код маркировки',
        icon: const Icon(Icons.barcode_reader),
        onPressed: showScan
      ),
      children: vm.supplyVm.state.supply.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiSupplyLine line) {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    if (vm.supplyVm.state.supply.scanned != null) {
      final amount = vm.state.storageCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

      return ListTile(
        dense: true,
        title: Text(line.goodsName),
        trailing: Text('${amount.toInt()} из ${line.vol.toInt()}')
      );
    } else {
      final lineCodes = vm.state.storageCodes.where((e) => e.subid == line.subid);
      final amount = lineCodes.fold(0.0, (v, el) => v + el.vol);

      return ListTile(
        dense: true,
        leading: amount == line.vol ?
          Icon(Icons.check, color: Colors.green) :
          Icon(Icons.hourglass_empty, color: Colors.yellow),
        title: Text(line.goodsName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${lineCodes.length}; ${amount.toInt()} из ${line.vol.toInt()}'),
            vm.supplyVm.state.supply.scanned == null ? IconButton(
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
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    if (vm.supplyVm.state.supply.scanned != null) return [];

    return [
      TextButton(onPressed: vm.tryCompleteScan, child: const Text('Завершить'))
    ];
  }
}
