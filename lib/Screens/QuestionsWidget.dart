import 'package:flutter/material.dart';
import 'package:quiz_marin/Constants/Constans.dart';

class QuestionsWidger extends StatelessWidget {
  const QuestionsWidger(
      {Key? key,
      required this.questions,
      required this.indexAction,
      required this.totalQuestions});

  final String questions;
  final int indexAction;
  final int totalQuestions;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10.0 ),
      alignment: Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.white,
              offset: Offset(0, 2),
              blurRadius: 5
            )
          ]
        ),
        child: Column(
          children: [
            SizedBox(height: 30,),
            Text('Total de preguntas $totalQuestions', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 30),),
            Divider(color: Colors.grey,),
            Text('$questions',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
              fontSize: 30
            ),
            textAlign: TextAlign.center,

            ),
            SizedBox(height: 100,)
          ],
        ),
      ),
    );
  }
}
