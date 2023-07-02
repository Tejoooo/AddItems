import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:todo/constants.dart';
import 'package:todo/pages/login.dart';

class TodoScreen extends StatefulWidget {
  const TodoScreen({Key? key}) : super(key: key);

  @override
  State<TodoScreen> createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  List<TodoItem> todoItems = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      http.Response response = await http.get(Uri.parse(api));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        setState(() {
          todoItems = data
              .map((item) => TodoItem(
                    id: item['id'],
                    title: item['title'],
                    description: item['description'],
                  ))
              .toList();
        });
      } else {
        print('Failed to fetch data. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching data: $e');
    }
  }

  void _addTodoItem(String title, String description) async {
    try {
      http.Response response = await http.post(Uri.parse(api), body: {
        'title': title,
        'description': description,
      });

      if (response.statusCode == 201) {
        setState(() {
          todoItems.add(TodoItem(
            id: jsonDecode(response.body)['id'],
            title: title,
            description: description,
          ));
        });
      } else {
        print('Failed to add item. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while adding item: $e');
    }
  }

  void _updateTodoItem(int index, String newTitle, String newDescription) async {
    try {
      http.Response response = await http.put(
        Uri.parse('$api/update/${todoItems[index].id}/'),
        body: {
          'title': newTitle,
          'description': newDescription,
        },
      );

      if (response.statusCode == 200) {
        setState(() {
          todoItems[index].title = newTitle;
          todoItems[index].description = newDescription;
        });
      } else {
        print('Failed to update item. Error code: ${response.statusCode} and response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred while updating item: $e');
    }
  }

  void _deleteTodoItem(int index) async {
    try {
      http.Response response = await http.delete(Uri.parse('$api/detail/${todoItems[index].id}'));
      if (response.statusCode == 204) {
        setState(() {
          todoItems.removeAt(index);
        });
      } else {
        print('Failed to delete item. Error code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while deleting item: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo List'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Perform logout and redirect to login page
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: todoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(todoItems[index].title),
            subtitle: Text(todoItems[index].description),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        String newTitle = todoItems[index].title;
                        String newDescription = todoItems[index].description;
                        return AlertDialog(
                          title: const Text('Update Todo'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextField(
                                onChanged: (value) {
                                  newTitle = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Enter new title',
                                ),
                              ),
                              TextField(
                                onChanged: (value) {
                                  newDescription = value;
                                },
                                decoration: const InputDecoration(
                                  hintText: 'Enter new description',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _updateTodoItem(index, newTitle, newDescription);
                                Navigator.pop(context);
                              },
                              child: const Text('Update'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () {
                    _deleteTodoItem(index);
                  },
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              String newTitle = '';
              String newDescription = '';
              return AlertDialog(
                title: const Text('Add New Todo'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      onChanged: (value) {
                        newTitle = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter title',
                      ),
                    ),
                    TextField(
                      onChanged: (value) {
                        newDescription = value;
                      },
                      decoration: const InputDecoration(
                        hintText: 'Enter description',
                      ),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      _addTodoItem(newTitle, newDescription);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ],
              );
            },
          );
        },
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}


