import 'package:chat_app/providers/group.dart';
import 'package:chat_app/widgets/groups/group_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupList extends StatelessWidget {
  List<GroupId> groupIds;
  GroupList(this.groupIds);
  @override
  Widget build(BuildContext context) {
    return groupIds.isEmpty
        ? Text("You haven't been added to any group")
        : ListView.builder(
            itemBuilder: (context, index) {
              final String groupId = groupIds[index].id.toString().trim();
              print(groupId);
              return FutureBuilder(
                future: Firestore.instance
                    .collection('groups')
                    .document(groupId)
                    .get(),
                builder: (context, snapshot) {
                  print(Provider.of<Groups>(context, listen: false).groupsList);
                  if (snapshot.hasError) {
                    return Text("Something went wrong");
                  }

                  if (snapshot.hasData && !snapshot.data.exists) {
                    return Text("You haven't joined any group yet.");
                  }

                  if (snapshot.connectionState == ConnectionState.done) {
                    var data = snapshot.data;
                    print("data here");
                    print(data["groupName"]);
                    return GroupTile(data['groupName'], groupId);
                  }

                  return Text("");
                },
              );
            },
            itemCount: groupIds.length,
          );
  }
}
