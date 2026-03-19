import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:u_app_utils/u_app_utils.dart';

import '/app/entities/entities.dart';
import '/app/pages/shared/page_view_model.dart';
import '/app/repositories/app_repository.dart';
part 'page_messages_state.dart';
part 'page_messages_view_model.dart';

class PageMessagesPage extends StatelessWidget {
  PageMessagesPage({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider<PageMessagesViewModel>(
      create: (context) => PageMessagesViewModel(
        RepositoryProvider.of<AppRepository>(context)
      ),
      child: _PageMessagesView(),
    );
  }
}

class _PageMessagesView extends StatefulWidget {
  @override
  _PageMessagesViewState createState() => _PageMessagesViewState();
}

class _PageMessagesViewState extends State<_PageMessagesView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PageMessagesViewModel, PageMessagesState>(
      builder: (context, state) {
        PageMessagesViewModel vm = context.read<PageMessagesViewModel>();

        return Scaffold(
          appBar: AppBar(
            title: const Text('Уведомления'),
          ),
          body: ListView(
            padding: const EdgeInsets.only(top: 24, left: 8, right: 8, bottom: 24),
            children: vm.state.pageMessages.map((e) {
              return ListTile(title: Text(e.message), subtitle: Text(Format.dateTimeStr(e.date)));
            }).toList()
          )
        );
      }
    );
  }
}
