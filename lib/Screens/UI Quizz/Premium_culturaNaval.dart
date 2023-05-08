import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quiz_marin/Constants/Constans.dart';
import 'package:quiz_marin/FirebaseDB/DBCN/db_connect.dart';
import 'package:quiz_marin/Model/Timer.dart';
import 'package:quiz_marin/Model/questions_model.dart';
import 'package:quiz_marin/Screens/NextScreenBtn.dart';
import 'package:quiz_marin/Screens/OptionCardQ.dart';
import 'package:quiz_marin/Screens/QuestionsWidget.dart';
import 'package:quiz_marin/Screens/Result_Box.dart';

class CulturaNavalQuizz extends StatefulWidget {
  const CulturaNavalQuizz({super.key});

  @override
  State<CulturaNavalQuizz> createState() => _CulturaNavalQuizzState();
}

class _CulturaNavalQuizzState extends State<CulturaNavalQuizz> {
  var db = DBconnectCn();

  late Future _questions;
  // Preguntas aleatorias
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
  bool ispressed = false;
  bool isAlreadySelected = false;

  void StarOver() {
    setState(() {
      index = 0;
      score = 0;
      ispressed = false;
      isAlreadySelected = false;
    });
    Navigator.pop(context);
  }

  void NextQuestions(int questionsLenght) {
    if (index == questionsLenght - 1) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) => ResultBox(
              result: score,
              questionsLenght: questionsLenght,
              onPressed: StarOver));
    } else {
      if (ispressed) {
        setState(() {
          index = Random().nextInt(questionsLenght);
          ispressed = false;
          isAlreadySelected = false;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          backgroundColor: Colors.blue,
          content:
              Text("Selecciona una respuesta antes de pasar a la siguente"),
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
        ispressed = true;
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
        final pop = await ShowmyDialog();
        return pop ?? false;
      },
      child: FutureBuilder(
        future: _questions as Future<List<Questions>>,
        builder: (ctx, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasError) {
              return Center(
                child: Text("${snapshot.error}"),
              );
            } else if (snapshot.hasData) {
              var extractedData = snapshot.data as List<Questions>;
              return Scaffold(
                  appBar: AppBar(
                    automaticallyImplyLeading: false,
                    title: Text(
                      'Test Cultura Naval',
                      style: KTBlack,
                    ),
                    centerTitle: true,
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    elevation: 0,
                    actions: [
                      Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Text(
                          "Puntuacion $score",
                          style: KTGreen,
                        ),
                      )
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(30)),
                            child: TiempoContador(
                                tiempo: Duration(
                                    hours: 4, minutes: 19, seconds: 60)),
                          ),
                          QuestionsWidger(
                              questions: extractedData[index].title,
                              indexAction: index,
                              totalQuestions: extractedData.length),
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
                                  color: ispressed
                                      ? snapshot.data![index].options.values
                                                  .toList()[i] ==
                                              true
                                          ? Correct
                                          : Incorrect
                                      : Colors.white),
                            )
                        ],
                      ),
                    ),
                  ),
                  floatingActionButton: GestureDetector(
                    onTap: () => NextQuestions(extractedData.length),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: NextScreenBtn(),
                    ),
                  ),
                  floatingActionButtonLocation:
                      FloatingActionButtonLocation.endFloat);
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
          return Container(
            color: Colors.white,
            alignment: Alignment.center,
            child: Text(
              "No hay preguntas por hoy <3",
              style: KTBlack,
            ),
          );
        },
      ),
    );
  }
}
