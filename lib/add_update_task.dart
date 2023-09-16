import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app/db_handler.dart';
import 'package:todo_app/home_sccreen.dart';

import 'model.dart';

// ignore: must_be_immutable
class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDesc;
String? todoDt;
  bool?update;
  AddUpdateTask({super.key, this.todoId,
    this.todoTitle,
    this.todoDesc,
    this.todoDt,
  this.update
  });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> datalist;
  final _formkey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
  }

  loadData() async {
    datalist = dbHelper!.getDataList();
  }

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text:widget.todoTitle);
    final descController = TextEditingController(text:widget.todoDesc);
    String appTitle;
    if(widget.update==true){
      appTitle="Update Task";
    }else {
      appTitle="Add Task";
    }
    return Scaffold(
      appBar: AppBar(
        title:  Text(
         appTitle,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
            child: Column(
          children: [
            Form(
              key: _formkey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: titleController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Note Title'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter some text";
                          }
                          return null;
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        minLines: 5,
                        controller: descController,
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            hintText: 'Write notes here'),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter some text";
                          }
                          return null;
                        }),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Material(
                    color: Colors.red[400],
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          titleController.clear();
                          descController.clear();
                        });
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ]),
                        child: const Text(
                          'Clear',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.green[400],
                    borderRadius: BorderRadius.circular(10),
                    child: InkWell(
                      onTap: () {
                        if (_formkey.currentState!.validate()) {
                          if(widget.update==true){
                            dbHelper!.update(TodoModel(
                              id: widget.todoId,
                                title: titleController.text,
                                desc: descController.text,
                              dateandtime: widget.todoDt,
                               ));
                          }else{
                            dbHelper!.insert(TodoModel(
                                title: titleController.text,
                                desc: descController.text,
                                dateandtime: DateFormat('yMd')
                                    .add_jm()
                                    .format(DateTime.now())
                                    .toString()));
                          }
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context)=>const HomeScreen()));
                          titleController.clear();
                          descController.clear();
                          if (kDebugMode) {
                            print("Data added");
                          }
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        margin: const EdgeInsets.symmetric(horizontal: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        height: 55,
                        width: 120,
                        decoration: const BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 5,
                            spreadRadius: 1,
                          )
                        ]),
                        child: const Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        )),
      ),
    );
  }
}
