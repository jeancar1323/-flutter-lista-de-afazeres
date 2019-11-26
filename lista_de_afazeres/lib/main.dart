import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'models/item.dart';



void main() => runApp(MyApp());


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Hello World",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: HomePage(),
    );
  }
}


var items = new List<Item>();
var tcvAdcItem = TextEditingController();

// ignore: must_be_immutable
class HomePage extends StatefulWidget{
  HomePage(){
    items = [];

  }
  @override
  _HomePageState createState() => _HomePageState();
}



class _HomePageState extends State<HomePage> {

  _HomePageState(){
    loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextFormField(
          controller: tcvAdcItem,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Colors.white,
            fontSize: 18,
          ),
          decoration: InputDecoration(
              labelText: "Digite seu afazer:" ,
              labelStyle: TextStyle(
                  color:  Colors.white
              )
          ),

        ),
      ),
      body: ListView.builder(
        itemCount: items.length ,
        itemBuilder: (BuildContext ctxt, int index) {
          final item = items[index];
          return Dismissible(
              child: CheckboxListTile(
                title: Text( item.title),
                value: item.done,
                onChanged: (value){
                  setState(() {
                    item.done = value;
                    saveItem();
                  });

                },
              ),
              background: Container(
                color: Colors.red.withOpacity(0.2),
                child: Center(
                  child: Text("Excluir"),
                ),
              ),
              key: Key(item.title),
              onDismissed: (dire){
                removerItem(index);
              } //onDimiss,

          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addItem,
        child: Icon(Icons.add),
        backgroundColor: Colors.lightGreen,
      ),

    );
  }



  void addItem() {
    if ( tcvAdcItem.text != "") {
      setState(() {
        items.add(Item( tcvAdcItem.text, false));
        tcvAdcItem.text = "";
        saveItem();
      });
    }else {
      Toast.show("Adcione um texto", context, duration: Toast.LENGTH_LONG, gravity:  Toast.BOTTOM);
    }
  }

  void removerItem(int index){
    setState(() {
      items.removeAt(index);
      saveItem();
    });


  }

  Future loadItems()  async {
    var prefs = await SharedPreferences.getInstance();
    var data = prefs.getString('data');
    print("load");
    if (data != null){
      Iterable decoded = jsonDecode(data);
      List<Item> result = decoded.map((x) => Item.fromJson(x)).toList();
      setState(() {
        items = result;
        print(items);
      });
    }
  }

  Future saveItem() async{
    var prefs = await SharedPreferences.getInstance();
    await prefs.setString('data', jsonEncode(items));
  }




}








