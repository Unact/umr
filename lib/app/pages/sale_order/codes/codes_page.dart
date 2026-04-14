import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/utils/page_helpers.dart';
import 'scan/scan_page.dart';

part 'codes_state.dart';
part 'codes_view_model.dart';

class CodesPage extends StatelessWidget {
  final ApiSaleOrder saleOrder;
  final SaleOrderScanType type;

  CodesPage({
    required this.saleOrder,
    required this.type,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CodesViewModel>(
      create: (context) => CodesViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrder: saleOrder,
        type: type
      ),
      child: _CodesView(),
    );
  }
}

class _CodesView extends StatefulWidget {
  @override
  _CodesViewState createState() => _CodesViewState();
}

class _CodesViewState extends State<_CodesView> {
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showScan() async {
    CodesViewModel vm = context.read<CodesViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanPage(
          saleOrder: vm.state.saleOrder,
          type: vm.state.type,
          groupCode: vm.state.currentGroupCode
        ),
        fullscreenDialog: true
      )
    );
  }

  Future<void> showGroupScanView() async {
    CodesViewModel vm = context.read<CodesViewModel>();

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
    return BlocConsumer<CodesViewModel, CodesState>(
      builder: (context, state) {
        return Scaffold(
          persistentFooterButtons: _buildFooterButtons(context),
          appBar: AppBar(
            title: Text(state.type == SaleOrderScanType.realization ? 'Заказ' : 'Возврат'),
          ),
          body: _buildBody(context)
        );
      },
      listener: (context, state) async {
        CodesViewModel vm = context.read<CodesViewModel>();

        switch (state.status) {
          case CodesStateStatus.needUserConfirmation:
            await PageHelpers.showConfirmationDialog(context, vm.completeScan, state.message);
            break;
          case CodesStateStatus.inProgress:
            _progressDialog.open();
            break;
          case CodesStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case CodesStateStatus.success:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    CodesViewModel vm = context.read<CodesViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(
              title: const Text('Статус'),
              trailing: Text(vm.state.allTypeLineCodes.isEmpty ? 'Не отсканирован' : 'Отсканирован')
            )
          ])
        ),
        _buildOrderLinesTile(context),
        _buildGroupCodesTile(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    CodesViewModel vm = context.read<CodesViewModel>();

    return ExpansionTile(
      title: const Text('Сканирование позиций', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: !vm.state.allowEdit ? null : IconButton(
        tooltip: 'Отсканировать код маркировки',
        icon: const Icon(Icons.barcode_reader),
        onPressed: showScan
      ),
      children: vm.state.saleOrder.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildGroupCodesTile(BuildContext context) {
    CodesViewModel vm = context.read<CodesViewModel>();

    if (vm.state.lineCodes.none((e) => e.groupCode != null)) return Container();

    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('Агрегационные коды', style: TextStyle(fontSize: 14)),
      showTrailingIcon: false,
      children: vm.state.lineCodes.where((e) => e.groupCode != null).map((e) => e.groupCode).toSet().map((e) {
        return ExpansionTile(
          title: Text(e!, style: TextStyle(fontSize: 14)),
          initiallyExpanded: true,
          trailing: !vm.state.allowEdit ? null : IconButton(
            tooltip: 'Расформировать код агрегации',
            icon: const Icon(Icons.delete),
            onPressed: () => vm.clearGroupCodes(e)
          ),
          children: vm.state.lineCodes.where((lc) => lc.groupCode == e).map(
            (lc) => _buildGroupCodeLineTile(context, lc)
          ).toList()
        );
      }).toList()
    );
  }

  Widget _buildGroupCodeLineTile(BuildContext context, SaleOrderLineCode line) {
    CodesViewModel vm = context.read<CodesViewModel>();
    final saleOrderLine = vm.state.saleOrder.lines.firstWhere((e) => e.subid == line.subid);

    return ListTile(
      dense: true,
      title: Text(saleOrderLine.goodsName),
      trailing: Text(line.vol.toInt().toString())
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiSaleOrderLine line) {
    CodesViewModel vm = context.read<CodesViewModel>();

    if (vm.state.allTypeLineCodes.isNotEmpty) {
      final amount = vm.state.allTypeLineCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

      return ListTile(
        dense: true,
        title: Text(line.goodsName),
        trailing: Text('${amount.toInt()} из ${line.vol.toInt()}')
      );
    } else {
      final amount = vm.state.lineCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

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
            vm.state.allowEdit ? IconButton(
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
    CodesViewModel vm = context.read<CodesViewModel>();

    if (!vm.state.allowEdit) return [];

    if (vm.state.type == SaleOrderScanType.correction) {
      return [
        TextButton(onPressed: vm.tryCompleteScan, child: const Text('Завершить'))
      ];
    }

    return [
      vm.state.currentGroupCode == null ?
        TextButton(onPressed: showGroupScanView, child: const Text('Добавить АК')) :
        TextButton(onPressed: vm.completeGroupScan, child: const Text('Завершить АК')),
      TextButton(
        onPressed: vm.state.fullyScanned ? vm.tryCompleteScan : null,
        child: const Text('Завершить')
      )
    ];
  }
}
