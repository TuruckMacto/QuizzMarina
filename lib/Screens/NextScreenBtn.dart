import 'package:flutter/material.dart';

class NextScreenBtn extends StatelessWidget {
  const NextScreenBtn({Key? key,})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(50),
          boxShadow: const [
            BoxShadow(
                offset: Offset(0, 2), color: Colors.black, blurRadius: 4)
          ]),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: const Icon(Icons.arrow_right_alt_outlined, color: Colors.white,)
    );
  }
}
