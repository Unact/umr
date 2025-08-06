import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/utils/formatter.dart';
import '/app/utils/page_helpers.dart';
import 'scan/scan_page.dart';

part 'sale_order_state.dart';
part 'sale_order_view_model.dart';

class SaleOrderPage extends StatelessWidget {
  final ApiSaleOrder saleOrder;
  final SaleOrderScanType type;

  SaleOrderPage({
    required this.saleOrder,
    required this.type,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaleOrderViewModel>(
      create: (context) => SaleOrderViewModel(
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrder: saleOrder,
        type: type
      ),
      child: _SaleOrderView(),
    );
  }
}

class _SaleOrderView extends StatefulWidget {
  @override
  _SaleOrderViewState createState() => _SaleOrderViewState();
}

class _SaleOrderViewState extends State<_SaleOrderView> {
  final TextStyle firstColumnTextStyle = const TextStyle(color: Colors.blue);
  final EdgeInsets firstColumnPadding = const EdgeInsets.only(top: 8.0, bottom: 4.0, right: 8.0);
  final EdgeInsets baseColumnPadding = const EdgeInsets.only(top: 8.0, bottom: 4.0);
  final TextStyle defaultTextStyle = const TextStyle(fontSize: 14.0, color: Colors.black);
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showConfirmationDialog(String message) async {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    bool result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Подтверждение'),
        content: SingleChildScrollView(child: ListBody(children: <Widget>[Text(message)])),
        actions: <Widget>[
          TextButton(child: const Text(Strings.cancel), onPressed: () => Navigator.of(context).pop(false)),
          TextButton(child: const Text('Подтверждаю'), onPressed: () => Navigator.of(context).pop(true))
        ],
      )
    ) ?? false;

    vm.state.confirmationCallback(result);
  }

  Future<void> showScan() async {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

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
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          barcodeMode: true,
          initScanner: true,
          onRead: (String rawValue) {
            Navigator.pop(context);
            vm.startGroupScan(rawValue);
          },
          child: Container()
        ),
        fullscreenDialog: true
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SaleOrderViewModel, SaleOrderState>(
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
        switch (state.status) {
          case SaleOrderStateStatus.needUserConfirmation:
            WidgetsBinding.instance.addPostFrameCallback((_) async {
              await showConfirmationDialog(state.message);
            });
            break;
          case SaleOrderStateStatus.inProgress:
            _progressDialog.open();
            break;
          case SaleOrderStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case SaleOrderStateStatus.success:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(title: const Text('Номер'), trailing: Text(vm.state.saleOrder.ndoc)),
            InfoRow(title: const Text('Покупатель'), trailing: ExpandingText(vm.state.saleOrder.buyerName))
          ])
        ),
        _buildOrderLinesTile(context),
        _buildGroupCodesTile(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    return ExpansionTile(
      title: const Text('Позиции', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: vm.state.finished ? null : IconButton(
        tooltip: 'Отсканировать код маркировки',
        icon: const Icon(Icons.qr_code_scanner),
        onPressed: showScan
      ),
      children: vm.state.saleOrder.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildGroupCodesTile(BuildContext context) {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    if (vm.state.lineCodes.none((e) => e.groupCode != null)) return Container();

    return ExpansionTile(
      initiallyExpanded: true,
      title: Text('Агрегационные коды', style: TextStyle(fontSize: 14)),
      showTrailingIcon: false,
      children: vm.state.lineCodes.where((e) => e.groupCode != null).map((e) => e.groupCode).toSet().map((e) {
        return ExpansionTile(
          title: Text(e!, style: TextStyle(fontSize: 14)),
          initiallyExpanded: true,
          trailing: vm.state.finished ? null : IconButton(
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
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();
    final saleOrderLine = vm.state.saleOrder.lines.firstWhere((e) => e.subid == line.subid);

    return ListTile(
      dense: true,
      title: Text(saleOrderLine.goodsName),
      trailing: Text(line.vol.toInt().toString())
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiSaleOrderLine line) {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();
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
          vm.state.finished ? Text('${line.vol.toInt()}') : Text('${amount.toInt()} из ${line.vol.toInt()}'),
          !vm.state.finished ? IconButton(
            onPressed: () => vm.clearOrderLineCodes(line),
            icon: Icon(Icons.delete),
            tooltip: 'Удалить КМ',
          ) : null
        ].whereType<Widget>().toList()
      )
    );
  }

  List<Widget> _buildFooterButtons(BuildContext context) {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    if (vm.state.finished) return [];

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
