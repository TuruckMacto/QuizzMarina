import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quiz_marin/Model/applogo.dart';
import 'package:quiz_marin/Screens/Categorias/Ramas.dart';
import 'package:quiz_marin/Screens/UI%20Quizz/ConocimientosQuizz.dart';
import 'package:quiz_marin/Screens/UI%20Quizz/Premium_culturaNaval.dart';
import 'package:shimmer/shimmer.dart';
import 'package:quiz_marin/Constants/Constans.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.ispremium}) : super(key: key);

  final bool ispremium;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool _isPremium = false;
  bool hasinternet = false;
  User? _currenuser;
  List<String> items = [];

  @override
  void initState() {
    super.initState();
    _currenuser = FirebaseAuth.instance.currentUser;
    _fetchIsPremium(); // Llamar a la función para obtener el estado de premium
  }

  Future<void> _fetchIsPremium() async {
    try {
      // Verificar que el usuario actual no sea nulo y tenga un valor válido
      if (_currenuser != null && _currenuser!.uid.isNotEmpty) {
        // Obtener el valor de isPremium desde la base de datos (Firestore)
        DocumentSnapshot snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(_currenuser!.uid)
            .get();

        if (snapshot.exists) {
          setState(() {
            _isPremium = (snapshot.data() as Map<String, dynamic>)['isPremium']
                    as bool? ??
                false;
          });
        }
      }
    } catch (e) {
      print('Error al obtener el estado de premium del usuario: $e');
    }
  }

  Future<void> _refreshData() async {
    // Actualizar el estado del widget y verificar si el usuario es premium o no
    await _fetchIsPremium();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AppLogo(),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        elevation: 0,
        centerTitle: true
      ),
      body: FutureBuilder(
        future: Future.delayed(Duration(seconds: 2)), // Esperar 2 segundos
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Mostrar el efecto Shimmer solo si no hay conexión a internet
            if (!hasinternet) {
              return Center(
                  child: Shimmer.fromColors(
                      baseColor: Colors.grey.shade300,
                      highlightColor: Colors.grey.shade100,
                      direction: ShimmerDirection.ltr,
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              children: const [
                                Text(
                                  "Conocimientos Marinero",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              onTap: () {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  elevation: 10,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                      "No tienes conexion a internet, Intanta de nuevo"),
                                ));
                              },
                              child: Container(
                                alignment: Alignment.center,
                                height: 100,
                                width: 300,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black),
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Cultura Naval",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 30,
                            ),
                            InkWell(
                              child: Shimmer.fromColors(
                                baseColor: Colors.grey.shade400,
                                highlightColor: Colors.grey.shade600,
                                direction: ShimmerDirection.ltr,
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: 300,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.black)),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Ramas",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )));
            } else {
              // Mostrar un indicador de carga mientras se carga el contenido real
              return Center(child: CircularProgressIndicator());
            }
          } else {
            // Mostrar el contenido real una vez que se haya cargado
            return RefreshIndicator(
              color: Colors.white,
              backgroundColor: Colors.blue,
              onRefresh: _refreshData,
              child: ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              "Conocimientos Marinero",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ConocimientosQuizz()));
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 100,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              image: const DecorationImage(
                                image: NetworkImage(
                                  "https://www.infodefensa.com/images/showid2/4766394?w=900&mh=700",
                                ),
                                fit: BoxFit.cover,
                                colorFilter: ColorFilter.mode(
                                    Colors.black54, BlendMode.darken),
                              ),
                            ),
                            child: const Text(
                              "Conocimientos Marinero",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: const [
                            Text(
                              "Cultura Naval",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 30,
                        ),
                        if (!_isPremium)
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  action: SnackBarAction(
                                      label: Refresh, onPressed: () {}),
                                  behavior: SnackBarBehavior.floating,
                                  elevation: 10,
                                  backgroundColor: Colors.blue,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                  content: const Text(
                                      'No puedes ingresar a este elemento porque no eres usuario premium'),
                                ),
                              );
                            },
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey.shade400,
                              highlightColor: Colors.grey.shade600,
                              direction: ShimmerDirection.ltr,
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 100,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(color: Colors.black)),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: const [
                                      Icon(
                                        Icons.lock_outline_rounded,
                                        color: Colors.black,
                                      ),
                                      Text(
                                        'No puedes ingresar a este elemento\n No eres premium',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(color: Colors.black),
                                      )
                                    ],
                                  )),
                            ),
                          ),
                        if (_isPremium)
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          CulturaNavalQuizz()));
                            },
                            child: Container(
                              alignment: Alignment.center,
                              height: 100,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                image: const DecorationImage(
                                    image: NetworkImage(
                                      "https://images.unsplash.com/flagged/photo-1554131297-39877b87bddf?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80",
                                    ),
                                    fit: BoxFit.cover,
                                    colorFilter: ColorFilter.mode(
                                        Colors.black54, BlendMode.darken)),
                              ),
                              child: const Text(
                                "Cultura Naval",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        Row(
                          children: [
                            Text(
                              "Ramas",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25),
                            ),
                            SizedBox(
                              width: 20,
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        if (!_isPremium) Ramas(),
                        if (_isPremium) RamasPremium(),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
