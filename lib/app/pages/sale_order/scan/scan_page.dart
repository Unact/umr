import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:soundpool/soundpool.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/data/database.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/utils/formatter.dart';
import '/app/utils/page_helpers.dart';

part 'scan_state.dart';
part 'scan_view_model.dart';

class ScanPage extends StatelessWidget {
  final ApiSaleOrder saleOrder;
  final SaleOrderScanType type;
  final String? groupCode;

  ScanPage({
    required this.saleOrder,
    required this.type,
    required this.groupCode,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanViewModel>(
      create: (context) => ScanViewModel(
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrder: saleOrder,
        type: type,
        groupCode: groupCode
      ),
      child: _ScanView(),
    );
  }
}

class _ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<_ScanView> {
  static final Soundpool _kPool = Soundpool.fromOptions(options: const SoundpoolOptions());
  static final Future<int> _kErrorBeepId = rootBundle
    .load('assets/beep_error.mp3')
    .then((soundData) => _kPool.load(soundData));
  static final Future<int> _kSuccessBeepId = rootBundle
    .load('assets/beep_success.mp3')
    .then((soundData) => _kPool.load(soundData));

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanViewModel, ScanState>(
      builder: (context, state) {
        final vm = context.read<ScanViewModel>();

        return ScanView(
          onRead: vm.readCode,
          barcodeMode: true,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Text('Отсканируйте код', style: Styles.scanTitleText)
              )
            ]
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case ScanStateStatus.failure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            await _kPool.play(await _kErrorBeepId);
            break;
          case ScanStateStatus.success:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            await _kPool.play(await _kSuccessBeepId);
            break;
          default:
        }
      }
    );
  }
}
