import 'dart:math';

import 'package:flutter/material.dart';
import 'package:quiz_marin/Constants/Constans.dart';
import 'package:quiz_marin/FirebaseDB/DBCM/db_connect.dart';
import 'package:quiz_marin/Model/Timer.dart';
import 'package:quiz_marin/Model/questions_model.dart';
import 'package:quiz_marin/Screens/NextScreenBtn.dart';
import 'package:quiz_marin/Screens/OptionCardQ.dart';
import 'package:quiz_marin/Screens/QuestionsWidget.dart';
import 'package:quiz_marin/Screens/Result_Box.dart';

class ConocimientosQuizz extends StatefulWidget {
  const ConocimientosQuizz({super.key});

  @override
  State<ConocimientosQuizz> createState() => _ConocimientosQuizzState();
}

class _ConocimientosQuizzState extends State<ConocimientosQuizz> {
  var db = DBconnect();

  late Future _questions;
  Future<List<Questions>> getData() async {
   List<Questions> data = await db.fetchQuestions();
    data.shuffle();
    return data;
  }

  @override
  void initState() {
    super.initState();
    _questions = getData();
  }

  int index = 0;

  int score = 0;

  bool isPressed = false;

  bool isAlreadySelected = false;


  void StartOver() {
    setState(() {
      index = 0;
      score = 0;
      isPressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  void nextquestions(int questionLength) {
    if (index == questionLength - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
                result: score,
                questionsLenght: questionLength,
                onPressed: StartOver,
              ));
    } else {
       if (isPressed) {
        setState(() {
          index = Random().nextInt(questionLength);
          isPressed = false;
          isAlreadySelected = false;
        });
      }  else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content:  Text(
              "Selecciona una respuesta antes de pasar a la siguente"),
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.symmetric(vertical: 20.0),
        ));
      }
    }
  }

  void CheckAnswerandUpdate(bool value) {
    if (isAlreadySelected) {
      return;
    } else {
      if (value == true) {
        score++;
      }
      setState(() {
        isPressed = true;
        isAlreadySelected = true;
      });
    }
  }

  Future<bool?> ShowmyDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            backgroundColor: Colors.black,
            title: Text(
              '¿Seguro que quieres regresar?, Tu avance no se guardara',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: Text(
                    "No",
                    style: TextStyle(color: Colors.white),
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "Si",
                    style: TextStyle(color: Colors.white),
                  )),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final Pop = await ShowmyDialog();
        return Pop ?? false;
      },
      child: FutureBuilder(
        future: _questions as Future<List<Questions>>,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text('${snapshot.error}'),
              );
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as List<Questions>;
              return Scaffold(
                backgroundColor: Colors.white,
                appBar: AppBar(
                  title: const Text(
                    'Test Conocimientos Marinero',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20),
                  ),
                  automaticallyImplyLeading: false,
                  centerTitle: true,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shadowColor: Colors.transparent,
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text('Puntuacion: $score',
                          style: KTGreen)
                    )
                  ],
                ),
                body: SingleChildScrollView(
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(30)),
                          child: TiempoContador(
                              tiempo:
                                  Duration(hours: 3, minutes: 19, seconds: 60)),
                        ),
                        QuestionsWidger(
                            questions: extractedData[index].title,
                            indexAction: index,
                            totalQuestions: extractedData.length,),
                        const SizedBox(
                          height: 25.0,
                        ),
                        for (int i = 0;
                            i < snapshot.data![index].options.length;
                            i++)
                          GestureDetector(
                            onTap: () => CheckAnswerandUpdate(snapshot
                                .data![index].options.values
                                .toList()[i]),
                            child: OptionCard(
                              option: snapshot.data![index].options.keys
                                  .toList()[i],
                              color: isPressed
                                  ? snapshot.data![index].options.values
                                              .toList()[i] ==
                                          true
                                      ? Correct
                                      : Incorrect
                                  : Colors.white,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: GestureDetector(
                  onTap: () => nextquestions(extractedData.length),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: NextScreenBtn(),
                  ),
                ),
                floatingActionButtonLocation:
                    FloatingActionButtonLocation.centerFloat,
              );
            }
          } else {
            return Container(
              alignment: Alignment.center,
              color: Colors.white,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: const [
                     CircularProgressIndicator(),
                     SizedBox(
                      height: 20.0,
                    ),
                    Text(
                      'Porfavor espere, Preguntas Cargando....',
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 14.0),
                    )
                  ],
                ),
              ),
            );
          }
          return Center(
            child: Text('No hay Preguntas por hoy <3'),
          );
        },
      ),
    );
  }
}
