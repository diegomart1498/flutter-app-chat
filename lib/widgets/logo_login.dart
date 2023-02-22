import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final String titulo;
  const Logo({
    super.key,
    required this.titulo,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 180,
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Image(
              image: AssetImage('assets/tag-logo.png'),
            ),
            const SizedBox(height: 20),
            Text(
              titulo,
              style: const TextStyle(fontSize: 30),
            ),
          ],
        ),
      ),
    );
  }
}
