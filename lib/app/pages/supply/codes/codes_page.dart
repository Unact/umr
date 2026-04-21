import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/supplies_repository.dart';
import '/app/utils/page_helpers.dart';
import '/app/widgets/widgets.dart';
import 'scan/scan_page.dart';

part 'codes_state.dart';
part 'codes_view_model.dart';

class CodesPage extends StatelessWidget {
  final ApiSupply supply;

  CodesPage({
    required this.supply,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CodesViewModel>(
      create: (context) => CodesViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<SuppliesRepository>(context),
        supply: supply
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
        builder: (BuildContext context) => ScanPage(
          supply: vm.state.supply,
          pieceScan: result,
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
            title: Text('Поставка'),
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
              trailing: Text(
                vm.state.supply.linked ?
                  (vm.state.supply.allLineCodes.isEmpty ? 'Не отсканирован' : 'Отсканирован') :
                  'К поставке не привязаны КМ ЧЗ'
                )
            ),
            InfoRow(title: const Text('Уровень доверия'), trailing: Text(vm.state.supply.trustLevelName ?? ''))
          ])
        ),
        _buildOrderLinesTile(context)
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
      children: vm.state.supply.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiSupplyLine line) {
    CodesViewModel vm = context.read<CodesViewModel>();

    if (vm.state.supply.allLineCodes.isNotEmpty) {
      final amount = vm.state.supply.allLineCodes.where((e) => e.subid == line.subid).fold(0.0, (v, el) => v + el.vol);

      return ListTile(
        dense: true,
        title: Text(line.goodsName),
        trailing: Text('${amount.toInt()} из ${line.vol.toInt()}')
      );
    } else {
      final lineCodes = vm.state.lineCodes.where((e) => e.subid == line.subid);
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

    return [
      TextButton(onPressed: vm.tryCompleteScan, child: const Text('Завершить'))
    ];
  }
}
