import 'package:flutter/material.dart';
import 'package:chat_app/global/environment.dart';
import 'package:chat_app/services/auth_service.dart';
// ignore: library_prefixes
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus {
  online,
  offline,
  connecting,
}

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.connecting;
  ServerStatus get serverStatus => _serverStatus;

  late IO.Socket _socket;
  IO.Socket get socket => _socket;

  void connect() async {
    final token = await AuthService.getToken();
    //!Dart client
    _socket = IO.io(Environment.socketUrl, {
      'transports': ['websocket'],
      'autoConnect': true,
      'forceNew': true,
      'extraHeaders': {'x-token': token}
    });

    _socket.on('connect', (_) {
      _serverStatus = ServerStatus.online;
      notifyListeners();
    });

    _socket.on('disconnect', (_) {
      _serverStatus = ServerStatus.offline;
      notifyListeners();
    });
  }

  //* Logout
  void disconnect() {
    _socket.disconnect();
  }
}
