import 'package:flutter/material.dart';

Widget neomorphicChatBubble({
  required String message,
  required bool isUser,
}) {
  return Align(
    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
    child: Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      constraints: const BoxConstraints(maxWidth: 270),
      decoration: BoxDecoration(
        color: isUser ? Colors.grey[200] : Colors.grey[200],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(isUser ? 20 : 5),
          topRight: Radius.circular(isUser ? 5 : 20),
          bottomLeft: const Radius.circular(20),
          bottomRight: const Radius.circular(20),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade400,
            offset: const Offset(2, 2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
          const BoxShadow(
            color: Colors.white,
            offset: Offset(-2, -2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      child: Text(
        message,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blueGrey[800],
          fontFamily: 'Poppins',
        ),
      ),
    ),
  );
}
