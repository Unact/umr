import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/supplies_repository.dart';
import 'codes/codes_page.dart';

part 'supply_state.dart';
part 'supply_view_model.dart';

class SupplyPage extends StatelessWidget {
  final ApiSupply supply;

  SupplyPage({
    required this.supply,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SupplyViewModel>(
      create: (context) => SupplyViewModel(
        RepositoryProvider.of<SuppliesRepository>(context),
        supply: supply
      ),
      child: _SupplyView(),
    );
  }
}

class _SupplyView extends StatefulWidget {
  @override
  _SupplyViewState createState() => _SupplyViewState();
}

class _SupplyViewState extends State<_SupplyView> {
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
    return BlocBuilder<SupplyViewModel, SupplyState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Поставка'),
          ),
          body: _buildBody(context)
        );
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    SupplyViewModel vm = context.read<SupplyViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(title: const Text('Номер'), trailing: Text(vm.state.supply.ndoc, style: TextStyle(fontSize: 13))),
            InfoRow(title: const Text('Поставщик'), trailing: ExpandingText(vm.state.supply.sellerName)),
          ])
        ),
        _buildOrderLinesTile(context),
        _buildOrderActions(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    SupplyViewModel vm = context.read<SupplyViewModel>();

    return ExpansionTile(
      title: const Text('Позиции', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      children: vm.state.supply.lines.map((e) => _buildSupplyLineTile(context, e)).toList()
    );
  }

  Widget _buildSupplyLineTile(BuildContext context, ApiSupplyLine line) {
    return ListTile(
      dense: true,
      title: Text(line.goodsName),
      trailing: Text(line.vol.toInt().toString()),
    );
  }

  Widget _buildOrderActions(BuildContext context) {
    SupplyViewModel vm = context.read<SupplyViewModel>();

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
                  supply: vm.state.supply
                )
              )
            );
          },
          child: const Text('Сканирование поставки')
        )
      ]
    );
  }
}
