import 'package:chat_app/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JoinGroupScreen extends StatefulWidget {
  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  var _enteredGroupName = '';
  var _groupName = new TextEditingController();

  _showSuccessSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: const Text('You have been added to the group.'),
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  _showErrorDialog(BuildContext context) {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Unique Id incorrect."),
      content: Text(
          "The Unique group Id you have entered is incorrect. Please make sure the Id is correct(case sensitive)."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _sendMessage(BuildContext context) async {
    bool flag = true;
    FocusScope.of(context).unfocus();
    String groupId = _enteredGroupName.trim();
    await Firestore.instance
        .collection('groups')
        .where('uniqueId', isEqualTo: groupId)
        .limit(1)
        .getDocuments()
        // .onError((error, stackTrace) => _showErrorDialog(context))
        .then(
          (value) async => value.documents.forEach(
            (element) async {
              flag = false;
              print(element);
              groupId = element.documentID;
              await Firestore.instance
                  .collection('users')
                  .document(
                      Provider.of<User>(context, listen: false).userId.trim())
                  .updateData({
                'userGroups': FieldValue.arrayUnion([groupId])
              }).then(
                (value) => _showSuccessSnackBar(context),
              );
              _groupName.clear();
            },
          ),
        );
    if (flag) {
      _showErrorDialog(context);
    }
    print(groupId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.all(8),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          border: Border.all(color: Colors.blue)),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: TextField(
                          style: TextStyle(
                              color:
                                  Theme.of(context).textTheme.bodyText1.color),
                          controller: _groupName,
                          decoration: InputDecoration(
                              labelText: '  Group Unique id...',
                              labelStyle: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color)),
                          onChanged: (value) {
                            setState(() {
                              _enteredGroupName = value;
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.done, color: Colors.blue),
                    onPressed: _enteredGroupName.isEmpty
                        ? null
                        : () => _sendMessage(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
