import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/constants/styles.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/rreturned_acts_repository.dart';
import '/app/utils/page_helpers.dart';

part 'rreturned_acts_state.dart';
part 'rreturned_acts_view_model.dart';

class RreturnedActsPage extends StatelessWidget {
  final ApiRreturnedAct rreturnedAct;

  RreturnedActsPage({
    required this.rreturnedAct,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RreturnedActsViewModel>(
      create: (context) => RreturnedActsViewModel(
        RepositoryProvider.of<RreturnedActsRepository>(context),
        rreturnedAct: rreturnedAct
      ),
      child: _RreturnedActsView(),
    );
  }
}

class _RreturnedActsView extends StatefulWidget {
  @override
  _RreturnedActsViewState createState() => _RreturnedActsViewState();
}

class _RreturnedActsViewState extends State<_RreturnedActsView> {
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);
  final player = AudioPlayer();

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  Future<void> showScan() async {
    RreturnedActsViewModel vm = context.read<RreturnedActsViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: (scanResult) => vm.scan(scanResult),
          onError: (errorMessage) {
            PageHelpers.showMessage(context, errorMessage ?? Strings.genericErrorMsg, Colors.red[400]!);
          },
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Text('Отсканируйте код', style: Styles.scanTitleText)
              )
            ]
          )
        ),
        fullscreenDialog: true
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RreturnedActsViewModel, RreturnedActsState>(
      builder: (context, state) {
        return Scaffold(
          persistentFooterButtons: _buildFooterButtons(context),
          appBar: AppBar(
            title: Text('Акт возврата'),
          ),
          body: _buildBody(context)
        );
      },
      listener: (context, state) async {
        RreturnedActsViewModel vm = context.read<RreturnedActsViewModel>();

        switch (state.status) {
          case RreturnedActsStateStatus.needUserConfirmation:
            await PageHelpers.showConfirmationDialog(context, vm.completeScan, state.message);
            break;
          case RreturnedActsStateStatus.scanFailure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            await player.play(AssetSource('beep_error.mp3'));
            break;
          case RreturnedActsStateStatus.scanSuccess:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            await player.play(AssetSource('beep_success.mp3'));
            break;
          case RreturnedActsStateStatus.inProgress:
            _progressDialog.open();
            break;
          case RreturnedActsStateStatus.dataLoaded:
            _progressDialog.close();
            break;
          case RreturnedActsStateStatus.failure:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case RreturnedActsStateStatus.success:
            _progressDialog.close();
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    RreturnedActsViewModel vm = context.read<RreturnedActsViewModel>();

    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
          child: Column(children: [
            InfoRow(
              title: const Text('Номер'),
              trailing: Text(vm.state.rreturnedAct.ndoc, style: TextStyle(fontSize: 13))
            ),
            InfoRow(title: const Text('Покупатель'), trailing: ExpandingText(vm.state.rreturnedAct.buyerName)),
            InfoRow(
              title: const Text('Отсканирован складом'),
              trailing: Text(Format.dateTimeStr(vm.state.rreturnedAct.storageScanned))
            )
          ])
        ),
        _buildOrderLinesTile(context)
      ],
    );
  }

  Widget _buildOrderLinesTile(BuildContext context) {
    RreturnedActsViewModel vm = context.read<RreturnedActsViewModel>();

    return ExpansionTile(
      title: const Text('Сканирование позиций', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      trailing: vm.state.rreturnedAct.storageScanned != null ? null : IconButton(
        tooltip: 'Отсканировать код маркировки',
        icon: const Icon(Icons.barcode_reader),
        onPressed: showScan
      ),
      children: vm.state.rreturnedAct.lines.map((e) => _buildOrderLineTile(context, e)).toList()
    );
  }

  Widget _buildOrderLineTile(BuildContext context, ApiRreturnedActLine line) {
    RreturnedActsViewModel vm = context.read<RreturnedActsViewModel>();
    final amount = line.volume;
    final scannedAmount = line.storageScanned == null ? 0 : line.volume;

    if (vm.state.rreturnedAct.storageScanned != null) {
      return ListTile(
        dense: true,
        title: Text(line.goodsName),
        trailing: Text('${scannedAmount.toInt()} из ${amount.toInt()}')
      );
    } else {
      return ListTile(
        dense: true,
        leading: amount == scannedAmount ?
          Icon(Icons.check, color: Colors.green) :
          Icon(Icons.hourglass_empty, color: Colors.yellow),
        title: Text(line.goodsName),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${scannedAmount.toInt()} из ${amount.toInt()}'),
            vm.state.rreturnedAct.storageScanned == null ? IconButton(
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
    RreturnedActsViewModel vm = context.read<RreturnedActsViewModel>();

    if (vm.state.rreturnedAct.storageScanned != null) return [];

    return [
      TextButton(onPressed: vm.tryCompleteScan, child: const Text('Завершить'))
    ];
  }
}
