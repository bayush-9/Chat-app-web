import 'package:chat_app/widgets/groups/group_icon_picker.dart';
import 'package:chat_app/widgets/groups/new_group_fields.dart';
import 'package:flutter/material.dart';

class NewGroupForm extends StatelessWidget {
  static const routeName = "/new-group";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("New Group"),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GroupIconPicker(null),
            NewGroupFields(),
          ],
        ),
      ),
    );
  }
}
