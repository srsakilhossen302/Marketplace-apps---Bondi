import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  IO.Socket? socket;

  void connect(String token) {
    if (socket != null && socket!.connected) return;

    print('Initializing Socket connection...');
    socket = IO.io(
      'https://bondi-dev.nasimmondal.dev',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      print('Socket.IO connection established');
    });

    socket!.onDisconnect((_) {
      print('Socket.IO disconnected');
    });

    socket!.onConnectError((data) {
      print('Socket.IO connection error: $data');
    });

    socket!.onError((data) {
      print('Socket.IO error occurred: $data');
    });
  }

  void disconnect() {
    if (socket != null) {
      print('Disconnecting Socket.IO');
      socket!.disconnect();
      socket = null;
    }
  }

  void joinConversation(String conversationId) {
    if (socket != null && socket!.connected) {
      socket!.emit('join_conversation', {'conversationId': conversationId});
      print('Emitted join_conversation: $conversationId');
    } else {
      print('Socket not connected. Cannot join conversation.');
    }
  }

  void leaveConversation(String conversationId) {
    if (socket != null && socket!.connected) {
      socket!.emit('leave_conversation', {'conversationId': conversationId});
      print('Emitted leave_conversation: $conversationId');
    } else {
      print('Socket not connected. Cannot leave conversation.');
    }
  }

  void startTyping(String conversationId) {
    if (socket != null && socket!.connected) {
      socket!.emit('typing_start', {'conversationId': conversationId});
      print('Emitted typing_start: $conversationId');
    }
  }

  void stopTyping(String conversationId) {
    if (socket != null && socket!.connected) {
      socket!.emit('typing_stop', {'conversationId': conversationId});
      print('Emitted typing_stop: $conversationId');
    }
  }

  void on(String event, dynamic handler) {
    socket?.on(event, handler);
  }

  void off(String event) {
    socket?.off(event);
  }
}
