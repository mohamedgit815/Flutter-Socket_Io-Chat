

import 'package:chat_socket_io/App/app.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';

class ChatPage extends StatefulWidget {

  final String name, query;

  const ChatPage({super.key,required this.name, required this.query});

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with _Chat_ {

  late Socket socket;

  @override
  void initState() {
    super.initState();
    socket = App.socketIo.initSocket(key: "chatId",value: widget.query);

    socket.on('msg', (data) {
        setState(() {
          dataValue.add(data);
        });
    });
  }

  @override
  void dispose() {
    super.dispose();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
      
          Expanded(
            flex: 12,
            child: ListView.builder(
              itemCount: dataValue.length ,
              itemBuilder: (BuildContext context, int i) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${dataValue.elementAt(i)['sender']}: ${dataValue.elementAt(i)['text']} "),
                );
              })
            ) , 
      
    
          Flexible(
            child: Row(
              children: [
    
                Expanded(
                  child: TextField(
                    controller: controller ,
                    decoration: const InputDecoration(
                      hintText: "Text"
                    ),
                   ),
                ) ,
                  
                
                
                IconButton(
                   onPressed: () {
                    if(controller.text.isNotEmpty) {
                      socket.emit("msg", {
                        "id": dataValue.length + 1 , 
                        "text": controller.text , 
                        "chatId": widget.query ,
                        "sender": widget.name
                      });
                    }
                   }, icon: const Icon(Icons.send)
                )
              
              ],
            ),
          )
       
        ],
      ),
    );
  }
}

mixin _Chat_ {
    final TextEditingController controller = TextEditingController();
   final List dataValue = [];

}