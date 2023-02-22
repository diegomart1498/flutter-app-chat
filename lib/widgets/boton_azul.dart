import 'package:flutter/material.dart';

class BotonAzul extends StatelessWidget {
  const BotonAzul({
    super.key,
    required this.text,
    required this.onPress,
  });

  final String text;
  final Function onPress;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      fillColor: Colors.blueAccent,
      elevation: 0,
      highlightElevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
      onPressed: onPress(),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }
}
