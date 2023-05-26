import 'package:flutter/material.dart ';
import 'package:velocity_x/velocity_x.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({Key? key, required this.text, required this.sender})
      : super(key: key);
  final String text;
  final String sender;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(sender)
            .text
            .subtitle1(context)
            .make()
            .box
            .color(sender == 'user' ? Vx.red200 : Vx.green200)
            .p16
            .rounded.alignCenter.makeCentered(),
        Text(text).text.bodyText1(context).make().p16()
      ],
      crossAxisAlignment: CrossAxisAlignment.start,
    ).py8();
  }
}
