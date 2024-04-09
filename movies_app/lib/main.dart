import 'package:flutter/material.dart';
import 'package:movies_app/core/injection_container.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'src/app.dart';

void main() {
  IC.setUp();
  usePathUrlStrategy();
  runApp(const MyApp());
}
