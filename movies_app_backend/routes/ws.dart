import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_web_socket/dart_frog_web_socket.dart';
import 'package:movies_app_backend/counter/cubit/counter_cubit.dart';
import 'package:movies_app_models/movies_app_models.dart';

import '../services/mongo_service.dart';

Future<Response> onRequest(RequestContext context) async {
  final handler = webSocketHandler(
    (channel, protocol) async {
      final mongoService = await context.read<Future<MongoService>>();
      await mongoService.open();

      final cubit = context.read<CounterCubit>()
        ..subscribe(channel)
        ..init(await mongoService.database.collection('users').count());

      channel.sink.add('${cubit.state}');

      channel.stream.listen(
        (event) {
          switch ('$event'.toMessage()) {
            case Message.increment:
              cubit.increment();

            case null:
              break;
          }
        },
        onDone: () => cubit.unsubscribe(channel),
      );
    },
  );

  return handler(context);
}

extension on String {
  Message? toMessage() {
    for (final message in Message.values) {
      if (this == message.value) {
        return message;
      }
    }
    return null;
  }
}
