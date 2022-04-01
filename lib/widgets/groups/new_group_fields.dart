import 'package:chat_app/providers/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:provider/provider.dart';

class NewGroupFields extends StatefulWidget {
  @override
  _NewGroupFieldsState createState() => _NewGroupFieldsState();
}

class _NewGroupFieldsState extends State<NewGroupFields> {
  var _enteredGroupName = '';
  var _groupName = new TextEditingController();

  void _sendMessage() async {
    const _chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890!@#%^&*()';
    Random _rnd = Random.secure();

    String getRandomString(int length) =>
        String.fromCharCodes(Iterable.generate(
            length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

    FocusScope.of(context).unfocus();
    await Firestore.instance.collection('groups').add(
      {
        'groupName': _enteredGroupName,
        'timeStamp': DateTime.now(),
        'uniqueId': getRandomString(6),
      },
    ).then((value) {
      Firestore.instance
          .collection('users')
          .document(Provider.of<User>(context, listen: false).userId.trim())
          .updateData({
        'userGroups': FieldValue.arrayUnion([value.documentID])
      });
    });
    _groupName.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      child: Row(
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
                      color: Theme.of(context).textTheme.bodyText1.color),
                  controller: _groupName,
                  decoration: InputDecoration(
                      labelText: '  Group Name...',
                      labelStyle: TextStyle(
                          color: Theme.of(context).textTheme.bodyText1.color)),
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
            icon: Icon(
              Icons.done,
              color: Colors.blue,
            ),
            onPressed: _enteredGroupName.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
