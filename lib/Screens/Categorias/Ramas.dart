import 'package:flutter/material.dart';
import 'package:quiz_marin/Constants/Constans.dart';
import 'package:shimmer/shimmer.dart';

class Ramas extends StatelessWidget {
  const Ramas({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        direction: ShimmerDirection.ltr,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Shimmer.fromColors(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
            SizedBox(
              width: 20,
            ),
            Shimmer.fromColors(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
            SizedBox(
              width: 20,
            ),
            Shimmer.fromColors(
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
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
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
          ],
        ),
      ),
    );
  }

  static where(Function(dynamic r) param0) {}
}
// Ramas premium

class RamasPremium extends StatelessWidget {
  const RamasPremium({
    super.key,
  });
  
  @override
  Widget build(BuildContext context) {
    Map<String, Container> contenedoresGuardados = {};
    
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            key: UniqueKey(),
            alignment: Alignment.center,
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: NetworkImage(
                    Infanteria,
                  ),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken)),
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                   
                    ],
                  ),
                ),
                Text('Infanteria', textAlign: TextAlign.center, style: Marina),
              ],
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            alignment: Alignment.center,
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: NetworkImage(
                    "https://vanguardia.com.mx/binrepository/1200x746/0c0/0d0/none/11604/BVLT/elementos-de-la-semar-cuartoscuro-0-7_1-2211292_20220610185301.jpg",
                  ),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken)),
            ),
            child: Text(
              'Sastreria',
              textAlign: TextAlign.center,
              style: Marina,
            ),
          ),
          SizedBox(
            width: 20,
          ),
          Container(
            alignment: Alignment.center,
            height: 100,
            width: 300,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              image: const DecorationImage(
                  image: NetworkImage(
                    "https://www.infodefensa.com/images/showid2/4766394?w=900&mh=700",
                  ),
                  fit: BoxFit.cover,
                  colorFilter:
                      ColorFilter.mode(Colors.black54, BlendMode.darken)),
            ),
            child:
                Text('Intendencia', textAlign: TextAlign.center, style: Marina),
          )
        ],
      ),
    );
  }
}
