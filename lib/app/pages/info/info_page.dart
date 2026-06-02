import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/delivery_storage_load/delivery_storage_load_page.dart';
import '/app/pages/info_scan/info_scan_page.dart';
import '/app/pages/page_messages/page_messages_page.dart';
import '/app/pages/person/person_page.dart';
import '/app/pages/sale_order/sale_order_page.dart';
import '/app/pages/supply/supply_page.dart';
import '/app/pages/storage_group_code/storage_group_code_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
import '/app/repositories/delivery_storage_loads_repository.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/repositories/storage_group_codes_repository.dart';
import '/app/repositories/supplies_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/utils/page_helpers.dart';
import '/app/utils/renew_barcode.dart';
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
        RepositoryProvider.of<DeliveryStorageLoadsRepository>(context),
        RepositoryProvider.of<SaleOrdersRepository>(context),
        RepositoryProvider.of<StorageGroupCodesRepository>(context),
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

  Future<void> showPrinterScanView(Function(String) onRead) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: (String rawValue) {
            Navigator.pop(context);
            onRead.call(rawValue);
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

  Future<void> showScanView(String scanText, Function(String) onRead) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          actions: [
            IconButton(
              color: Colors.white,
              icon: const Icon(Icons.text_fields),
              tooltip: 'Ручной поиск',
              onPressed: () {
                Navigator.pop(context);
                showManualInput(onRead);
              }
            ),
          ],
          onRead: (scanResult) {
            Navigator.pop(context);
            onRead.call(scanResult);
          },
          onError: (errorMessage) {
            PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
          },
          child: Text(scanText, style: const TextStyle(color: Colors.white, fontSize: 20))
        ),
        fullscreenDialog: true
      )
    );
  }

  Future<void> showManualInput(Function(String) onRead) async {
    TextEditingController idController = TextEditingController();

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

  Future<void> showStorageCodeCountDialog() async {
    InfoViewModel vm = context.read<InfoViewModel>();

    final result = await showDialog<int?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        TextEditingController countController = TextEditingController();

        return StatefulBuilder(
          builder: (context, setState) {
            return SimpleAlertDialog(
              title: const Text('Укажите количество'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    TextFormField(
                      autocorrect: false,
                      controller: countController,
                      keyboardType: const TextInputType.numberWithOptions(),
                      decoration: const InputDecoration(labelText: 'Кол-во'),
                      onChanged: (value) => setState(() {})
                    )
                  ]
                )
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: int.tryParse(countController.text) == null ? null : () {
                    Navigator.of(context).pop(int.parse(countController.text));
                  },
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

    await showPrinterScanView((rawValue) => vm.printStorageGroupCodeLabels(result, rawValue));
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
        InfoViewModel vm = context.read<InfoViewModel>();

        switch (state.status) {
          case InfoStateStatus.inProgress:
            await _progressDialog.open();
            break;
          case InfoStateStatus.failure:
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
          case InfoStateStatus.findDeliveryStorageLoadSuccess:
            await _progressDialog.close();
            if (state.deliveryStorageLoadFind!.deliveryStorageLoad != null) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (BuildContext context) => DeliveryStorageLoadPage(
                    deliveryStorageLoad: state.deliveryStorageLoadFind!.deliveryStorageLoad!
                  ),
                  fullscreenDialog: false
                )
              );
            } else {
              showScanView(
                'Отсканируйте ворота',
                (warehouseGateStr) {
                  if (!state.deliveryStorageLoadFind!.needTruckScan) {
                    vm.createDeliveryStorageLoad(warehouseGateStr, null);
                    return;
                  }

                  showScanView(
                    'Отсканируйте машину',
                    (truckStr) => vm.createDeliveryStorageLoad(warehouseGateStr, truckStr)
                  );
                }
              );
            }
            break;
          case InfoStateStatus.findStorageGroupCodeSuccess:
            await _progressDialog.close();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => StorageGroupCodePage(
                  storageGroupCode: state.foundStorageGroupCode!
                ),
                fullscreenDialog: false
              )
            );
            break;
          case InfoStateStatus.findCodeParentSuccess:
            await _progressDialog.close();
            await showPrinterScanView((rawValue) => vm.printCodeLabel(rawValue));
            break;
          case InfoStateStatus.findDeliveryStorageLoadCreated:
            await _progressDialog.close();
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => DeliveryStorageLoadPage(
                  deliveryStorageLoad: state.createdDeliveryStorageLoad!
                ),
                fullscreenDialog: false
              )
            );
          case InfoStateStatus.deleteStorageGroupCodeSuccess:
          case InfoStateStatus.printLabelSuccess:
            await _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }

  Future<void> showMarkirovkaOrganizationDialog(Function(ApiMarkirovkaOrganization) onSelect) async {
    InfoViewModel vm = context.read<InfoViewModel>();

    if (vm.state.markirovkaOrganizations.isEmpty) {
      PageHelpers.showMessage(context, 'Организации еще не загружены', Colors.red[400]!);
      return;
    }

    final result = await showDialog<ApiMarkirovkaOrganization?>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        ApiMarkirovkaOrganization? selectedMarkirovkaOrganization =
          vm.state.markirovkaOrganizations.firstWhereOrNull((e) => e.isDefault);

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

    onSelect.call(result);
  }

  List<Widget> buildCards(BuildContext context) {
    return <Widget>[
      buildProcessCard(context),
      buildCodeCard(context),
      buildStorageGroupCodeCard(context),
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

  Widget buildProcessCard(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        title: Text('Процессы', style: TextStyle(fontSize: 20)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () => showScanView('Отсканируйте заказ', vm.findSaleOrder),
                child: const Text('Отбор')
              ),
              TextButton(
                onPressed: () => showScanView('Отсканируйте поставку', vm.findSupply),
                child: const Text('Приемка'),
              ),
              TextButton(
                onPressed: () => showScanView('Отсканируйте доставку', vm.findDeliveryStorageLoad),
                child: const Text('Погрузка')
              )
            ],
          )
        )
      )
    );
  }

  Widget buildCodeCard(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        title: Text('Коды маркировки', style: TextStyle(fontSize: 20)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  showMarkirovkaOrganizationDialog((result) => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => InfoScanPage(markirovkaOrganization: result),
                      fullscreenDialog: false
                    ))
                  );
                },
                child: const Text('Информация о КМ')
              ),
              TextButton(
                onPressed: () => showScanView('Отсканируйте КМ', vm.findCodeParent),
                child: const Text('Восстановить КМ')
              )
            ],
          )
        )
      )
    );
  }

  Widget buildStorageGroupCodeCard(BuildContext context) {
    InfoViewModel vm = context.read<InfoViewModel>();

    return Card(
      child: ListTile(
        isThreeLine: true,
        title: Text('Маркировка АК', style: TextStyle(fontSize: 20)),
        subtitle: Padding(
          padding: EdgeInsets.only(top: 8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              TextButton(
                onPressed: () {
                  showMarkirovkaOrganizationDialog((result) => {
                    showScanView('Отсканируйте АК', (groupCode) => vm.findStorageGroupCode(groupCode, result)),
                  });
                },
                child: const Text('Сформировать')
              ),
              TextButton(
                onPressed: () => showScanView('Отсканируйте АК', vm.deleteStorageGroupCode),
                child: const Text('Расформировать')
              ),
              TextButton(
                onPressed: showStorageCodeCountDialog,
                child: const Text('Распечатать')
              ),
            ],
          )
        )
      )
    );
  }
}
