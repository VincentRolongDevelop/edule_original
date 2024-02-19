import 'package:flutter/material.dart';

class CustomSquareButtonWidget extends StatelessWidget {
  final IconData icon;
  final String buttonText;
  final VoidCallback onTap;
  final double buttonSize;
  final double iconSize;
  final Color buttonColor;

  CustomSquareButtonWidget({
    required this.icon,
    required this.buttonText,
    required this.onTap,
    this.buttonSize = 80.0,
    this.iconSize = 40.0,
    this.buttonColor = const Color.fromARGB(255, 47, 163, 189),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(10, 10, 10, 0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: onTap,
            style: ElevatedButton.styleFrom(
              primary: buttonColor,
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              minimumSize: Size(buttonSize, buttonSize),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: iconSize,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 8),
          Text(
            buttonText,
            style: TextStyle(
              color: Colors.black54,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
