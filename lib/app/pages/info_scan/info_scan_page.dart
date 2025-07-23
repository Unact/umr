import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/utils/page_helpers.dart';

part 'info_scan_state.dart';
part 'info_scan_view_model.dart';

class InfoScanPage extends StatelessWidget {
  final ApiInfoScan infoScan;

  InfoScanPage({
    required this.infoScan,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoScanViewModel>(
      create: (context) => InfoScanViewModel(infoScan: infoScan),
      child: _InfoScanView(),
    );
  }
}

class _InfoScanView extends StatefulWidget {
  @override
  _InfoScanViewState createState() => _InfoScanViewState();
}

class _InfoScanViewState extends State<_InfoScanView> {
  final TextStyle firstColumnTextStyle = const TextStyle(color: Colors.blue);
  final EdgeInsets firstColumnPadding = const EdgeInsets.only(top: 8.0, bottom: 4.0, right: 8.0);
  final EdgeInsets baseColumnPadding = const EdgeInsets.only(top: 8.0, bottom: 4.0);
  final TextStyle defaultTextStyle = const TextStyle(fontSize: 14.0, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о коде'),
      ),
      body: _buildBody(context)
    );
  }

  Widget _buildBody(BuildContext context) {
    InfoScanViewModel vm = context.read<InfoScanViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(
              title: const Text('Код'),
              trailing: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: vm.state.infoScan.code));
                      PageHelpers.showMessage(context, 'Скопировано в буфер', Colors.green[400]!);
                    },
                    icon: Icon(Icons.copy)
                  ),
                  Flexible(child: Text(vm.state.infoScan.code, style: TextStyle(color: Colors.black, fontSize: 13)))
                ]
              )
            ),
            InfoRow(title: const Text('GTIN штуки'), trailing: ExpandingText(vm.state.infoScan.gtin)),
            InfoRow(
              title: const Text('Результат проверки'),
              trailing: ExpandingText(vm.state.infoScan.codeErrorMessage ?? '')
            ),
            InfoRow(title: const Text('ИНН владельца'), trailing: ExpandingText(vm.state.infoScan.ownerInn)),
            InfoRow(title: const Text('ОСУ'), trailing: ExpandingText(vm.state.infoScan.isTracking ? 'Нет' : 'Да')),
          ])
        ),
        _buildSaleOrdersTile(context)
      ],
    );
  }

  Widget _buildSaleOrdersTile(BuildContext context) {
    InfoScanViewModel vm = context.read<InfoScanViewModel>();

    return ExpansionTile(
      title: const Text('История движения по заказам', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      children: vm.state.infoScan.saleOrders.map((e) => _buildSaleOrderTile(context, e)).toList()
    );
  }

  Widget _buildSaleOrderTile(BuildContext context, ApiInfoScanSaleOrder infoScanSaleOrder) {
    return ListTile(
      dense: true,
      title: Text(infoScanSaleOrder.ndoc),
      trailing: Text(infoScanSaleOrder.type == SaleOrderScanType.realization ? 'Продажа' : 'Возврат')
    );
  }
}
