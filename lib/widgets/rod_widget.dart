import 'package:flutter/material.dart';
import '../constants_enums.dart';

class RodWidget extends StatelessWidget {
  final int rodIndex;
  final bool enabled;
  final Function onTap;

  RodWidget(
      {required this.rodIndex, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: kFirstRodX - kRodWidth / 2 + rodIndex * kRodDeltaX,
      bottom: 0,
      child: GestureDetector(
        child: Container(
          width: kRodWidth,
          height: kRodHeight,
          color: Colors.black54,
          child: Text(
            String.fromCharCode(rodIndex + 65),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        onTap: enabled ? () => onTap(rodIndex) : null,
      ),
    );
  }
}
