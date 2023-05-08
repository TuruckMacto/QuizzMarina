import 'package:flutter/material.dart';
import 'package:quiz_marin/Constants/Constans.dart';

class OptionCard extends StatelessWidget {
  const OptionCard(
      {Key? key,
      required this.option,
      required this.color,
      })
      : super(key: key);
  final String option;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30)
      ),
      elevation: 5,
      color: color,
      child: ListTile(
        title: Text(
          option,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: color.red !=  color.green ? Colors.white : Colors.black
          ),
          
        ),
      ),
    );
  }
}
