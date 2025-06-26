import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  ScanPage({
    required this.saleOrder,
    required this.type,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanViewModel>(
      create: (context) => ScanViewModel(
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrder: saleOrder,
        type: type
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
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ScanViewModel, ScanState>(
      builder: (context, state) {
        final vm = context.read<ScanViewModel>();

        return ScanView(
          showScanner: true,
          onRead: vm.readCode,
          barcodeMode: true,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: const Text('Отсканируйте КМ', style: Styles.scanTitleText)
              )
            ]
          )
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case ScanStateStatus.failure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case ScanStateStatus.success:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }
}
