import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  List<Todo> todos = [
    Todo(
      id: 1,
      details: 'Walk the goldfish',
      status: false,
    ),
  ];

  final ScrollController _sc = ScrollController();
  final TextEditingController _tc = TextEditingController();
  final TextEditingController _etc = TextEditingController();
  final FocusNode _fn = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Todos App'),
        ),
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Expanded(
                  child: Scrollbar(
                      controller: _sc,
                      child: SingleChildScrollView(
                          child: Column(
                        children: [
                          for (Todo todo in todos)
                            todo.status == false
                                ? GestureDetector(
                                    onDoubleTap: () {
                                      markAsDone(todo.id);
                                    },
                                    onLongPress: () {
                                      editDialog(todo.id);
                                    },
                                    child: GFCard(
                                      boxFit: BoxFit.cover,
                                      title: GFListTile(
                                        avatar: Text(todo.id.toString()),
                                        title: Text(todo.created.toString()),
                                      ),
                                      content: Text(todo.details),
                                      buttonBar: GFButtonBar(
                                        children: <Widget>[
                                          IconButton(
                                            icon: const Icon(
                                                CupertinoIcons.xmark),
                                            onPressed: () {
                                              removeTodo(todo.id);
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : GFCard(
                                    boxFit: BoxFit.cover,
                                    title: GFListTile(
                                      avatar: Text(
                                        todo.id.toString(),
                                      ),
                                      title: Text(todo.created.toString(),
                                          style: const TextStyle(
                                              decoration:
                                                  TextDecoration.lineThrough)),
                                    ),
                                    content: Text(todo.details,
                                        style: const TextStyle(
                                            decoration:
                                                TextDecoration.lineThrough)),
                                    buttonBar: GFButtonBar(
                                      children: <Widget>[
                                        IconButton(
                                          icon:
                                              const Icon(CupertinoIcons.xmark),
                                          onPressed: () {
                                            removeTodo(todo.id);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                        ],
                      ))),
                ),
                Container(
                  width: 80,
                  height: 80,
                  child: MaterialButton(
                    shape: const CircleBorder(
                      side: BorderSide(
                        width: 2,
                        color: Colors.white,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: const Text("Add"),
                    color: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      addDialog();
                    },
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  addTodo(String details) {
    int index = 0;
    if (todos.isEmpty) {
      index = 0;
    } else {
      index = todos.last.id + 1;
    }
    if (mounted) {
      setState(() {
        todos.add(Todo(details: details, id: index, status: false));
      });
    }
  }

  removeTodo(int id) {
    if (todos.isNotEmpty) {
      for (int i = 0; i < todos.length; i++) {
        if (id == todos[i].id) {
          todos.removeAt(i);
          setState(() {});
        }
      }
    }
  }

  markAsDone(int id) {
    print('called');
    if (todos.isNotEmpty) {
      for (int i = 0; i < todos.length; i++) {
        if (id == todos[i].id) {
          todos[i].status = true;
          setState(() {});
        }
      }
    }
  }

  editTodo(int id, String details) {
    print(id);
    print(details);
    print('called');
    if (todos.isNotEmpty) {
      for (int i = 0; i < todos.length; i++) {
        if (id == todos[i].id) {
          print(todos[i].details);
          print(details);
          todos[i].details = details;
          print(todos[i].details);
        }
      }
      setState(() {});
    }
  }

  editDialog(int id) => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Edit ToDo'),
            content: Form(
                key: _formKey,
                child: Container(
                    width: 250.0,
                    height: 250.0,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: _etc,
                            validator: (_etc) {
                              if (_etc!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              suffix: IconButton(
                                icon: const Icon(Icons.chevron_right_rounded,
                                    color: Colors.black),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    editTodo(id, _etc.text);
                                    _etc.text = '';
                                    close;
                                  }
                                },
                              ),
                            ))
                      ],
                    ))),
            actions: [TextButton(onPressed: close, child: const Text('Close'))],
          ));

  addDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text('Add Todo'),
            content: Form(
                key: _formKey,
                child: Container(
                    width: 250.0,
                    height: 250.0,
                    child: Column(
                      children: [
                        TextFormField(
                            controller: _tc,
                            validator: (_tc) {
                              if (_tc!.isEmpty) {
                                return 'Please enter some text';
                              }
                              return null;
                            },
                            maxLines: 5,
                            decoration: InputDecoration(
                              focusedBorder: const OutlineInputBorder(),
                              enabledBorder: const OutlineInputBorder(),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              suffix: IconButton(
                                icon: const Icon(Icons.chevron_right_rounded,
                                    color: Colors.black),
                                onPressed: () {
                                  if (_formKey.currentState!.validate()) {
                                    addTodo(_tc.text);
                                    _etc.text = '';
                                    close;
                                  }
                                },
                              ),
                            ))
                      ],
                    ))),
            actions: [TextButton(onPressed: close, child: const Text('Close'))],
          ));

  void close() {
    Navigator.of(context).pop();
  }
}

class Todo {
  String details;
  late DateTime created;
  int id;
  bool status;

  Todo(
      {this.details = '',
      DateTime? created,
      this.id = 0,
      this.status = false}) {
    created == null ? this.created = DateTime.now() : this.created = created;
  }
}
