import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/item.dart';
import 'package:flutter_application_1/services/todo_list_service.dart';
import 'package:provider/provider.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({super.key});

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  addSection(BuildContext context) {
    final todoListService =
        Provider.of<TodoListService>(context, listen: false);

    return showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return SizedBox(
          height: 150,
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: TextField(
                    controller: myController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Enter a to-do item',
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.only(left: 10.0),
                  height: 60,
                  child: ElevatedButton(
                    child: const Text('ADD'),
                    onPressed: () {
                      if (myController.text == "") {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Sorry'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Please add some to-do list detail'),
                                  ],
                                ),
                              ),
                              actions: <Widget>[
                                TextButton(
                                  child: const Text('ok'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          },
                        );
                      } else {
                        todoListService.add(Item(detail: myController.text));
                        myController.text = "";
                        Navigator.pop(context);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("To-do List"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Add item',
            onPressed: () {
              addSection(context);
            },
          ),
        ],
      ),
      body: Consumer<TodoListService>(
        builder: (context, data, index) {
          var todoList = data.getList;

          return ListView.builder(
            itemCount: todoList.length,
            itemBuilder: (context, index) {
              Item item = todoList[index];
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: item.isMarked,
                          onChanged: (bool? value) {
                            data.toggleMark(index);
                          },
                        ),
                        item.isMarked
                            ? Text(
                                item.detail,
                                style: const TextStyle(
                                  fontSize: 20,
                                  decoration: TextDecoration.lineThrough,
                                ),
                              )
                            : Text(
                                item.detail,
                                style: const TextStyle(
                                  fontSize: 20,
                                ),
                              ),
                      ],
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.red,
                      onPressed: () {
                        data.removeAt(index);
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
