import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:chat_app/helpers/mostrar_alerta.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double heightScreen =
        (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width)
            ? MediaQuery.of(context).size.height * 0.95
            : MediaQuery.of(context).size.width * 0.8;
    return Scaffold(
      backgroundColor: const Color(0xffF2F2F2),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SizedBox(
          height: heightScreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Logo(titulo: 'Crear cuenta'),
              _Form(),
              Labels(
                ruta: 'login',
                textButton: '¡Ingresar ahora!',
                texto1: '¿Ya tienes una cuenta?',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Form extends StatefulWidget {
  const _Form();
  @override
  State<_Form> createState() => __FormState();
}

class __FormState extends State<_Form> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: Column(
        children: [
          CustomInput(
            icon: Icons.perm_identity,
            hintText: 'Nombre',
            keyboardType: TextInputType.name,
            textController: nameController,
          ),
          CustomInput(
            icon: Icons.mail_outline,
            hintText: 'Correo',
            keyboardType: TextInputType.emailAddress,
            textController: emailController,
          ),
          CustomInput(
            icon: Icons.lock_outline,
            hintText: 'Contraseña',
            keyboardType: TextInputType.text,
            textController: passwordController,
            isPassword: true,
          ),
          BotonAzul(
            text: (!authService.autenticando) ? 'Crear cuenta' : '',
            onPress: (!authService.autenticando) ? () => onPress : () => null,
          ),
        ],
      ),
    );
  }

  void onPress() async {
    String nombre = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    if (email.isEmpty || password.isEmpty || nombre.isEmpty) {
      Fluttertoast.showToast(
        toastLength: Toast.LENGTH_SHORT,
        msg: 'Complete los campos',
        backgroundColor: Colors.black45,
      );
      return;
    }
    FocusScope.of(context).unfocus(); //* Esconder teclado
    final authService = Provider.of<AuthService>(context, listen: false);
    final registroOK = await authService.register(nombre, email, password);
    if (registroOK == true) {
      //TODO: Conectar al socket server
      // ignore: use_build_context_synchronously
      Navigator.pushReplacementNamed(context, 'usuarios');
    } else {
      final subtitulo = (registroOK == null) ? '' : registroOK;
      // ignore: use_build_context_synchronously
      mostrarAlerta(
        context,
        'Registro incorrecto',
        subtitulo,
      );
    }
  }
}
