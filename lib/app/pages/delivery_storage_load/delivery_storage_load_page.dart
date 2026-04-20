import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/delivery_storage_loads_repository.dart';
import '/app/utils/page_helpers.dart';

part 'delivery_storage_load_state.dart';
part 'delivery_storage_load_view_model.dart';

class DeliveryStorageLoadPage extends StatelessWidget {
  final ApiDeliveryStorageLoad deliveryStorageLoad;

  DeliveryStorageLoadPage({
    required this.deliveryStorageLoad,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DeliveryStorageLoadViewModel>(
      create: (context) => DeliveryStorageLoadViewModel(
        RepositoryProvider.of<DeliveryStorageLoadsRepository>(context),
        deliveryStorageLoad: deliveryStorageLoad
      ),
      child: _DeliveryStorageLoadView(),
    );
  }
}

class _DeliveryStorageLoadView extends StatefulWidget {
  @override
  _DeliveryStorageLoadViewState createState() => _DeliveryStorageLoadViewState();
}

class _DeliveryStorageLoadViewState extends State<_DeliveryStorageLoadView> {
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showScanView() async {
    DeliveryStorageLoadViewModel vm = context.read<DeliveryStorageLoadViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: (String rawValue) {
            vm.startLoadOrder(rawValue);
          },
          onError: (errorMessage) {
            PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
          },
          child: Text('Отсканируйте заказ', style: const TextStyle(color: Colors.white, fontSize: 20))
        ),
        fullscreenDialog: true
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DeliveryStorageLoadViewModel, DeliveryStorageLoadState>(
      builder: (context, state) {
        return Scaffold(
          persistentFooterButtons: _buildFooterButtons(context),
          appBar: AppBar(
            title: Text('Погрузка'),
          ),
          body: _buildBody(context)
        );
      },
      listener:(context, state) async {
        DeliveryStorageLoadViewModel vm = context.read<DeliveryStorageLoadViewModel>();

        switch (state.status) {
          case DeliveryStorageLoadStateStatus.needUserConfirmation:
            await PageHelpers.showConfirmationDialog(context, vm.completeDeliveryLoad, state.message);
            break;
          case DeliveryStorageLoadStateStatus.inProgress:
            await _progressDialog.open();
            break;
          case DeliveryStorageLoadStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case DeliveryStorageLoadStateStatus.completeDeliveryLoadSuccess:
          case DeliveryStorageLoadStateStatus.startLoadOrderSuccess:
            await _progressDialog.close();
            PageHelpers.showMessage(
              context,
              state.message,
              state.showWarning ? Colors.red[400]! : Colors.green[400]!
            );
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    DeliveryStorageLoadViewModel vm = context.read<DeliveryStorageLoadViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(
              title: const Text('Номер доставки'),
              trailing: Text(vm.state.deliveryStorageLoad.ndoc, style: TextStyle(fontSize: 13))
            ),
            InfoRow(
              title: const Text('Начало'),
              trailing: Text(Format.dateTimeStr(vm.state.deliveryStorageLoad.started), style: TextStyle(fontSize: 13))
            ),
            InfoRow(
              title: const Text('Конец'),
              trailing: Text(Format.dateTimeStr(vm.state.deliveryStorageLoad.finished), style: TextStyle(fontSize: 13))
            ),
          ])
        ),
        _buildDeliveryStorageLoadSaleOrdersTile(context)
      ],
    );
  }

  Widget _buildDeliveryStorageLoadSaleOrdersTile(BuildContext context) {
    DeliveryStorageLoadViewModel vm = context.read<DeliveryStorageLoadViewModel>();

    return ExpansionTile(
      title: const Text('Заказы', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: vm.state.deliveryStorageLoad.finished != null ?
        null :
        IconButton(
          tooltip: 'Отсканировать заказ',
          icon: const Icon(Icons.barcode_reader),
          onPressed: showScanView
        ),
      children: vm.state.deliveryStorageLoad.deliveryStorageLoadSaleOrders
        .map((e) => _buildDeliveryStorageLoadSaleOrderTile(context, e)).toList()
    );
  }

  Widget _buildDeliveryStorageLoadSaleOrderTile(
    BuildContext context,
    ApiDeliveryStorageLoadSaleOrder storageLoadSaleOrder
  ) {
    final startedIcon = storageLoadSaleOrder.warningMessage != null ?
      Icon(Icons.warning, color: Colors.red) :
      Icon(Icons.check, color: Colors.green);
    final scannedStr = storageLoadSaleOrder.started != null ? Format.dateTimeStr(storageLoadSaleOrder.started) : '';

    return ListTile(
      leading: storageLoadSaleOrder.started != null ? startedIcon : Icon(Icons.hourglass_empty, color: Colors.yellow),
      subtitle: Text('Начало погрузки: $scannedStr'),
      dense: true,
      title: Text(storageLoadSaleOrder.ndoc),
    );
  }

  List<Widget> _buildFooterButtons(BuildContext context) {
    DeliveryStorageLoadViewModel vm = context.read<DeliveryStorageLoadViewModel>();

    if (vm.state.deliveryStorageLoad.finished != null) return [];

    return [
      TextButton(
        onPressed: vm.state.allStarted ? vm.tryCompleteDeliveryLoad : null,
        child: const Text('Завершить')
      )
    ];
  }
}
