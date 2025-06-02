// Neomorphic text field
  import 'package:flutter/material.dart';

Widget buildNeomorphicTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
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
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          color: Colors.blueGrey[800],
          fontFamily: 'Poppins',
        ),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 16,
            color: Colors.blueGrey[400],
            fontFamily: 'Poppins',
          ),
          prefixIcon: Icon(prefixIcon, color: Colors.blueGrey[600]),
          suffixIcon: suffixIcon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 16),
          fillColor: Colors.transparent,
          filled: true,
        ),
      ),
    );
  }