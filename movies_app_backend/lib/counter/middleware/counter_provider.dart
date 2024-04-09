import 'package:dart_frog/dart_frog.dart';
import 'package:movies_app_backend/counter/cubit/counter_cubit.dart';

final _counter = CounterCubit();
final counterProvider = provider<CounterCubit>((_) => _counter);
