import 'package:chat_app/providers/user.dart';
import 'package:chat_app/widgets/groups/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class GroupsScreenWork extends StatefulWidget {
  List<String> arr = [];
  List<String> groupIdList = <String>[];
  @override
  State<GroupsScreenWork> createState() => _GroupsScreenWorkState();
}

class _GroupsScreenWorkState extends State<GroupsScreenWork> {
  getdata() {
    Firestore.instance
        .collection("users")
        .document('LxOQI4GX4gbOIZnGKkNnLXbOYyX2')
        .get()
        .then((value) {
      // first add the data to the Offset object
      List.from(value.data['userGroups']).forEach((element) {
        String data = element;
        //then add the data to the List<Offset>, now we have a type Offset
        widget.groupIdList.add(data);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
        title: Text("Groups"),
      ),
      body: StreamBuilder(
        builder: (ctx, chatSnapshot) {
          getdata();

          if (chatSnapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          }
          final userRef = Firestore.instance.collection('groups');
          final userId =
              Provider.of<User>(context, listen: false).userId.toString();
          print(Firestore.instance
              .collection("users")
              .document(userId)
              .collection("userGroups")
              .document()
              .get());
          print(widget.groupIdList);
          userRef.getDocuments().then(
            (value) {
              value.documents.forEach(
                (element) {
                  widget.arr.add(element.documentID);
                },
              );
            },
          );
          final chatDocs = chatSnapshot.data.documents;
          final length = widget.groupIdList.length;
          return ListView.builder(
            itemBuilder: (context, index) {
              print(index.toString());
              return GroupTile(
                  chatDocs[index]['groupName'], widget.groupIdList[index]);
            },
            itemCount: length,
          );
        },
        stream: Firestore.instance.collection('groups').snapshots(),
      ),
    );
  }
}
