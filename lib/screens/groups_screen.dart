import 'package:chat_app/providers/user.dart';
import 'package:chat_app/widgets/groups/group_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

class GroupsScreen extends StatefulWidget {
  List<String> arr = [];

  @override
  State<GroupsScreen> createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
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
              .document());

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
          return ListView.builder(
            itemBuilder: (context, index) {
              print(index.toString());
              return GroupTile(chatDocs[index]['groupName'], widget.arr[index]);
            },
            itemCount: chatDocs.length,
          );
        },
        stream: Firestore.instance.collection('groups').snapshots(),
      ),
    );
  }
}
