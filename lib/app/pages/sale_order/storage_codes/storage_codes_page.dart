import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:collection/collection.dart';
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

part 'storage_codes_state.dart';
part 'storage_codes_view_model.dart';

class StorageCodesPage extends StatelessWidget {
  final SaleOrderViewModel saleOrderVm;
  final List<ApiSaleOrderStorageLineCode> storageCodes;

  StorageCodesPage({
    required this.saleOrderVm,
    required this.storageCodes,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<StorageCodesViewModel>(
      create: (context) => StorageCodesViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrderVm,
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

  Future<void> showGroupScanView() async {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: (String rawValue) {
            Navigator.pop(context);
            vm.startGroupScan(rawValue);
          },
          onError: (errorMessage) {
            PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
          },
          child: Container()
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
            title: Text('Сканирование заказа'),
          ),
          body: _buildBody(context)
        );
      },
      listener: (context, state) async {
        switch (state.status) {
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
          case StorageCodesStateStatus.scanDeleteFailure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case StorageCodesStateStatus.scanDeleteSuccess:
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
              title: const Text('Отсканирован'),
              trailing: Text(Format.dateTimeStr(vm.saleOrderVm.state.saleOrder.scanned))
            )
          ])
        ),
        _buildOrderLinesTile(context),
        _buildGroupCodesTile(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    return ExpansionTile(
      title: const Text('Сканирование позиций', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: vm.saleOrderVm.state.saleOrder.scanned != null ? null : IconButton(
        tooltip: 'Отсканировать код маркировки',
        icon: const Icon(Icons.barcode_reader),
        onPressed: showScan
      ),
      children: vm.saleOrderVm.state.saleOrder.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildGroupCodesTile(BuildContext context) {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    if (vm.state.storageCodes.none((e) => e.groupCode != null)) return Container();

    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('Агрегационные коды', style: TextStyle(fontSize: 14)),
      showTrailingIcon: false,
      children: vm.state.storageCodes.where((e) => e.groupCode != null).map((e) => e.groupCode).toSet().map((e) {
        return ExpansionTile(
          title: Text(e!, style: TextStyle(fontSize: 14)),
          initiallyExpanded: true,
          children: vm.state.storageCodes.where((lc) => lc.groupCode == e).map(
            (lc) => _buildGroupCodeLineTile(context, lc)
          ).toList()
        );
      }).toList()
    );
  }

  Widget _buildGroupCodeLineTile(BuildContext context, ApiSaleOrderStorageLineCode line) {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();
    final saleOrderLine = vm.saleOrderVm.state.saleOrder.lines.firstWhere((e) => e.subid == line.subid);

    return ListTile(
      dense: true,
      title: Text(saleOrderLine.goodsName),
      trailing: Text(line.vol.toInt().toString())
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiSaleOrderLine line) {
    StorageCodesViewModel vm = context.read<StorageCodesViewModel>();

    if (vm.saleOrderVm.state.saleOrder.scanned != null) {
      final amount = vm.state.storageCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

      return ListTile(
        dense: true,
        title: Text(line.goodsName),
        trailing: Text('${amount.toInt()} из ${line.vol.toInt()}')
      );
    } else {
      final amount = vm.state.storageCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

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
            vm.saleOrderVm.state.saleOrder.scanned == null ? IconButton(
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
    final fullyScanned = vm.state.storageCodes.fold(0.0, (prev, e) => prev + e.vol) ==
      vm.saleOrderVm.state.saleOrder.lines.fold(0.0, (prev, e) => prev + e.vol);

    if (vm.saleOrderVm.state.saleOrder.scanned != null) return [];

    return [
      vm.state.currentGroupCode == null ?
        TextButton(onPressed: showGroupScanView, child: const Text('Добавить АК')) :
        TextButton(onPressed: vm.completeGroupScan, child: const Text('Завершить АК')),
      TextButton(
        onPressed: fullyScanned ? vm.completeScan : null,
        child: const Text('Завершить')
      )
    ];
  }
}
