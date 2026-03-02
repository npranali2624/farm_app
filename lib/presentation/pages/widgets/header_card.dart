import 'package:flutter/material.dart';

Widget headerCard({
  required String title,
  IconData? icon,
  VoidCallback? onIconPressed,
}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.only(
      top: 50,
      bottom: 18,
      left: 8,
      right: 8,
    ),
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [
          Color(0xFF1B5E20),
          Color(0xFF2E7D32),
          Color(0xFF66BB6A),
        ],
      ),
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(22),
      ),
    ),
    child: Stack(
      alignment: Alignment.center,
      children: [

        if (icon != null)
          Align(
            alignment: Alignment.centerLeft,
            child: Builder(
              builder: (context) => IconButton(
                icon: Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: onIconPressed,
              ),
            ),
          ),

        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    ),
  );
}