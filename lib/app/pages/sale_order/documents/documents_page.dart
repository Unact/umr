import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/constants/strings.dart';
import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/sale_orders_repository.dart';
import '/app/utils/page_helpers.dart';

part 'documents_state.dart';
part 'documents_view_model.dart';

class DocumentsPage extends StatelessWidget {
  final ApiSaleOrder saleOrder;

  DocumentsPage({
    required this.saleOrder,
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<DocumentsViewModel>(
      create: (context) => DocumentsViewModel(
        RepositoryProvider.of<SaleOrdersRepository>(context),
        saleOrder: saleOrder
      ),
      child: _DocumentsView(),
    );
  }
}

class _DocumentsView extends StatefulWidget {
  @override
  _DocumentsViewState createState() => _DocumentsViewState();
}

class _DocumentsViewState extends State<_DocumentsView> {
  final TextStyle firstColumnTextStyle = const TextStyle(color: Colors.blue);
  final EdgeInsets firstColumnPadding = const EdgeInsets.only(top: 8.0, bottom: 4.0, right: 8.0);
  final EdgeInsets baseColumnPadding = const EdgeInsets.only(top: 8.0, bottom: 4.0);
  final TextStyle defaultTextStyle = const TextStyle(fontSize: 14.0, color: Colors.black);
  late final ProgressDialog _progressDialog = ProgressDialog(context: context);

  @override
  void dispose() {
    _progressDialog.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DocumentsViewModel, DocumentsState>(
      builder: (context, state) {
        return Scaffold(
          persistentFooterButtons: _buildFooterButtons(context),
          appBar: AppBar(
            title: Text('Маркировка паллет'),
          ),
          body: _buildBody(context)
        );
      },
      listener: (context, state) async {
        switch (state.status) {
          case DocumentsStateStatus.failure:
            PageHelpers.showMessage(context, state.message, Colors.red[400]!);
            break;
          case DocumentsStateStatus.success:
            PageHelpers.showMessage(context, state.message, Colors.green[400]!);
            break;
          default:
        }
      }
    );
  }

  Widget _buildBody(BuildContext context) {
    return ListView(
      children: [
        _buildDocumentTile(context)
      ],
    );
  }

  Widget _buildDocumentTile(BuildContext context) {
    DocumentsViewModel vm = context.read<DocumentsViewModel>();

    return ExpansionTile(
      title: const Text('Файлы', style: TextStyle(fontSize: 14)),
      initiallyExpanded: true,
      children: vm.state.saleOrder.documents.map((e) => _buildOrderDocumentTile(context, e)).toList()
    );
  }

  Widget _buildOrderDocumentTile(BuildContext context, ApiSaleOrderDocument document) {
    return ListTile(
      dense: true,
      title: Text(document.filename),
      trailing: Text(document.pageCount.toInt().toString()),
    );
  }

  Future<void> showPrinterScanView() async {
    DocumentsViewModel vm = context.read<DocumentsViewModel>();

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => ScanView(
          onRead: (String rawValue) {
            Navigator.pop(context);
            vm.printDocuments(rawValue);
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

  List<Widget> _buildFooterButtons(BuildContext context) {
    return [
      TextButton(
        onPressed: showPrinterScanView,
        child: const Text('Распечатать')
      )
    ];
  }
}
