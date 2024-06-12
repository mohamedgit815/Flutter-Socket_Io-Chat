import 'package:chat_socket_io/App/app.dart';
import 'package:socket_io_client/socket_io_client.dart';


class InitSocketIo {
  final Map<String, dynamic> _option = <String, dynamic>{
    "transports": ['websocket'] ,
    'autoConnect': false
  };


  /// http://192.168.1.10:9000/{

  Socket initSocket({String? key, String? value}) {
    if(key == null && value == null) {
        return io(App.strings.baseUrl , _option).connect();
    } else {
        return io("${App.strings.baseUrl}/?$key=$value" , _option).connect();
    }


    

   // return io( key == null ? 'http://192.168.1.10:9000/' : 'http://192.168.1.10:9000/?$key=$value', _option).connect();
   // return socket;
  }


}