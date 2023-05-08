import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:quiz_marin/Constants/Constans.dart';
import 'package:quiz_marin/Screens/home.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _deviceInfo = DeviceInfoPlugin();
  bool _isAdmin = true;
  User? _currenuser;
  bool passwordVisible = false;

  @override
  void initState() {
    super.initState();
    _currenuser = FirebaseAuth.instance.currentUser;
    _FetchIsAdmin();
  }

  Future<void> _FetchIsAdmin() async {
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
            _isAdmin =
                (snapshot.data() as Map<String, dynamic>)['isAdmin'] as bool? ??
                    false;
          });
        }
      }
    } catch (e) {
      print('Error al obtener el estado de premium del usuario: $e');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  //Verificar si el usurario es premium o no

  Future<bool> getPremiumStatus(String userId) async {
    try {
      // Obtener la referencia del documento del usuario en la colección "users"
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
          DocumentSnapshot UserAdmin = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      // Obtener el valor del campo "isPremium" del documento
      bool isPremium = userSnapshot.get('isPremium');
      return isPremium;
    } catch (e) {
      print('Error al obtener el estado de premium del usuario: $e');
      return false;
    }
  }

  //Registrar un nuevo usuario en Firebase Authentication y almacenar su DeviceId en Firestore
  void _signIn() async {
    if (_formkey.currentState!.validate()) {
      try {
        // Iniciar sesión con el correo y contraseña ingresados
        final userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: _usernameController
                    .text, //obtener el correo ingresado por el usuario desde Firebase Auth
                password: _passwordController
                    .text // Obtener la contraseña ingresada por el usuario desde Firebase Auth
                );
        final userDoc = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: _usernameController.text)
            .get();
        if (userDoc.docs.isNotEmpty) {
          final user = userDoc.docs[0].data();
          final deviceId = await getDeviceId();
          if (user['device_id'] != null &&
              user['device_id'] != '' &&
              user['device_id'] != deviceId) {
            // Si el correo ya está registrado con otro dispositivo, mostrar un mensaje de error
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                backgroundColor: Colors.blue,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 10,
                content:
                    Text('El correo ya está registrado en otro dispositivo.'),
              ),
            );
            return;
          }
        } else {
          // Si el correo no está registrado, registrarlo con el dispositivo actual
          final deviceId = await getDeviceId();
          await FirebaseFirestore.instance.collection('users').add({
            'email': _usernameController.text,
            'device_id': deviceId,
          });
        }

        // Actualizar el ID del dispositivo del usuario en la base de datos
        final deviceId = await getDeviceId();
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userCredential.user!.uid)
            .set({
          'email': _usernameController.text,
          'device_id': deviceId,
          'isPremium':
              true, // Establecer isPremium como verdadero para el usuario
        }, SetOptions(merge: true));

        final userId = userCredential.user!.uid;

        // Obtener el estado de premium del usuario desde la base de datos
        final snapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();
        final isPremium = snapshot.data()?['isPremium'] ?? false;

        // Verificar si el usuario tiene acceso a las opciones premium basado en su estado de premium
        if (isPremium) {
          // Si el usuario tiene acceso a las opciones premium, hacer algo
          print('El usuario tiene acceso a las opciones premium');
          // Aquí puedes implementar la lógica para las opciones premium
        }
        // Navegar a la pantalla de inicio
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
              builder: (context) => Home(
                    ispremium: isPremium,
                  )),
        );
      } on FirebaseAuthException catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            elevation: 10,
            backgroundColor: Colors.blue,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            content: Text(
                'Valla, al parecer el usuario y contraseña han sido eliminados\n o no existe la cuenta.'),
          ),
        );
      }
    }
  }

  Future<String> getDeviceId() async {
    String deviceId = '';
    try {
      if (Theme.of(context).platform == TargetPlatform.iOS) {
        final iosDeviceInfo = await _deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor ?? '';
      } else {
        final androidDeviceInfo = await _deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.id;
      }
    } catch (e) {
      print('Error getting device ID: $e');
    }
    return deviceId;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ingresa el usuario',
          style: KWhite,
        ),
        
        centerTitle: true,
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(
                height: 5,
              ),
              LottieBuilder.network(
                'https://assets7.lottiefiles.com/packages/lf20_mj2plzpy.json',
                repeat: true,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Recuerda que una vez que se te de el usuario y contraseña",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      " Solo podras ingresar con el mismo dispositivo",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 14),
                    ),
                    Text(
                      "Si tienes problemas para ingresar, Comunicate a:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.grey[500],
                          fontWeight: FontWeight.bold,
                          fontSize: 17),
                    ),
                    InkWell(
                      onTap: () async {
                        final Uri params = Uri(
                          scheme: 'mailto',
                          path: 'ramirezalejandro7070@gmail.com',
                        );
                        String url = params.toString();

                        // ignore: deprecated_member_use
                        if (await canLaunch(url)) {
                          // ignore: deprecated_member_use
                          await launch(
                            url,
                            forceSafariVC: false,
                            universalLinksOnly: true,
                          );
                        } else {
                          throw 'Could not launch $url';
                        }
                      },
                      child: Text('ramirezalejandro7070@gmail.com'),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _usernameController,
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          hintText: 'Usuario',
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.black),
                          )),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa el usuario asignado por el administrador';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: _passwordController,
                      
                      decoration: InputDecoration(
                          disabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                                  BorderSide(width: 1, color: Colors.black)),
                          hintText: 'Contraseña',
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.black)),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(color: Colors.black),
                          ),
                          suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  passwordVisible = !passwordVisible;
                                });
                              },
                              icon: Icon(passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off))),
                      obscureText: !passwordVisible,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Ingresa la contraseña asignada por el administrador';
                        }
                        return null;
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: 300,
                      height: 60.0,
                      child: CupertinoButton(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(30),
                          onPressed: _signIn,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send_outlined,
                                color: Colors.white,
                              ),
                              SizedBox(
                                width: 30,
                              ),
                              Text("Verificar")
                            ],
                          )),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
