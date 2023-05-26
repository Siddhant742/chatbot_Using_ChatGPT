import 'dart:async';
import 'package:chatbot/threedots.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'chatMessage.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  late OpenAI chatGPT;
  String token = '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';
  late StreamSubscription _subscription;
  bool isTyping = false;

  @override
  void initState() {
    chatGPT = OpenAI.instance;
    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }

  void _sendMessage() {
    ChatMessage message = ChatMessage(text: _controller.text, sender: 'user');
    setState(() {
      _messages.insert(0, message);
      isTyping = true;
    });
    _controller.clear();
    final request = CompleteText(prompt: message.text, model: 'text-davinci-003', maxTokens: 100);
    _subscription = chatGPT.build(token: token).onCompletionStream(request: request).listen((response) {
      ChatMessage botMessage = ChatMessage(text: response!.choices[0].text, sender: 'bot');
      setState(() {
        _messages.insert(0, botMessage);
        isTyping = false;
      });
    });
  }

  Widget _buildTextComposer() {
    return Row(
      children: [
        Expanded(
          child: TextField(
            onSubmitted: (value) => _sendMessage(),
            controller: _controller,
            decoration: InputDecoration.collapsed(
              hintText: 'What do you want to ask?',
            ),
          ),
        ),
        IconButton(
          icon: Icon(Icons.send),
          onPressed: _sendMessage,
        ),
      ],
    ).px16();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Ask Me",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Color(0xFF6B1E1E),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: ListView.builder(
                reverse: true,
                itemCount: _messages.length,
                padding: Vx.m8,
                itemBuilder: (BuildContext context, int index) {
                  return _messages[index];
                },
              ),
            ),
            if (isTyping) ThreeDots(),
            Divider(height: 1,),
            Container(
              decoration: BoxDecoration(
                color: context.cardColor,
              ),
              child: _buildTextComposer(),
            ),
          ],
        ),
      ),
    );
  }
}

