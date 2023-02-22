import 'package:flutter/material.dart';

class Labels extends StatelessWidget {
  final String ruta;
  final String texto1;
  final String textButton;
  const Labels({
    super.key,
    required this.ruta,
    required this.texto1,
    required this.textButton,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          texto1,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w300,
          ),
        ),
        const SizedBox(height: 15),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacementNamed(context, ruta);
          },
          child: Text(
            textButton,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 40),
        const Text(
          'Términos y condiciones de uso',
          style: TextStyle(
            color: Colors.black54,
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
