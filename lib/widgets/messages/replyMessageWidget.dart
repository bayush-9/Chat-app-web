import 'package:flutter/material.dart';

class ReplyMessageWidget extends StatelessWidget {
  final String message;
  final String userName;
  final VoidCallback onCancelReply;
  final Color txtColor;

  const ReplyMessageWidget({
    @required this.txtColor,
    @required this.message,
    this.onCancelReply,
    this.userName,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue[200],
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(12),
              topRight: Radius.circular(12),
              bottomLeft: Radius.circular(12),
              bottomRight: Radius.circular(12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: Row(
              children: [
                Container(
                  color: Colors.blue,
                  width: 4,
                ),
                const SizedBox(width: 8),
                Expanded(child: buildReplyMessage()),
              ],
            ),
          ),
        ),
      );

  Widget buildReplyMessage() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  userName,
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: txtColor),
                ),
              ),
              if (onCancelReply != null)
                GestureDetector(
                  child: Icon(Icons.close, size: 16),
                  onTap: onCancelReply,
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: txtColor)),
        ],
      );
}
