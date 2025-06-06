import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/person/person_page.dart';
import '/app/pages/sale_order/sale_order_page.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/repositories/users_repository.dart';
import '/app/utils/formatter.dart';
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

  Future<void> showScanView(SaleOrderScanType type) async {
    InfoViewModel vm = context.read<InfoViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          showScanner: true,
          actions: [
            IconButton(
                color: Colors.white,
                icon: const Icon(Icons.text_fields),
                tooltip: 'Ручной поиск',
                onPressed: () {
                  Navigator.pop(context);
                  showManualInput(type);
                }
              ),
          ],
          onRead: (String rawValue) {
            Navigator.pop(context);
            vm.findSaleOrder(rawValue, type);
          },
          child: Container()
        ),
        fullscreenDialog: true
      )
    );
  }

  Future<void> showManualInput(SaleOrderScanType type) async {
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
              onPressed: () async {
                Navigator.of(context).pop(true);
              },
              child: const Text('Подтвердить')
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Отменить')
            )
          ]
        );
      }
    ) ?? false;

    if (!result) return;

    await vm.findSaleOrder(ndocController.text, type);
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
          case InfoStateStatus.inProgress:
            await _progressDialog.open();
            break;
          case InfoStateStatus.failure:
            _progressDialog.close();
            Misc.showSnackBar(context, SnackBar(content: Text(state.message), backgroundColor: Colors.red[400]));
            break;
          case InfoStateStatus.success:
            _progressDialog.close();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (BuildContext context) => SaleOrderPage(saleOrder: state.foundSaleOrder!, type: state.type!),
                fullscreenDialog: false
              )
            );
            break;
          default:
        }
      }
    );
  }

  List<Widget> buildInfoCards(BuildContext context) {
    return <Widget>[
      buildScanCard(context)
    ];
  }

  Widget buildScanCard(BuildContext context) {
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
                onPressed: () => showScanView(SaleOrderScanType.realization)
              ),
              const SizedBox(width: 8),
              TextButton(
                child: const Text('Возврат'),
                onPressed: () => showScanView(SaleOrderScanType.correction)
              ),
            ],
          ),
        ],
      ),
    );
  }
}
