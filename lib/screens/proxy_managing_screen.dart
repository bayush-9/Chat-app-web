import 'package:chat_app/providers/group.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/widgets/proxy/subject_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProxyManagementScreen extends StatefulWidget {
  static const routeName = '/proxy-management-screen';
  @override
  _ProxyManagementScreenState createState() => _ProxyManagementScreenState();
}

class _ProxyManagementScreenState extends State<ProxyManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final activeGroup = Provider.of<Groups>(context, listen: false).activeGroup;
    final activeUser = Provider.of<User>(context, listen: false);
    TextEditingController newLectureName;
    _submit(String name) {
      Firestore.instance
          .collection('groups')
          .document(activeGroup.id)
          .collection('proxyStatus')
          .add({
        'lectureName': name,
        'people': [],
        'timeStamp': DateTime.now(),
        'status': [0, 0],
      });
    }

    _registerNewLecture() {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Text("Add new lecture"),
          content: TextField(
            decoration: InputDecoration(
              labelText: "Lecture title",
            ),
            onSubmitted: (name) {
              if (name.isEmpty) {
                return;
              }
              _submit(name);
              Navigator.pop(context);
            },
          ),
        ),
      );
    }

    void _attendThisLecture(String name, String subjectId) {
      print(name);
      print(subjectId);
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('Plan your presence'),
      ),
      body: Column(
        children: [
          ListTile(
            title: Text(
              'Lecture                Status            Choice',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.bodyText1.color),
            ),
          ),
          Expanded(
            child: StreamBuilder(
              builder: (ctx, lectureSnapshot) {
                if (lectureSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return CircularProgressIndicator();
                }
                final chatDocs = lectureSnapshot.data.documents;
                if (chatDocs != null)
                  return ListView.builder(
                    itemBuilder: (context, index) {
                      bool contains = false;
                      // if (chatDocs[index]['people']) {}
                      List<dynamic> ids = chatDocs[index]['people'];
                      if (ids != null && ids.contains(activeUser.userId)) {
                        contains = true;
                      }
                      return ListTile(
                        title: SubjectTile(
                          userIds: chatDocs[index]['people'],
                          absent: chatDocs[index]['status'][0],
                          lectureName: chatDocs[index]['lectureName'],
                          present: chatDocs[index]['status'][1],
                          hasUpdated: contains,
                          removePerson: () async => {
                            await Firestore.instance.runTransaction(
                              (Transaction myTransaction) async {
                                await myTransaction.update(
                                  lectureSnapshot
                                      .data.documents[index].reference,
                                  {
                                    "status": [
                                      chatDocs[index]['status'][0],
                                      chatDocs[index]['status'][1] - 1
                                    ],
                                    "people": FieldValue.arrayRemove(
                                        [activeUser.userId]),
                                  },
                                );
                              },
                            ),
                          },
                          addPerson: () async => {
                            await Firestore.instance.runTransaction(
                              (Transaction myTransaction) async {
                                await myTransaction.update(
                                  lectureSnapshot
                                      .data.documents[index].reference,
                                  {
                                    "status": [
                                      chatDocs[index]['status'][0],
                                      chatDocs[index]['status'][1] + 1
                                    ],
                                    "people": FieldValue.arrayUnion(
                                        [activeUser.userId]),
                                  },
                                );
                              },
                            ),
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(
                            Icons.delete,
                            color: Colors.blue,
                          ),
                          onPressed: () async => {
                            await Firestore.instance.runTransaction(
                              (Transaction myTransaction) async {
                                await myTransaction.delete(lectureSnapshot
                                    .data.documents[index].reference);
                              },
                            ),
                          },
                        ),
                      );
                    },
                    itemCount: chatDocs.length,
                  );
                return Center(child: Text(""));
              },
              stream: Firestore.instance
                  .collection('groups')
                  .document(activeGroup.id)
                  .collection('proxyStatus')
                  .snapshots(),
            ),
          ),
          FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: _registerNewLecture,
          ),
        ],
      ),
    );
  }
}
