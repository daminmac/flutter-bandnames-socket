import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as IO;

enum ServerStatus { Online, Offline, Connecting }

class SocketService with ChangeNotifier {
  ServerStatus _serverStatus = ServerStatus.Connecting;
  IO.Socket? _socket;

  ServerStatus get serverStatus => _serverStatus;

  IO.Socket get socket => _socket!;
  Function get emit => _socket!.emit;

  SocketService() {
    _initConfig();
  }

  void _initConfig() {
    // Dart client
    _socket = IO.io('http://192.168.0.144:3000/', {
      'transports': ['websocket'],
      'autoconnect': true
    });
    _socket!.on('connect', (_) {
      _serverStatus = ServerStatus.Online;
      notifyListeners();
    });

    _socket!.on('disconnect', (_) {
      _serverStatus = ServerStatus.Offline;
      notifyListeners();
    });
  }
}
