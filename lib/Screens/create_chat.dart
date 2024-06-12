import 'package:chat_socket_io/App/app.dart';
import 'package:chat_socket_io/Screens/home.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';
import 'package:http/http.dart' as http;

class CreateChatPage extends StatefulWidget {
  final String name;

  const CreateChatPage({super.key, required this.name});

  @override
  State<CreateChatPage> createState() => _CreateChatPageState();
}

class _CreateChatPageState extends State<CreateChatPage> with _Chat_ {


  @override
  void initState() {
    super.initState();

    socket = App.socketIo.initSocket();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
          
            TextField(
              controller: controller ,
              decoration: const InputDecoration(
                hintText: "Name Group"
              ),
            ) ,
        

            MaterialButton(
              onPressed: () async {
                
                 await createGroups(context: context, name: widget.name);

              }, child: const Text("Create Group"))
         
          
          ],
        ),
      ),
    );
  }
}

mixin _Chat_ {
  late Socket socket;
  final TextEditingController controller = TextEditingController();

  Future<void> createGroup(BuildContext context) async {
    final http.Response response = await http.post(Uri.parse('http://192.168.1.10:9000/api'),
    body: {
      "name": "controller.text"
    });

    if(response.statusCode == 200 ) {
      print("True");
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Errors")));
    }
  }


  Future<void> createGroups({required BuildContext context, required String name}) async {
    try{
      final Response response = await Dio().postUri(Uri.parse('${App.strings.baseUrl}/api'),data: {
        "name": controller.text
      });

      if(response.statusCode == 200) {
        final data = response.data['data'];

        socket.emit("createMsg",{
          "id" : data['_id'] ,
          "idGroup" : data['idGroup'] ,
          "name": controller.text
        });
        if(context.mounted) {
          Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => HomePage(name: name)), (
              route) => false);
        }
      } else {
        print("False");
      }
    } on DioException catch(e) {
      print(e.message);
    }
  }
}

//       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Error")));
