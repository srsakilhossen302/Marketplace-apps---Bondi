import 'package:flutter/foundation.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  io.Socket? socket;

  void connect(String token) {
    if (socket != null && socket!.connected) {
      debugPrint('=== SOCKET SERVICE DEBUG: Connect called, but socket is already connected. ===');
      return;
    }

    debugPrint('=== SOCKET SERVICE DEBUG: Initializing Socket connection... ===');
    debugPrint('=== SOCKET SERVICE DEBUG: Target URL: https://bondi-dev.nasimmondal.dev ===');
    socket = io.io(
      'https://bondi-dev.nasimmondal.dev',
      io.OptionBuilder()
          .setTransports(['websocket'])
          .setAuth({'token': 'Bearer $token'})
          .enableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      debugPrint('⚡⚡⚡ SOCKET CONNECTED SUCCESSFULLY ⚡⚡⚡');
      debugPrint('Socket ID: ${socket!.id}');
    });

    socket!.onDisconnect((reason) {
      debugPrint('❌❌❌ SOCKET DISCONNECTED ❌❌❌ Reason: $reason');
    });

    socket!.onConnectError((data) {
      debugPrint('⚠️⚠️⚠️ SOCKET CONNECTION ERROR: $data ⚠️⚠️⚠️');
    });

    socket!.onError((data) {
      debugPrint('🔴🔴🔴 SOCKET ERROR OCCURRED: $data 🔴🔴🔴');
    });
  }

  void disconnect() {
    if (socket != null) {
      debugPrint('Disconnecting Socket.IO');
      socket!.disconnect();
      socket = null;
    }
  }

  void joinConversation(String conversationId) {
    debugPrint('🔄 Attempting to join conversation room: $conversationId');
    if (socket != null && socket!.connected) {
      socket!.emit('join_conversation', {'conversationId': conversationId});
      debugPrint('✅ Emitted join_conversation successfully: $conversationId');
    } else {
      debugPrint('❌ FAILED to join conversation: Socket is not connected! (socket: $socket, connected: ${socket?.connected})');
    }
  }

  void leaveConversation(String conversationId) {
    debugPrint('🔄 Attempting to leave conversation room: $conversationId');
    if (socket != null && socket!.connected) {
      socket!.emit('leave_conversation', {'conversationId': conversationId});
      debugPrint('✅ Emitted leave_conversation successfully: $conversationId');
    } else {
      debugPrint('❌ FAILED to leave conversation: Socket is not connected!');
    }
  }

  void startTyping(String conversationId) {
    debugPrint('🔄 Attempting to emit startTyping for room: $conversationId');
    if (socket != null && socket!.connected) {
      socket!.emit('typing_start', {'conversationId': conversationId});
      debugPrint('✅ Emitted typing_start successfully');
    } else {
      debugPrint('❌ FAILED to emit typing_start: Socket is not connected!');
    }
  }

  void stopTyping(String conversationId) {
    debugPrint('🔄 Attempting to emit stopTyping for room: $conversationId');
    if (socket != null && socket!.connected) {
      socket!.emit('typing_stop', {'conversationId': conversationId});
      debugPrint('✅ Emitted typing_stop successfully');
    } else {
      debugPrint('❌ FAILED to emit typing_stop: Socket is not connected!');
    }
  }

  void on(String event, dynamic handler) {
    debugPrint('👂 Subscribing to Socket event: "$event"');
    socket?.on(event, (data) {
      debugPrint('📥 SOCKET RECEIVED DATA on event "$event": $data');
      handler(data);
    });
  }

  void off(String event) {
    debugPrint('🔇 Unsubscribing from Socket event: "$event"');
    socket?.off(event);
  }
}
