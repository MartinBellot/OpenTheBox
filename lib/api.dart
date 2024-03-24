import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Api {
  static late final Api _instance;
  static Future<Api> getInstance() async {
    await dotenv.load();
    _instance = Api._internal();
    return _instance;
  }

  factory Api() => _instance;
  late final Dio _dio;
  late final String _apiAdress;

  Api._internal() {
    _dio = Dio();
    _apiAdress = dotenv.env['API_ADRESS']!;
    print('api: $_apiAdress');
  }
  Dio get dio => _dio;
  String get apiAdress => _apiAdress;

  Future<Response> get(String path) async {
    return await _dio.get('$_apiAdress$path');
  }

  Future<Response> post(String path, {required Map<String, dynamic> data}) async {
    return _dio.post('$_apiAdress$path', data: data);
  }
}
