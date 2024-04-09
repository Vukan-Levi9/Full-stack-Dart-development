import 'package:movies_app/core/constants.dart';
import 'package:movies_app/domain/repository/counter_repository.dart';
import 'package:movies_app_models/movies_app_models.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class CounterRepositoryImpl extends CounterRepository {
  @override
  void connect() =>
      ws = WebSocketChannel.connect(Uri.parse(UrlsPath.webSocketBaseUrl));

  @override
  void increment() => ws?.sink.add(Message.increment.value);

  @override
  void close() => ws?.sink.close();
}
