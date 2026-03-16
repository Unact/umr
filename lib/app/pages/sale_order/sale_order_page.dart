import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';
import 'package:umr/app/data/database.dart';

import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/sale_orders_repository.dart';
import 'codes/codes_page.dart';
import 'documents/documents_page.dart';

part 'sale_order_state.dart';
part 'sale_order_view_model.dart';

class SaleOrderPage extends StatelessWidget {
  final ApiSaleOrder saleOrder;

  SaleOrderPage({
    required this.saleOrder,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SaleOrderViewModel>(
      create: (context) => SaleOrderViewModel(
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrder: saleOrder
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

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SaleOrderViewModel, SaleOrderState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Заказ'),
          ),
          body: _buildBody(context)
        );
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
            InfoRow(
              title: const Text('Номер'),
              trailing: Text(vm.state.saleOrder.ndoc, style: TextStyle(fontSize: 13))
            ),
            InfoRow(title: const Text('Покупатель'), trailing: ExpandingText(vm.state.saleOrder.buyerName)),
          ])
        ),
        _buildOrderLinesTile(context),
        _buildOrderActions(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    return ExpansionTile(
      title: const Text('Позиции', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      children: vm.state.saleOrder.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiSaleOrderLine line) {
    return ListTile(
      dense: true,
      title: Text(line.goodsName),
      trailing: Text(line.vol.toInt().toString()),
    );
  }

  Widget _buildOrderActions(BuildContext context) {
    SaleOrderViewModel vm = context.read<SaleOrderViewModel>();

    return ExpansionTile(
      title: const Text('Действия', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      childrenPadding: EdgeInsets.symmetric(horizontal: 24),
      expandedCrossAxisAlignment: CrossAxisAlignment.start,
      expandedAlignment: Alignment.centerLeft,
      children: [
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CodesPage(
                  saleOrder: vm.state.saleOrder,
                  type: SaleOrderScanType.realization
                )
              )
            );
          },
          child: const Text('Сканирование заказа')
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => CodesPage(
                  saleOrder: vm.state.saleOrder,
                  type: SaleOrderScanType.correction
                )
              )
            );
          },
          child: const Text('Сканирование возврата')
        ),
        TextButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DocumentsPage(
                  saleOrder: vm.state.saleOrder
                )
              )
            );
          },
          child: const Text('Печать маркировки')
        )
      ]
    );
  }
}
