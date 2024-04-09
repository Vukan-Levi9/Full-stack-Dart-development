import 'package:broadcast_bloc/broadcast_bloc.dart';

class CounterCubit extends BroadcastCubit<int> {
  CounterCubit() : super(0);

  void init(int value) => emit(value);
  void increment() => emit(state + 1);
}
