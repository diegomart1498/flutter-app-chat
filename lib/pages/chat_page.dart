import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:chat_app/widgets/chat_message.dart';

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

  @override
  Widget build(BuildContext context) {
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
              child: const Text('DM', style: TextStyle(fontSize: 12)),
            ),
            const SizedBox(height: 3),
            const Text('Diego Martínez', style: TextStyle(fontSize: 12)),
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
                      child: const Text('Enviar'),
                      onPressed: () {},
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
      uid: '123',
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
  }

  //* Cuando cierro esta pantalla de chat, cierro las animaciones y la conexión con los sockets
  @override
  void dispose() {
    //TODO: off del socket
    for (ChatMessage message in _messages) {
      message.animationController.dispose();
    }
    super.dispose();
  }
}
