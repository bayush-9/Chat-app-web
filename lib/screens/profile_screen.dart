import 'package:chat_app/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final activeUser = Provider.of<User>(context, listen: false);
    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          title: Text("My profile"),
        ),
        body: FutureBuilder(
            future: Firestore.instance
                .collection('users')
                .document(activeUser.userId.trim())
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              }
              return ListView(
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  CircleAvatar(
                    backgroundColor: Colors.grey[800],
                    backgroundImage: NetworkImage(snapshot.data['userImage']),
                    radius: MediaQuery.of(context).size.width / 3,
                  ),
                  Card(
                    child: ListTile(
                      tileColor: Theme.of(context).backgroundColor,
                      leading: Text(
                        "User Name: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                      title: Text(activeUser.userName,
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color)),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      tileColor: Theme.of(context).backgroundColor,
                      leading: Text(
                        "Email Id: ",
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context).textTheme.bodyText1.color),
                      ),
                      title: Text(activeUser.email,
                          style: TextStyle(
                              fontSize: 20,
                              color:
                                  Theme.of(context).textTheme.bodyText1.color)),
                    ),
                  ),
                ],
              );
            }));
  }
}
