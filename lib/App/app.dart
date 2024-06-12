import 'package:chat_socket_io/App/Utils/dio.dart';
import 'package:chat_socket_io/App/Utils/socket_io.dart';
import 'package:chat_socket_io/App/Utils/strings.dart';

class App {
  static Strings strings = Strings();
  static InitSocketIo socketIo = InitSocketIo();
  static DioHelper dio = DioHelper();
}