import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/info_scan/info_scan_page.dart';
import '/app/pages/page_messages/page_messages_page.dart';
import '/app/pages/person/person_page.dart';
import '/app/pages/sale_order/sale_order_page.dart';
import '/app/pages/supply/supply_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/repositories/supplies_repository.dart';
import '/app/repositories/users_repository.dart';
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
        RepositoryProvider.of<SuppliesRepository>(context),
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

  Future<void> showPrinterScanView() async {
    InfoViewModel vm = context.read<InfoViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: (String rawValue) {
            Navigator.pop(context);
            vm.printCodeLabel(rawValue);
          },
          onError: (errorMessage) {
            PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
          },
          child: Text('Отсканируйте принтер', style: const TextStyle(color: Colors.white, fontSize: 20))
        ),
        fullscreenDialog: true
      )
    );
  }

  Future<void> showScanView(Function(String) onRead) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.text_fields),
              tooltip: 'Ручной поиск',
              onPressed: () => showManualInput(onRead)
            ),
          ],
          onRead: (String code) {
            Navigator.of(context).pop();
            onRead.call(code);
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

  Future<void> showManualInput(Function(String) onRead) async {
    TextEditingController idController = TextEditingController();

    Navigator.of(context).pop();
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
                controller: idController
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

    onRead.call(idController.text);
  }

  Future<void> showClearLineCodesDialog() async {
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

    await vm.clearLineCodes();
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
                onPressed: showClearLineCodesDialog,
                icon: Icon(Icons.delete),
                tooltip: 'Удалить данные',
              ),
              IconButton(
                color: Colors.white,
                icon: const Icon(Icons.notifications),
                tooltip: 'Уведомления',
                onPressed: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => PageMessagesPage(),
                      fullscreenDialog: true
                    )
                  );
                }
              ),
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
                children: buildCards(context)
              )
            ],
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case InfoStateStatus.printCodeLabelInProgress:
          case InfoStateStatus.findCodeParentInProgress:
          case InfoStateStatus.findSupplyInProgress:
          case InfoStateStatus.findSaleOrderInProgress:
            await _progressDialog.open();
            break;
          case InfoStateStatus.printCodeLabelFailure:
          case InfoStateStatus.findCodeParentFailure:
          case InfoStateStatus.findSupplyFailure:
          case InfoStateStatus.findSaleOrderFailure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case InfoStateStatus.findSaleOrderSuccess:
            await _progressDialog.close();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SaleOrderPage(saleOrder: state.foundSaleOrder!),
                fullscreenDialog: false
              )
            );
            break;
          case InfoStateStatus.findSupplySuccess:
            await _progressDialog.close();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SupplyPage(supply: state.foundSupply!),
                fullscreenDialog: false
              )
            );
            break;
          case InfoStateStatus.findCodeParentSuccess:
            await _progressDialog.close();
            await showPrinterScanView();
            break;
          case InfoStateStatus.printCodeLabelSuccess:
            await _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
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
                      initialValue: selectedMarkirovkaOrganization,
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

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => InfoScanPage(markirovkaOrganization: result),
        fullscreenDialog: false
      )
    );
  }

  List<Widget> buildCards(BuildContext context) {
    return <Widget>[
      buildOrderCard(context),
      buildInfoCard(context)
    ];
  }

  Widget buildInfoCard(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return FutureBuilder(
      future: vm.state.user?.newVersionAvailable,
      builder: (context, snapshot) {
        if (!(snapshot.data ?? false)) return Container();

        return const Card(
          child: ListTile(
            isThreeLine: true,
            title: Text('Информация', style: TextStyle(fontSize: 20)),
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            subtitle: Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16),
              child: Text('Доступна новая версия приложения')
            )
          )
        );
      }
    );
  }

  Widget buildOrderCard(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        title: Text('Действия', style: TextStyle(fontSize: 20)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                child: const Text('Работа с заказом'),
                onPressed: () => showScanView(vm.findSaleOrder)
              ),
              TextButton(
                child: const Text('Работа с поставкой'),
                onPressed: () => showScanView(vm.findSupply)
              ),
              TextButton(
                onPressed: () => vm.loadMarkirovkaOrganizations(),
                child: const Text('Получить информацию о КМ')
              ),
              TextButton(
                onPressed: () => showScanView(vm.findCodeParent),
                child: const Text('Восстановить КМ')
              )
            ],
          )
        )
      )
    );
  }
}
