import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/usuarios_service.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final _refreshController = RefreshController(initialRefresh: false);
  final usuarioService = UsuarioService();
  List<Usuario> usuarios = [];

  @override
  void initState() {
    _cargarUsuarios();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final usuario = authService.usuario;
    final socketService = Provider.of<SocketService>(context);
    final serverStatus = socketService.serverStatus;
    return Scaffold(
      appBar: AppBar(
        title: Text(usuario.nombre),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Cerrar sesión',
          onPressed: () {
            // Desconectar el socket server
            socketService.disconnect();
            AuthService.deleteToken();
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10),
            child: Stack(
              children: [
                const Icon(Icons.circle, color: Colors.white),
                (serverStatus == ServerStatus.offline)
                    ? const Icon(Icons.offline_bolt, color: Colors.red)
                    : const Icon(Icons.check_circle, color: Colors.green),
              ],
            ),
          )
        ],
      ),
      body: SmartRefresher(
        controller: _refreshController,
        header: const WaterDropMaterialHeader(
          backgroundColor: Colors.blueAccent,
        ),
        onRefresh: () async {
          await _cargarUsuarios();
          Fluttertoast.showToast(
            msg: 'Actualizado',
            backgroundColor: Colors.black45,
          );
        },
        child: _listViewUsuarios(),
      ),
    );
  }

  Future<void> _cargarUsuarios() async {
    usuarios = await usuarioService.getUsuarios();
    setState(() {});
    _refreshController.refreshCompleted();
  }

  ListView _listViewUsuarios() {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      itemCount: usuarios.length,
      separatorBuilder: (_, index) => const Divider(),
      itemBuilder: (_, index) => _usuarioListTile(usuarios[index]),
    );
  }

  ListTile _usuarioListTile(Usuario usuario) {
    return ListTile(
      title: Text(usuario.nombre),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        child: Text(
          usuario.nombre.substring(0, 2),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      trailing: Icon(
        Icons.circle,
        size: 10,
        color: (usuario.online) ? Colors.green : Colors.red,
      ),
      onTap: () {
        final chatService = Provider.of<ChatService>(context, listen: false);
        chatService.usuarioPara = usuario;
        Navigator.pushNamed(context, 'chat');
      },
    );
  }
}
