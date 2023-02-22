import 'package:flutter/material.dart';
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
            text: 'Ingresar',
            onPress: () => onPress,
          ),
        ],
      ),
    );
  }

  void onPress() {
    print('nombre: ${nameController.text}');
    print('email: ${emailController.text}');
    print('contra: ${passwordController.text}');
    FocusScope.of(context).unfocus();
    //TODO: Realizar acciones del botón ingresar
  }
}
