import 'dart:io';

import 'package:flutter/foundation.dart';

class UrlsPath {
  static final baseUrl = !kIsWeb && Platform.isAndroid
      ? 'http://10.0.2.2:8080'
      : 'http://localhost:8080';

  static final webSocketBaseUrl = !kIsWeb && Platform.isAndroid
      ? 'ws://10.0.2.2:8080/ws'
      : 'ws://localhost:8080/ws';

  static const imagesBaseUrl = 'https://image.tmdb.org/t/p/w500';
}

class ImagesStrings {
  static const logoMovies = 'assets/images/movies_logo.png';
  static const errrorImage = 'assets/images/error_image.png';
}
