import 'package:flutter/material.dart';

Widget neomorphicLogo(Icon icon) {
    return Container(
      height: 160,
      width: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(
            blurRadius: 9,
            color: Colors.grey.shade500,
            offset: const Offset(4, 4),
            spreadRadius: 3,
          ),
          const BoxShadow(
            blurRadius: 15,
            color: Colors.white,
            offset: Offset(-4, -4),
            spreadRadius: 5,
          ),
        ],
      ),
      child:icon,
    );
  }