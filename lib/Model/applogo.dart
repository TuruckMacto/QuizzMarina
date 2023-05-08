import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
            fontSize: 22
        ),
        children: <TextSpan>[
          TextSpan(text: 'Quiz', style: TextStyle(fontWeight: FontWeight.w600
              , color: Colors.black)),
          TextSpan(text: 'Marina', style: TextStyle(fontWeight: FontWeight.w600
              , color: Colors.grey)),
        ],
      ),
    );
  }
}
