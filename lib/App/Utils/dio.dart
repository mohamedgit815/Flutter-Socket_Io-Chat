import 'package:chat_socket_io/App/app.dart';
import 'package:dio/dio.dart';

class BaseDioHelper {}

class DioHelper {

  final Dio dio = Dio(
      BaseOptions(
          baseUrl: App.strings.baseUrl ,
          headers: {
            'Content-Type' : 'application/json'
          },
          receiveDataWhenStatusError: true
      )
  );


  Dio initDio() {
    return Dio(
        BaseOptions(
            baseUrl: App.strings.baseUrl ,
            headers: {
              'Content-Type' : 'application/json'
            },
            receiveDataWhenStatusError: true
        )
    );
  }


  Future<Response> get({
    required String url, String? token ,
    Map<String,dynamic>? data
  }) async {
    final Response response = await dio.getUri(Uri.parse(url),
        data: data,
        options: Options(
            headers: {"authorization": "Bearer $token"} ,
        )
    );
    return response;
  }


  Future<Response> post({
    required String url ,
    Map<String,dynamic>? data ,
    String? token
  }) async {
    return await dio.postUri(Uri.parse(url) ,data: data,
        options: Options(
        headers: token == null ? null : {"authorization": "Bearer $token"}
        )
    );
  }


  Future<Response> update({
    required String url ,
    Map<String,dynamic>? data ,
    String? token
  }) async {
    return await dio.putUri(Uri.parse(url),data: data,
        options: Options(
            headers: token == null ? null : {"authorization": "Bearer $token"}
        ));
  }


  Future<Response> delete({
    required String url ,
    Map<String,dynamic>? data ,
    String? token
  }) async {
    return await dio.deleteUri(Uri.parse(url),data: data,
        options: Options(
            headers: token == null ? null : {"authorization": "Bearer $token"}
        ));
  }
}