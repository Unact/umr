import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/info_scan/info_scan_page.dart';
import '/app/pages/person/person_page.dart';
import '/app/pages/sale_order/sale_order_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/utils/formatter.dart';
import '/app/utils/page_helpers.dart';
import '/app/widgets/widgets.dart';

part 'info_state.dart';
part 'info_view_model.dart';

class InfoPage extends StatelessWidget {
  InfoPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<InfoViewModel>(
      create: (context) => InfoViewModel(
        RepositoryProvider.of<AppRepository>(context),
        RepositoryProvider.of<SaleOrdersRepository>(context),
        RepositoryProvider.of<UsersRepository>(context)
      ),
      child: _InfoView(),
    );
  }
}

class _InfoView extends StatefulWidget {
  @override
  _InfoViewState createState() => _InfoViewState();
}

class _InfoViewState extends State<_InfoView> {
  final ScrollController scrollController = ScrollController();
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showSaleOrderScanView(SaleOrderScanType type) async {
    InfoViewModel vm = context.read<InfoViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          barcodeMode: true,
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.text_fields),
              tooltip: 'Ручной поиск',
              onPressed: () {
                Navigator.pop(context);
                showSaleOrderManualInput(type);
              }
            ),
          ],
          onRead: (String rawValue) {
            Navigator.pop(context);
            vm.findSaleOrder(type, rawValue);
          },
          child: Container()
        ),
        fullscreenDialog: true
      )
    );
  }

  Future<void> showSaleOrderManualInput(SaleOrderScanType type) async {
    InfoViewModel vm = context.read<InfoViewModel>();
    TextEditingController ndocController = TextEditingController();

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
                controller: ndocController,
                decoration: const InputDecoration(labelText: 'Номер'),
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

    await vm.findSaleOrder(type, ndocController.text);
  }

  Future<void> showInfoCodeScanView(ApiMarkirovkaOrganization markirovkaOrganization) async {
    InfoViewModel vm = context.read<InfoViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          barcodeMode: true,
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.text_fields),
              tooltip: 'Ручной поиск',
              onPressed: () {
                Navigator.pop(context);
                showInfoCodeManualInput(markirovkaOrganization);
              }
            ),
          ],
          onRead: (String rawValue) {
            Navigator.pop(context);
            vm.infoScan(markirovkaOrganization, rawValue);
          },
          child: Container()
        ),
        fullscreenDialog: true
      )
    );
  }

  Future<void> showInfoCodeManualInput(ApiMarkirovkaOrganization markirovkaOrganization) async {
    InfoViewModel vm = context.read<InfoViewModel>();
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

    await vm.infoScan(markirovkaOrganization, codeController.text);
  }

  Future<void> showClearSaleOrderLineCodesDialog() async {
    InfoViewModel vm = context.read<InfoViewModel>();

    bool result = await showDialog<bool>(
      context: context,
      builder: (context) {
        return SimpleAlertDialog(
          title: Text('Вы точно хотите удалить данные о КМ?'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: const Text('Да')
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Нет')
            )
          ]
        );
      }
    ) ?? false;

    if (!result) return;

    await vm.clearSaleOrderLineCodes();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InfoViewModel, InfoState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.ruAppName),
            actions: <Widget>[
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.person),
                tooltip: 'Пользователь',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PersonPage(),
                      fullscreenDialog: false
                    )
                  );
                }
              )
            ]
          ),
          body: ListView(
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
            children: <Widget>[
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: buildInfoCards(context)
              )
            ],
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case InfoStateStatus.infoScanInProgress:
          case InfoStateStatus.findSaleOrderInProgress:
            await _progressDialog.open();
            break;
          case InfoStateStatus.infoScanFailure:
          case InfoStateStatus.findSaleOrderFailure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case InfoStateStatus.findSaleOrderSuccess:
            _progressDialog.close();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SaleOrderPage(saleOrder: state.foundSaleOrder!, type: state.type!),
                fullscreenDialog: false
              )
            );
            break;
          case InfoStateStatus.infoScanSuccess:
            _progressDialog.close();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => InfoScanPage(infoScan: state.infoScan!),
                fullscreenDialog: false
              )
            );
            break;
          case InfoStateStatus.loadMarkirovkaOrganizationFailure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case InfoStateStatus.loadMarkirovkaOrganizationSuccess:
            await showMarkirovkaOrganizationDialog();
            break;
          default:
        }
      }
    );
  }

  Future<void> showMarkirovkaOrganizationDialog() async {
    InfoViewModel vm = context.read<InfoViewModel>();

    final result = await showDialog<ApiMarkirovkaOrganization?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        ApiMarkirovkaOrganization? selectedMarkirovkaOrganization;

        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleAlertDialog(
              title: const Text('Укажите организацию'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    DropdownButtonFormField(
                      isExpanded: true,
                      menuMaxHeight: 200,
                      decoration: const InputDecoration(labelText: 'Организация'),
                      value: selectedMarkirovkaOrganization,
                      items: vm.state.markirovkaOrganizations.map((e) => DropdownMenuItem(
                        value: e,
                        child: Text(e.name)
                      )).toList(),
                      onChanged: (newVal) => setState(() => selectedMarkirovkaOrganization = newVal)
                    )
                  ]
                )
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: selectedMarkirovkaOrganization == null ?
                    null :
                    () => Navigator.of(context).pop(selectedMarkirovkaOrganization),
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

    showInfoCodeScanView(result);
  }

  List<Widget> buildInfoCards(BuildContext context) {
    return <Widget>[
      buildScanCard(context)
    ];
  }

  Widget buildScanCard(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return Card(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            title: Text('Сканирование', style: TextStyle(fontSize: 20)),
            trailing: IconButton(
              onPressed: showClearSaleOrderLineCodesDialog,
              icon: Icon(Icons.delete),
              tooltip: 'Удалить данные',
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                child: const Text('Заказ'),
                onPressed: () => showSaleOrderScanView(SaleOrderScanType.realization)
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Возврат'),
                onPressed: () => showSaleOrderScanView(SaleOrderScanType.correction)
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () => vm.loadMarkirovkaOrganizations(),
                child: const Text('Инфо')
              )
            ],
          ),
        ],
      ),
    );
  }
}
