import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:taskly/models/task.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  late double _deviceHeight, _deviceWidth;
  String? _newTaskContent;
  Box? _box;

  _HomePageState();

  @override
  void initState() {
    super.initState();
  }

  bool _homeState = true;

  void handleState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: _deviceHeight * 0.15,
        title: const Text(
          "Taskly",
          style: TextStyle(
              fontSize: 25, color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: Colors.green,
      ),
      body: _taskView(),
      floatingActionButton: _addTaskButton(),
    );
  }

  Widget _taskView() {
    return FutureBuilder(
      future: Hive.openBox("tasks"),
      builder: (BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          _box = _snapshot.data;
          return _listView();
        } else {
          return const LinearProgressIndicator(
            color: Colors.green,
          );
        }
      },
    );
  }

  Widget _listView() {
    // On recupère tout les élément contenus dans notre _box
    List tasks = _box!.values.toList();

    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (BuildContext _context, int _index) {
          var _task = Task.fromMap(tasks[_index]);

          return ListTile(
              onLongPress: () {
                setState(() {
                  _box!.deleteAt(_index);
                });
              },
              onTap: () {
                setState(() {
                  _task.isDone = !_task.isDone;
                  _box!.putAt(_index, _task.toMap());
                });
              },
              title: Text(
                _task.content,
                style: _task.isDone == true
                    ? const TextStyle(decoration: TextDecoration.lineThrough)
                    : null,
              ),
              subtitle: Text(_task.timestamp.toString()),
              trailing: IconButton(
                onPressed: () {
                  setState(() {
                    _task.isDone = !_task.isDone;
                    _box!.putAt(_index, _task.toMap());
                    
                  });
                },
                icon: Icon(_task.isDone == true
                    ? Icons.check_box_outlined
                    : Icons.check_box_outline_blank),
                color: Colors.green,
              ));
        });
  }

  Widget _addTaskButton() {
    return FloatingActionButton(
      onPressed: _addFormPopup,
      backgroundColor: Colors.green,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
      child: const Icon(Icons.add),
    );
  }

  void _addFormPopup() {
    showDialog(
      context: context,
      builder: (BuildContext _context) {
        return AlertDialog(
          title: const Text("Add new Task"),
          content: TextField(
            onSubmitted: (_value) {
              if (_newTaskContent != null || _newTaskContent != '') {
                var task = Task(
                    content: _newTaskContent!,
                    timestamp: DateTime.now(),
                    isDone: false);
                _box!.add(task.toMap());

                setState(() {
                  _newTaskContent = null;
                });

                Navigator.pop(context);
              }
            },
            onChanged: (_value) {
              setState(() {
                _newTaskContent = _value;
              });
            },
          ),
        );
      },
    );
  }
}
