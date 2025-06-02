import 'package:flutter/material.dart';

Widget neomorphicButton({
    required Widget child,
    VoidCallback? onPressed,    
  }) {

    bool isPressed = false;

    return StatefulBuilder(
      builder: (context, setState) =>
      GestureDetector(
        onTapDown: (_) => setState(() => isPressed = true),
        onTapUp: (_) {
          setState(() => isPressed = false);
          if (onPressed != null) onPressed();
        },
        onTapCancel: () => setState(() => isPressed = false),
        child: AnimatedContainer(
          duration: Duration(milliseconds: 150),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical:10 ),
          height: 60,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10),
            boxShadow: isPressed
            // Pressed state - inverted shadows
            ? [
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.white.withOpacity(0.8),
                  offset: Offset(2, 2),
                  spreadRadius: 1,
                ),
                BoxShadow(
                  blurRadius: 5,
                  color: Colors.grey.shade500,
                  offset: Offset(-2, -2),
                  spreadRadius: 1,
                ),
              ]
            // Default state
            : [
                BoxShadow(
                  blurRadius: 9,
                  color: Colors.grey.shade500,
                  offset: Offset(4, 4),
                  spreadRadius: 3,
                ),
                BoxShadow(
                  blurRadius: 15,
                  color: Colors.white,
                  offset: Offset(-4, -4),
                  spreadRadius: 5,
                ),
              ],
          ),
          child: DefaultTextStyle(
            style: DefaultTextStyle.of(context).style.copyWith(
              color: isPressed ? Colors.blueGrey[400] : Colors.blueGrey[800],
            ),
            child: child,
          ),
        ),
      ),
    );
  }