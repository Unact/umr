import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/utils/page_helpers.dart';
import '/app/widgets/widgets.dart';

part 'info_scan_state.dart';
part 'info_scan_view_model.dart';

class InfoScanPage extends StatelessWidget {
  final ApiMarkirovkaOrganization markirovkaOrganization;

  InfoScanPage({
    required this.markirovkaOrganization,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoScanViewModel>(
      create: (context) => InfoScanViewModel(
        RepositoryProvider.of<SaleOrdersRepository>(context),
        markirovkaOrganization: markirovkaOrganization
      ),
      child: _InfoScanView(),
    );
  }
}

class _InfoScanView extends StatefulWidget {
  @override
  _InfoScanViewState createState() => _InfoScanViewState();
}

class _InfoScanViewState extends State<_InfoScanView> {
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showInfoCodeManualInput() async {
    InfoScanViewModel vm = context.read<InfoScanViewModel>();
    TextEditingController codeController = TextEditingController();

    bool result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return SimpleAlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                enableInteractiveSelection: false,
                controller: codeController,
                decoration: const InputDecoration(labelText: 'Код'),
              )
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text(Strings.cancel)
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: const Text('Подтвердить')
            )
          ]
        );
      }
    ) ?? false;

    if (!result) return;

    await vm.infoScan(codeController.text);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InfoScanViewModel, InfoScanState>(
      builder: (context, state) {
        InfoScanViewModel vm = context.read<InfoScanViewModel>();

        return (vm.state.currentInfoScan == null)  ? _buildScanView(context) : _buildInfoView(context);
      },
      listener: (context, state) async {
        switch (state.status) {
          case InfoScanStateStatus.inProgress:
            await _progressDialog.open();
            break;
          case InfoScanStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case InfoScanStateStatus.success:
            _progressDialog.close();
            break;
          default:
        }
      }
    );
  }

  Widget _buildInfoListView(BuildContext context) {
    InfoScanViewModel vm = context.read<InfoScanViewModel>();
    ApiInfoScan infoScan = vm.state.currentInfoScan!;

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
                      Clipboard.setData(ClipboardData(text: infoScan.code));
                      PageHelpers.showMessage(context, 'Скопировано в буфер', Colors.green[400]!);
                    },
                    icon: Icon(Icons.copy)
                  ),
                  Flexible(child: Text(infoScan.code, style: TextStyle(color: Colors.black, fontSize: 13)))
                ]
              )
            ),
            InfoRow(title: const Text('GTIN штуки'), trailing: ExpandingText(infoScan.gtin)),
            InfoRow(
              title: const Text('Результат проверки'),
              trailing: ExpandingText(infoScan.codeErrorMessage ?? '')
            ),
            InfoRow(title: const Text('ИНН владельца'), trailing: ExpandingText(infoScan.ownerInn)),
            InfoRow(title: const Text('ОСУ'), trailing: ExpandingText(infoScan.isTracking ? 'Нет' : 'Да')),
          ])
        ),
        _buildSaleOrdersTile(infoScan.saleOrders, context)
      ],
    );
  }

  Widget _buildScanView(BuildContext context) {
    InfoScanViewModel vm = context.read<InfoScanViewModel>();

    return ScanView(
      actions: [
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.text_fields),
          tooltip: 'Ручной поиск',
          onPressed: showInfoCodeManualInput
        ),
      ],
      onRead: vm.infoScan,
      onError: (errorMessage) {
        PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
      },
      child: Container()
    );
  }

  Widget _buildInfoView(BuildContext context) {
    InfoScanViewModel vm = context.read<InfoScanViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Информация о коде')
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Отсканировать другой код',
        onPressed: vm.startNewScan,
        child: const Icon(Icons.scanner)
      ),
      body: _buildInfoListView(context)
    );
  }

  Widget _buildSaleOrdersTile(List<ApiInfoScanSaleOrder> saleOrders, BuildContext context) {
    return ExpansionTile(
      title: const Text('История движения по заказам', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      children: saleOrders.map((e) => _buildSaleOrderTile(context, e)).toList()
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
