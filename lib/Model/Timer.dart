import 'dart:async';

import 'package:flutter/material.dart';

class TiempoContador extends StatefulWidget {
  final Duration tiempo;

  TiempoContador({required this.tiempo});

  @override
  _TiempoContadorState createState() => _TiempoContadorState();
}

class _TiempoContadorState extends State<TiempoContador> {
  late Timer _timer;
  late Duration _tiempoActual;

  @override
  void initState() {
    super.initState();
    _tiempoActual = widget.tiempo;
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _tiempoActual = _tiempoActual - Duration(seconds: 1);
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String contador = _formatDuration(_tiempoActual);
    return Text(contador);
  }

  String _formatDuration(Duration duration) {
    int horas = duration.inHours;
    int minutos = duration.inMinutes.remainder(60);
    int segundos = duration.inSeconds.remainder(60);
    return '$horas h $minutos min $segundos s';
  }
}