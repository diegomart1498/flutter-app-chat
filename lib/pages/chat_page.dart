import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/widgets/chat_message.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/models/mensajes_response.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  bool _isWriting = false;
  final List<ChatMessage> _messages = [];

  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;

  @override
  void initState() {
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);
    authService = Provider.of<AuthService>(context, listen: false);
    socketService.socket.on('mensaje-personal', _escucharMensaje);
    _cargarHistorial(chatService.usuarioPara.uid);
    super.initState();
  }

  void _cargarHistorial(String usuarioID) async {
    List<Mensaje> chat = await chatService.getChat(usuarioID);
    final history = chat.map((m) => ChatMessage(
          texto: m.mensaje,
          uid: m.de,
          animationController: AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 0),
          )..forward(),
        ));
    setState(() {
      _messages.insertAll(0, history);
    });
  }

  void _escucharMensaje(dynamic payload) {
    // print('Tengo mensaje: $payload');
    // if (payload['de'] != chatService.usuarioPara.uid) return;
    ChatMessage message = ChatMessage(
      texto: payload['mensaje'],
      uid: payload['de'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    setState(() {
      _messages.insert(0, message);
    });
    message.animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    // final chatService = Provider.of<ChatService>(context);
    final usuarioPara = chatService.usuarioPara;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0,
        centerTitle: true,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 15,
              backgroundColor: Colors.blueAccent[600],
              child: Text(usuarioPara.nombre.substring(0, 2),
                  style: const TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            Text(usuarioPara.nombre, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 5),
          ],
        ),
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (_, index) => _messages[index],
            ),
          ),
          const Divider(height: 1),
          Container(
            color: Colors.white,
            child: _inputChat(),
          ),
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                margin: const EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: const Color.fromARGB(255, 17, 74, 165),
                  ),
                ),
                child: TextField(
                  controller: _textController,
                  focusNode: _focusNode,
                  textCapitalization: TextCapitalization.sentences,
                  onSubmitted: (_isWriting) ? _handleSubmit : null,
                  onChanged: (String texto) {
                    setState(() {
                      if (texto.trim().isNotEmpty) {
                        _isWriting = true;
                      } else {
                        _isWriting = false;
                      }
                    });
                  },
                  decoration: const InputDecoration(
                    hintText: 'Enviar mensaje',
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: (_isWriting)
                          ? () => _handleSubmit(_textController.text)
                          : null,
                      child: const Text('Enviar'),
                    )
                  : IconTheme(
                      data: const IconThemeData(color: Colors.blue),
                      child: IconButton(
                        icon: const Icon(Icons.send),
                        splashRadius: 25,
                        onPressed: (_isWriting)
                            ? () => _handleSubmit(_textController.text)
                            : null,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String texto) {
    final newMessage = ChatMessage(
      texto: texto.trim(),
      uid: authService.usuario.uid,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward(); //Inicia la animación del nuevo ms

    _textController.clear(); //Limpia el texto
    _focusNode.requestFocus(); //Evita que se esconda el teclado

    setState(() {
      _isWriting = false;
    });

    socketService.socket.emit('mensaje-personal', {
      'de': authService.usuario.uid,
      'para': chatService.usuarioPara.uid,
      'mensaje': texto.trim(),
    });
  }

  //* Cuando cierro esta pantalla de chat, cierro las animaciones y la conexión con los sockets
  @override
  void dispose() {
    // Off del socket
    socketService.socket.off('mensaje-personal');
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }
}
