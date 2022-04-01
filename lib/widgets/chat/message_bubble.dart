import 'package:chat_app/widgets/messages/replyMessageWidget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:swipe_to/swipe_to.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble(
      {this.userName,
      this.replyMessage,
      this.replyUsername,
      this.message,
      this.isReplying,
      this.isMe,
      this.userId,
      this.onSwipedMessage});
  final ValueChanged<String> onSwipedMessage;
  final bool isReplying;
  final String message;
  final String replyMessage;
  final String replyUsername;
  final String userName;
  final bool isMe;
  final String userId;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return FutureBuilder(
      future:
          Firestore.instance.collection('users').document(userId.trim()).get(),
      builder: (context, snapshot) {
        return Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment:
                  isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
              children: <Widget>[
                SwipeTo(
                  onRightSwipe: () => onSwipedMessage(message),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isMe ? Colors.grey[300] : Colors.blue[800],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                        bottomLeft:
                            !isMe ? Radius.circular(0) : Radius.circular(12),
                        bottomRight:
                            isMe ? Radius.circular(0) : Radius.circular(12),
                      ),
                    ),
                    // width: width / 2.5,
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    margin: EdgeInsets.symmetric(
                      vertical: isMe ? 5 : 12,
                      horizontal: 8,
                    ),
                    child: Column(
                      crossAxisAlignment: isMe
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        if (!isMe)
                          SizedBox(
                            height: 5,
                          ),
                        if (!isMe)
                          Text(
                            userName,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: isMe ? Colors.black : Colors.white,
                            ),
                          ),
                        if (isReplying)
                          Container(
                            width: message.toString().length + 110.0,
                            child: ReplyMessageWidget(
                              txtColor: Colors.black,
                              message: replyMessage,
                              userName: replyUsername,
                            ),
                          ),
                        Text(
                          message,
                          style: TextStyle(
                            color: isMe ? Colors.black : Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (!isMe)
              Positioned(
                top: -10,
                left: isMe ? width - 43 : 3,
                child: CircleAvatar(
                  backgroundColor: Colors.grey[800],
                  backgroundImage: snapshot.data != null
                      ? NetworkImage(snapshot.data['userImage'])
                      : null,
                ),
              ),
          ],
        );
      },
    );
  }
}
