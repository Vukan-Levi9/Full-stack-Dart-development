enum Message {
  increment('__increment__');

  const Message(this.value);

  final String value;
}
