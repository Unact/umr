import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/styles.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';

part 'scan_state.dart';
part 'scan_view_model.dart';

class ScanPage extends StatelessWidget {
  ScanPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ScanViewModel>(
      create: (context) => ScanViewModel(
        RepositoryProvider.of<AppRepository>(context),
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
          case ScanStateStatus.loadFailure:
            Misc.showMessage(context, state.message);
            Navigator.of(context).pop();
            break;
          case ScanStateStatus.loadFinished:
            break;
          case ScanStateStatus.scanFailure:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.red[400])
            );
            break;
          case ScanStateStatus.scanFinished:
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message), backgroundColor: Colors.green[400])
            );
            break;
          default:
        }
      }
    );
  }
}
