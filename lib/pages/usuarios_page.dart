import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:chat_app/models/usuario.dart';

class UsuariosPage extends StatefulWidget {
  const UsuariosPage({Key? key}) : super(key: key);

  @override
  State<UsuariosPage> createState() => _UsuariosPageState();
}

class _UsuariosPageState extends State<UsuariosPage> {
  final _refreshController = RefreshController(initialRefresh: false);

  final List<Usuario> usuarios = [
    Usuario(online: true, name: 'Diego', email: 'u1@test.com', uid: '1'),
    Usuario(online: false, name: 'Andrés', email: 'u2@test.com', uid: '2'),
    Usuario(online: true, name: 'Diana', email: 'u3@test.com', uid: '3'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi nombre'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blueAccent,
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          tooltip: 'Cerrar sesión',
          onPressed: () {
            Navigator.pushReplacementNamed(context, 'login');
          },
        ),
        actions: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(right: 10),
            child: Stack(
              children: const [
                Icon(Icons.circle, color: Colors.white),
                Icon(Icons.offline_bolt, color: Colors.red),
                // Icon(Icons.check_circle, color: Colors.green),
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
        onRefresh: _cargarUsuarios,
        child: _listViewUsuarios(),
      ),
    );
  }

  void _cargarUsuarios() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
    Fluttertoast.showToast(
      msg: 'Actualizado',
      backgroundColor: Colors.black45,
    );
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
      title: Text(usuario.name),
      subtitle: Text(usuario.email),
      leading: CircleAvatar(
        backgroundColor: Colors.blueAccent.withOpacity(0.8),
        child: Text(
          usuario.name.substring(0, 2),
          style: const TextStyle(color: Colors.white),
        ),
      ),
      trailing: Icon(
        Icons.circle,
        size: 10,
        color: (usuario.online) ? Colors.green : Colors.red,
      ),
      onTap: () {},
    );
  }
}
