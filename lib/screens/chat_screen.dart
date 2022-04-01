import 'package:chat_app/providers/group.dart';
import 'package:chat_app/providers/user.dart';
import 'package:chat_app/screens/group_details_screen.dart';
import 'package:chat_app/screens/proxy_managing_screen.dart';
import 'package:chat_app/widgets/chat/message_bubble.dart';
import 'package:chat_app/widgets/messages/replyMessageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatefulWidget {
  static const routeName = '/chats-screen';
  String replymessage;
  String replyUser;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  String username;

  var _enteredMessage = '';

  var _message = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    ScrollController listScrollController = ScrollController();
    final tfocusnode = FocusNode();
    final activeGroup = Provider.of<Groups>(context, listen: false).activeGroup;
    final userId = Provider.of<User>(context, listen: false).userId;
    final isReplying = (widget.replymessage != null);

    Future<void> _sendMessage() async {
      FocusScope.of(context).unfocus();
      var activeGroupId =
          Provider.of<Groups>(context, listen: false).activeGroupId;
      var userId = Provider.of<User>(context, listen: false).userId;
      var userName = Provider.of<User>(context, listen: false).userName;

      Firestore.instance
          .collection('groups')
          .document(activeGroupId)
          .collection('chats')
          .add(
        {
          'text': _enteredMessage,
          'timeStamp': DateTime.now(),
          'userId': userId,
          'username': userName,
          'isReplying': widget.replymessage != null,
          'replyMessage': widget.replymessage,
          'replyUsername': widget.replyUser
        },
      );
      if (listScrollController.hasClients) {
        final position = listScrollController.position.maxScrollExtent;
        await listScrollController.jumpTo(position);
      }
      setState(() {
        widget.replymessage = null;
      });

      _message.clear();
    }

    void replyToMessage(String message, String userName) {
      setState(() {
        widget.replymessage = message;
        widget.replyUser = userName;
      });
      // tfocusnode.requestFocus();
    }

    Widget buildReply() {
      tfocusnode.requestFocus();
      return Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        child: ReplyMessageWidget(
          txtColor: Colors.white,
          message: widget.replymessage,
          userName: widget.replyUser,
          onCancelReply: () {
            setState(() {
              widget.replymessage = null;
            });
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_sharp),
          onPressed: () {
            Provider.of<Groups>(context, listen: false).unactivateGroup();
            Navigator.of(context).pop();
          },
        ),
        title: InkWell(
          child: Text(
              Provider.of<Groups>(context, listen: false).activeGroup.name),
          onTap: () => Navigator.pushNamed(context, GroupDetails.routeName),
        ),
        actions: [
          IconButton(
              onPressed: () =>
                  Navigator.pushNamed(context, ProxyManagementScreen.routeName),
              icon: Icon(Icons.mark_chat_read_rounded))
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: 15,
            ),
            Expanded(
              child: Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: [
                    StreamBuilder(
                      builder: (ctx, chatSnapshot) {
                        // if (chatSnapshot.connectionState == ConnectionState.waiting) {
                        //   return Container(height: 200, child: CircularProgressIndicator());
                        // }
                        final chatDocs = chatSnapshot.data.documents;
                        if (chatDocs.length == 0) {
                          return Text("NO message yet");
                        }
                        if (listScrollController.hasClients) {
                          final position =
                              listScrollController.position.maxScrollExtent;
                          listScrollController.jumpTo(position);
                        }
                        return ListView.builder(
                          controller: listScrollController,
                          itemBuilder: (context, index) => MessageBubble(
                            isMe: chatDocs[index]['userId'] == userId,
                            isReplying: chatDocs[index]['isReplying'],
                            replyMessage: chatDocs[index]['replyMessage'],
                            replyUsername: chatDocs[index]['replyUsername'],
                            userName: chatDocs[index]['username'],
                            message: chatDocs[index]['text'],
                            userId: chatDocs[index]['userId'].toString().trim(),
                            onSwipedMessage: (String message) async {
                              // await tfocusnode.requestFocus();

                              replyToMessage(chatDocs[index]['text'],
                                  chatDocs[index]['username']);
                            },
                          ),
                          itemCount: chatDocs.length,
                        );
                      },
                      stream: Firestore.instance
                          .collection('groups')
                          .document(activeGroup.id)
                          .collection('chats')
                          .orderBy('timeStamp')
                          .snapshots(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: 50.0,
                          left: MediaQuery.of(context).size.width - 40),
                      child: FloatingActionButton(
                        shape: BeveledRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        elevation: 0,
                        child: Container(
                            height: 50,
                            child: Icon(Icons.arrow_downward_rounded)),
                        backgroundColor: Colors.blue.withOpacity(0.5),
                        onPressed: () {
                          if (listScrollController.hasClients) {
                            final position =
                                listScrollController.position.maxScrollExtent;
                            listScrollController.jumpTo(position);
                          }
                        },
                      ),
                    ),
                  ]),
            ),
            Column(
              children: [
                if (isReplying) buildReply(),
                Container(
                  padding: EdgeInsets.all(8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: Colors.blue)),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: TextField(
                              focusNode: tfocusnode,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .color),
                              controller: _message,
                              decoration: InputDecoration(
                                  labelText: '  Send a message..',
                                  labelStyle: TextStyle(color: Colors.white)),
                              onChanged: (value) {
                                setState(() {
                                  _enteredMessage = value;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send_rounded, color: Colors.blue),
                        onPressed: _enteredMessage.trim().isEmpty
                            ? null
                            : _sendMessage,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
