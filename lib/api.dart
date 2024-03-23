import 'package:dio/dio.dart';

class Api {
  static final Api _instance = Api._internal();
  factory Api() => _instance;
  late final Dio _dio;
  Api._internal() {
    _dio = Dio();
  }
  Dio get dio => _dio;
}
