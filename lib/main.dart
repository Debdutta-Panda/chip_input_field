import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import 'chip_input_field.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var controller = ChipInputController();
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          width: double.maxFinite,
          child: Padding(
            padding: const EdgeInsets.only(right: 150),
            child: Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: ChipInputField(
                    controller: controller,
                    autocomplete: true,
                    optionBuilder: (query){
                      if(query.text.isEmpty){
                        return [];
                      }
                      print("1111111");
                      print(query.text);
                      return [
                        query.text+"1",
                        query.text+"2",
                        query.text+"3",
                        query.text+"4",
                      ];
                    },
                    fieldMinHeight: 60,
                    fieldPadding: EdgeInsets.all(8),
                    tagBuilder: (data,fnDelete)=>Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(data),
                        IconButton(
                            onPressed: (){
                              fnDelete(data);
                            },
                            icon: Icon(Icons.close
                            ))
                      ],
                    ),
                    optionViewBuilder: (highlighted,index,option)=>Text(
                        option.toString(),
                      style: TextStyle(
                        color: highlighted ? Colors.red : Colors.black
                      ),
                    ),
                    optionListMaterialBuilder: (child,elevation)=>Material(
                      color: Colors.green,
                      elevation: elevation,
                      child: child,
                    ),
                    onItemWillBeDeleted: (item)=>true,
                    onTagAdded: (item){
                      print("added=$item");
                    },onTagDeleted: (item){
                      print("deleted=$item");
                    },
                    onTagsAdded: (list){
                      print("addeds=$list");
                    },
                    onChange: (value){
                      //print(value);
                    },
                ),
                ),
                ElevatedButton(
                    onPressed: (){
                      controller.addItem("123");
                    },
                    child: Text("Focus")
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}


