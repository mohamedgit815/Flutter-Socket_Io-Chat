import 'package:chat_socket_io/App/app.dart';
import 'package:chat_socket_io/Screens/chat.dart';
import 'package:chat_socket_io/Screens/create_chat.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:socket_io_client/socket_io_client.dart';


class HomePage extends StatefulWidget {
  final String name;
  const HomePage({super.key, required this.name});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with _Home_ {

  fetchGroupChat(BuildContext context) async {
    try {
      final response = await App.dio.get(url: '${App.strings.baseUrl}/api');

      if(response.statusCode == 200) {
        final  data = response.data['data'];
        setState(() {
          dataValue.addAll(data);
        });
      }

    } on DioException catch(e) {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Error")));
      }
    }

  }


  @override
  void initState() {
    super.initState();

    socket = App.socketIo.initSocket();

    Future.delayed(Duration.zero,() async {
      await fetchGroupChat(context);
    });

    socket.on("createMsg",(data)  {
      setState(() {
        dataValue.add(data);
        //dataValue.addAll(data);
      });
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    socket.dispose();
  }

  @override
  Widget build(BuildContext context) {

    setState(() {});

    return Scaffold(

      floatingActionButton: FloatingActionButton(onPressed: () {
        //socket.emit("createMsg",{"name":"dasd"});
        Navigator.push(context, CupertinoPageRoute(builder: (_) => CreateChatPage(name: widget.name)));
      },child: const Icon(Icons.add),),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center ,
          children: [
            Expanded(
                child: dataValue.isEmpty ?
                const Center(child: CircularProgressIndicator.adaptive())
                    : ListView.builder(
                itemCount: dataValue.length ,
                itemBuilder: (context,i) {
                    return ListTile(
                      key: ValueKey(dataValue.elementAt(i)['idGroup']),
                      title: Text(dataValue.elementAt(i)['name'].toString()),
                      subtitle: Text(dataValue.elementAt(i)['idGroup']),
                      onTap: () {
                        Navigator.push(context, CupertinoPageRoute(builder: (_)=>ChatPage(
                            name: widget.name,
                            query: dataValue.elementAt(i)['name'].toString()
                        )));
                      },
                      trailing: IconButton(onPressed: () {

                      }, icon: const Icon(Icons.delete)),
                    );
            })
            ) ,

            //ExcludeFocus(child: Text("data"))
          ],
        ),
      ),
    );
  }
}

mixin _Home_ {
  late Socket socket;
  final List dataValue = [];
  final TextEditingController controller = TextEditingController();
  final TextEditingController controllerQuery = TextEditingController();

}