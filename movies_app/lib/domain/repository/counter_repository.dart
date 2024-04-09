import 'package:web_socket_channel/web_socket_channel.dart';

abstract class CounterRepository {
  WebSocketChannel? ws;

  Stream? get stream => ws?.stream;

  void connect();

  void increment();

  void close();
}
