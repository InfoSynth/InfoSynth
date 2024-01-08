import 'package:flutter/material.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';


class ChatPage extends StatefulWidget {
  final StreamChatClient? client;
  final String? title;

  ChatPage({ Key? key, this.title, this.client }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title!),
      ),
      body: StreamChat(
        child: Container(),
        client: widget.client!,
      )
    );
  }
}
