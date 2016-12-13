import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Task {
  String uuid;
  String text;
  bool completed;
  int createdAt;

  Task({this.uuid, this.text, this.completed, this.createdAt});
}

var uuid = new Uuid();
Map<String, Task> tasks = <String, Task>{};

GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
GlobalKey<FormFieldState<InputValue>> _textFieldKey =
new GlobalKey<FormFieldState<InputValue>>();

void main() {
  runApp(new App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new TaskListView(title: 'ToDos'),
    );
  }
}

class TaskListView extends StatefulWidget {
  TaskListView({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _TaskListViewState createState() => new _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  void checkTask(String id) {
    setState(() {
      tasks[id].completed = true;
    });
  }

  void uncheckTask(String id) {
    setState(() {
      tasks[id].completed = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(config.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Form(
              key: _formKey,
              child: new Row(
                children: <Widget>[
                  new Flexible(
                    child: new Padding(
                      padding: const EdgeInsets.only(top: 10.0, left: 10.0),
                      child: new InputFormField(
                        key: _textFieldKey,
                        keyboardType: TextInputType.text,
                        onSaved: (InputValue input) {
                          setState(() {
                            String id = uuid.v4();
                            tasks[id] = new Task(
                                uuid: id,
                                text: input.text,
                                completed: false,
                                createdAt:
                                new DateTime.now().millisecondsSinceEpoch);
                            _textFieldKey.currentState.reset();
                          });
                        },
                      ),
                    ),
                  ),
                  new FlatButton(
                    child: new Text('SUBMIT'),
                    onPressed: () {
                      _formKey.currentState.save();
                    },
                  ),
                ],
              ),
            ),
            new ScrollableList(
              itemExtent: 50.0,
              children: tasks.keys.map((String id) {
                Task task = tasks[id];
                return new Row(
                  children: <Widget>[
                    new Checkbox(
                      value: task.completed,
                      onChanged: (bool completed) {
                        if (completed) {
                          checkTask(id);
                        } else {
                          uncheckTask(id);
                        }
                      },
                    ),
                    new Flexible(
                      child: new GestureDetector(
                        child: new Text(task.text),
                        onDoubleTap: () {
                          setState(() {
                            tasks.remove(id);
                          });
                        },
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
