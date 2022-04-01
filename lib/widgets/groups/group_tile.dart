import 'package:chat_app/providers/group.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupTile extends StatelessWidget {
  final String groupName;
  final String groupId;
  GroupTile(this.groupName, this.groupId);

  @override
  Widget build(BuildContext context) {
    return Card(
      shadowColor: Colors.blue,
      elevation: 1.5,
      child: ListTile(
        tileColor: Theme.of(context).backgroundColor,
        onTap: () {
          Provider.of<Groups>(context, listen: false)
              .setActiveGroup(groupId, groupName);
          Navigator.of(context).pushNamed(ChatScreen.routeName);
        },
        leading: CircleAvatar(),
        title: Text(
          groupName,
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
      ),
    );
  }
}
