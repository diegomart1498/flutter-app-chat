import 'package:http/http.dart' as http;

import 'package:chat_app/models/usuario.dart';
import 'package:chat_app/models/usuarios_response.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';

class UsuarioService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final uri = Uri.parse('${Environment.apiUrl}/usuarios');
      final resp = await http.get(uri, headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken(),
      });
      final usuarioResponse = usuariosResponseFromJson(resp.body);
      return usuarioResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
