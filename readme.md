Script I used to demo. I will clean this and use proper md syntax
1.
Make sure its setup
macOS Setup Guide: https://flutter.io/setup-macos
Windows Setup Guide: https://flutter.io/setup-windows
Linux Setup Guide: https://flutter.io/setup-linux
Visual Studio Code: https://code.visualstudio.com/
Visual Studio Code Flutter Extension: https://marketplace.visualstudio.com/items?itemName=Dart-Code.flutter
Android Studio: https://developer.android.com/studio/

Link to my slides
https://docs.google.com/presentation/d/1aVgw9A3iANDIWVz8O5HF4vmqpMO9IB-8Ok75k32s1u0/edit?usp=sharing

First Step
----------
#### Check Flutter version
```bash 
flutter --version
```

#### Open simulator
```bash
open -a Simulator
```

#### `flutter emulators --launch [DeviceID]`
Starts up the emulator, installs and opens up your Flutter app.

#### `flutter emulators`
If you don't know the `DeviceID`, you can run this to get the list of your available emulators.

#### `flutter run -d [DeviceID]`
Starts the project on either an emulator or device. Depending on the specified `DeviceID`.

#### `flutter run -d [DeviceID] --flavor=[flavor]`
To run on Android with more that one build flavor, please specify `flavor`.

#### `flutter devices`
If you don't know the `DeviceID`, you can run this to get the list of your available devices that have already been started or connected to the computer.

------

Flutter is a toolset and a framework at the same time.

Dartpad for learning basic of dart
https://dartpad.dartlang.org/

Sample if needed:

```dart
class Person {
  String name = 'sumith';
  int age = 30;
}

double addNumbers(double num1, double num2) { return num1 + num2; }

void main() {
  
  for (int i = 0; i < 5; i++) {
    print('hello ${i + 1}');
  }
  
  var p1 = Person();
  var p2 = Person();
  p2.name ='Andre';
  
  print(p1.name);
  print(p2.name);
  
  double addnumberResult = addNumbers(2,3);
  print(addnumberResult);
}
```


## Slide 8

Make sure its all working

```bash 
flutter doctor
flutter create todo_app
flutter run
```

Show Dart devTools

Android Studio or VSCode


	Quick update change the click to 2 times.

All good lets work on the Todo app.

For that we need a `task_list`

To start with lets create a model

```dart 
class Task {
  String name, details;
  bool completed = false;

  static List<Task> _tasks = [
    Task('Choose topic', 'testing desc'),
    Task('Drink coffee', null),
    Task('Prepare codelab', null),
    Task('Update SDK', 'Flutter'),
  ];

  static List<Task> get tasks => _tasks;

  Task(this.name, this.details);  // Constructor with parameters for creating a Task object
}
```

Lets delete every thing in `main.dart`
`main.dart` is the starting point
Talk about the main function -> is the entry point

```dart
import 'package:flutter/material.dart';
import 'task_list_view.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: TaskListView(),
    );
  }
}
```

So the home points to `TaskListView`, lets create a `task_list_view.dart`

Talk about scaffold

```dart
import 'package:flutter/material.dart';

import 'model.dart';

class TaskListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
      ),
      body: ListView(
        children: <Widget>[
          for (final task in Task.tasks)
            ListTile(
              leading: IconButton(
                icon: (task.completed)
                    ? Icon(Icons.check_circle)
                    : Icon(Icons.radio_button_unchecked),
                onPressed: null,
              ),
              title: Text(task.name),
              subtitle: (task.details != null) ? Text(task.details) : null,
            ),
        ],
      ),
    );
  }
}
```

We are using a for loop so modify `pubspec.yaml`

```yaml
sdk: ">=2.2.2 <3.0.0"
```


Talk about hotreload, and restart 

Now you got the checkbox, lets see if we can reflect these toggle in code
Talk about stateful vs stateless widgets

In `task_list_view.dart`

Change `onPressed: () => toggleTask(task),`

Change the class  extend to StatefulWidget

```dart
@override
  _TaskListViewState createState() => _TaskListViewState();
}

class _TaskListViewState extends State<TaskListView> {
  void toggleTask(Task task) {
    setState(() {
      task.completed = !task.completed;
    });
  }
  
  ...
  
}
 ```

------------------------  thats pretty easy and awesome check if its break time-----------------


This looks like a long list would be nice if we can seperate our list to the ones completed different 

We extract the list in its own list tile widget 

```dart
Widget _listTile(Task task) {
    return ListTile(
      leading: IconButton(
        icon: (task.completed)
            ? Icon(Icons.check_circle)
            : Icon(Icons.radio_button_unchecked),
        onPressed: () => toggleTask(task),
      ),
      title: Text(task.name),
      subtitle: (task.details != null) ? Text(task.details) : null,
    );
  }
```


`for (final task in Task.tasks) _listTile(task),


Lets modify the model "model.dart" and add method to ... Not the best practice, les make it work.

```dart
static List<Task> get currentTasks =>
      _tasks.where((task) => !task.completed).toList();

static List<Task> get completedTasks =>
      _tasks.where((task) => task.completed).toList();
```


Now we seperate the current task and completed tasks in the list view

```dart
for (final task in Task.currentTasks) _listTile(task),
for (final task in Task.currentTasks) _listTile(task),
          Divider(),
          ExpansionTile(
            key: _completedKey,
            title: Text('Completed (${Task.completedTasks.length})'),
            children: <Widget>[
              for (final task in Task.completedTasks) _listTile(task),
            ],
          )
        ],
```

---------------- So we would like to add some tasks to the list --------------
Lets create a new dart file `add_task_dialog.dart` -> stateful widget, I will copy some code and explain as i go along.....

```dart
import 'package:flutter/material.dart';

import 'model.dart';

class AddTaskDialog extends StatefulWidget {
  @override
  _TaskDialogState createState() => _TaskDialogState();
}

class _TaskDialogState extends State<TaskDialog> {
  String _taskName = '';
  String _taskDetails;

  void _save() {
    final task = _taskName.isNotEmpty ? Task(_taskName, _taskDetails) : null;
    Navigator.of(context).pop(task);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('New Task'),
      ),
      body: Form(
        child: ListView(
          padding: const EdgeInsets.all(16.0),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Name',
                  filled: true,
                ),
                style: theme.textTheme.headline,
                onChanged: (value) => _taskName = value,
                autofocus: true,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              alignment: Alignment.bottomLeft,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Details',
                  filled: true,
                ),
                onChanged: (value) => _taskDetails = value,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

We modify our `task_list` add a floating action button

```dart
floatingActionButton: FloatingActionButton(
        onPressed: _addTask,
      ),

void _addTask() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDialog(),
        fullscreenDialog: true,
      ),
    );
  }
```

Lets also change `toggleTask` to be private for consistency `_toggleTask`

We can navigate from tasklist to add task dialog, finally lets add a button to save.

```dart
actions: <Widget>[
          FlatButton(
            child: Text(
              'SAVE',
              style: theme.textTheme.body1.copyWith(color: Colors.white),
            ),
            onPressed: _save,
          ),
        ],
      ),
```

When save returns we have to wait for the dialog as it returns task. So lets change the _add task to async and save it to the list

```dart
void _addTask() async {
    final task = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => TaskDialog(),
        fullscreenDialog: true,
      ),
    );

    if (task != null) {
      setState(() {
        Task.tasks.add(task);
      });
    }
  }
```
--------- finally if we have time lets look at theming and delete

In `main.dart`
We see `theme:` , lets add the dark theme

```dart
theme: ThemeData.dark(),
```

--------
Delete task -> we can play with platform specific dialogs here

Lets add an trailing ICON

```dart
subtitle: (task.details != null) ? Text(task.details) : null,
      trailing: IconButton(
        icon: Icon(Icons.delete_forever),
        onPressed: () => _deleteTask(task),
      ),
```

```dart
import 'dart:io';

import 'package:flutter/cupertino.dart';

void _deleteTask(Task task) async {
    final confirmed = (Platform.isIOS)
        ? await showCupertinoDialog<bool>(
            context: context,
            builder: (context) => CupertinoAlertDialog(
              title: const Text('Delete Task?'),
              content: const Text('This task will be permanently deleted.'),
              actions: <Widget>[
                CupertinoDialogAction(
                  child: const Text('Delete'),
                  isDestructiveAction: true,
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                CupertinoDialogAction(
                  child: const Text('Cancel'),
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          )
        : await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Delete Task?'),
              content: const Text('This task will be permanently deleted.'),
              actions: <Widget>[
                FlatButton(
                  child: const Text("CANCEL"),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
                FlatButton(
                  child: const Text("DELETE"),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            ),
          );

    if (confirmed ?? false) {
      setState(() {
        Task.tasks.remove(task);
      });
    }
  }
```


For consistency lets change floating button to:

```dart
For consistency lets change floating button to:
floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: _addTask,
      ),
```
