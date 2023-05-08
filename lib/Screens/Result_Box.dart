import 'package:flutter/material.dart';
import 'package:quiz_marin/Constants/Constans.dart';

class ResultBox extends StatelessWidget {
  const ResultBox(
      {Key? key,
      required this.result,
      required this.questionsLenght,
      required this.onPressed})
      : super(key: key);

  final int result;
  final int questionsLenght;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      backgroundColor: Colors.black,
      content: Padding(
        padding: const EdgeInsets.all(70.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Puntuacion',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 22.0),
            ),
            const SizedBox(
              height: 22.0,
            ),
            CircleAvatar(
              radius: 70,
              backgroundColor: result == questionsLenght / 2
                  ? Colors.yellow
                  : result < questionsLenght / 2
                      ? Incorrect
                      : Correct,
              child: Text(
                '$result/$questionsLenght',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Text(
              result == questionsLenght / 2
                  ? 'Casi llegas!'
                  : result < questionsLenght / 2
                      ? 'Intenta de nuevo burro!'
                      : '¡Felicidades pasaste!',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15.0),
            ),
            const SizedBox(
              height: 25.0,
            ),
            GestureDetector(
              onTap: onPressed,
              child: const Text(
                'Iniciar de nuevo',
                style: TextStyle(
                    color: Colors.white, fontSize: 20.0, letterSpacing: 1.0),
              ),
            )
          ],
        ),
      ),
    );
  }
}
