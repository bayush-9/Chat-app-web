import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  String lectureName;
  Function addPerson;
  Function removePerson;
  List<dynamic> userIds;
  int present;
  int absent;
  bool hasUpdated;

  SubjectTile(
      {this.lectureName,
      this.present,
      this.removePerson,
      this.userIds,
      this.absent,
      this.hasUpdated,
      this.addPerson});
  @override
  Widget build(BuildContext context) {
    showInfo() {
      print(userIds);
      return showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          backgroundColor: Theme.of(context).dialogTheme.backgroundColor,
          title: Text("List of people"),
          content: userIds.length == 0
              ? Text(
                  "Seems like everyone is up to date ;).",
                  style: TextStyle(
                      color: Theme.of(context).textTheme.bodyText1.color),
                )
              : Container(
                  height: 20.0 * userIds.length,
                  width: MediaQuery.of(context).size.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return FutureBuilder(
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Text(
                              "Loading...",
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                            );
                          }
                          print(snapshot.data['username']);
                          return Text(
                            snapshot.data['username'],
                            style: TextStyle(
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .color),
                          );
                        },
                        future: Firestore.instance
                            .collection('users')
                            .document(userIds[index].toString().trim())
                            .get(),
                      );
                    },
                    itemCount: userIds.length,
                  ),
                ),
          actions: <Widget>[
            FlatButton(
              color: Colors.white,
              onPressed: () {
                Navigator.of(ctx).pop();
              },
              child: Text("Okay"),
            ),
          ],
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          lectureName + "         ",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        IconButton(
          onPressed: showInfo,
          icon: Icon(Icons.info_outline_rounded),
        ),
        Text(
          present.toString() + "/" + absent.toString() + "   ",
          style: TextStyle(color: Theme.of(context).textTheme.bodyText1.color),
        ),
        IconButton(
          icon: Icon(!hasUpdated
              ? Icons.group_add_sharp
              : Icons.person_remove_alt_1_outlined),
          onPressed: !hasUpdated ? addPerson : removePerson,
        ),
      ],
    );
  }
}
