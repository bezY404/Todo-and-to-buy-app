import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Daily Planner',
      theme: ThemeData(
        primaryColor: Color(0xFFFFE0B2), // bold cream
        scaffoldBackgroundColor: Color(0xFFFFF9C4), // light yellow
        cardColor: Color(0xFFFFE0B2), // bold cream for cards
        shadowColor: Colors.black26,
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFFFFE0B2),
            foregroundColor: Colors.black87,
          ),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFFFE0B2),
          foregroundColor: Colors.black87,
        ),
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<String> todos = [];
  List<bool> todoCompleted = [];
  List<Map<String, dynamic>> tobuyItems = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Daily Planner'),
        backgroundColor: Color(0xFFFFE0B2),
        foregroundColor: Colors.black87,
      ),
      body: _selectedIndex == 0
          ? TodoScreen(
              todos: todos,
              completed: todoCompleted,
              onAdd: addTodo,
              onToggle: toggleTodo,
              onDelete: deleteTodo,
            )
          : TobuyScreen(
              items: tobuyItems,
              onAdd: addTobuy,
              onToggle: toggleTobuy,
              onDelete: deleteTobuy,
            ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.check_circle),
            label: 'To-Do',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'To-Buy',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black87,
        backgroundColor: Color(0xFFFFE0B2),
        onTap: (index) => setState(() => _selectedIndex = index),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }

  void _addItem() {
    if (_selectedIndex == 0) {
      showDialog(
        context: context,
        builder: (context) => AddTodoDialog(onAdd: addTodo),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AddTobuyDialog(onAdd: addTobuy),
      );
    }
  }

  void addTodo(String task) {
    setState(() {
      todos.add(task);
      todoCompleted.add(false);
    });
  }

  void toggleTodo(int index) {
    setState(() {
      todoCompleted[index] = !todoCompleted[index];
    });
  }

  void deleteTodo(int index) {
    setState(() {
      todos.removeAt(index);
      todoCompleted.removeAt(index);
    });
  }

  void addTobuy(Map<String, dynamic> item) {
    setState(() {
      tobuyItems.add(item);
    });
  }

  void toggleTobuy(int index) {
    setState(() {
      tobuyItems[index]['purchased'] = !tobuyItems[index]['purchased'];
    });
  }

  void deleteTobuy(int index) {
    setState(() {
      tobuyItems.removeAt(index);
    });
  }
}

class TodoScreen extends StatelessWidget {
  final List<String> todos;
  final List<bool> completed;
  final Function(String) onAdd;
  final Function(int) onToggle;
  final Function(int) onDelete;

  TodoScreen({
    required this.todos,
    required this.completed,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return todos.isEmpty
        ? Center(
            child: Text(
              'No tasks yet. Add one!',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          )
        : ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  leading: Checkbox(
                    value: completed[index],
                    onChanged: (value) => onToggle(index),
                    activeColor: Color(0xFFFFE0B2),
                  ),
                  title: Text(
                    todos[index],
                    style: TextStyle(
                      decoration: completed[index] ? TextDecoration.lineThrough : null,
                      color: completed[index] ? Colors.black54 : Colors.black87,
                    ),
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(index),
                  ),
                ),
              );
            },
          );
  }
}

class TobuyScreen extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final Function(Map<String, dynamic>) onAdd;
  final Function(int) onToggle;
  final Function(int) onDelete;

  TobuyScreen({
    required this.items,
    required this.onAdd,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return items.isEmpty
        ? Center(
            child: Text(
              'No items yet. Add one!',
              style: TextStyle(fontSize: 18, color: Colors.black54),
            ),
          )
        : ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: item['purchased'] ? Colors.grey[200] : null,
                child: ListTile(
                  leading: Checkbox(
                    value: item['purchased'],
                    onChanged: (value) => onToggle(index),
                    activeColor: Color(0xFFFFE0B2),
                  ),
                  title: Text(
                    item['name'],
                    style: TextStyle(
                      color: item['purchased'] ? Colors.black54 : Colors.black87,
                    ),
                  ),
                  subtitle: item['price'] != null ? Text('\$${item['price']}') : null,
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () => onDelete(index),
                  ),
                ),
              );
            },
          );
  }
}

class AddTodoDialog extends StatefulWidget {
  final Function(String) onAdd;

  AddTodoDialog({required this.onAdd});

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(hintText: 'Enter task'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_controller.text.isNotEmpty) {
              widget.onAdd(_controller.text);
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}

class AddTobuyDialog extends StatefulWidget {
  final Function(Map<String, dynamic>) onAdd;

  AddTobuyDialog({required this.onAdd});

  @override
  _AddTobuyDialogState createState() => _AddTobuyDialogState();
}

class _AddTobuyDialogState extends State<AddTobuyDialog> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Item'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Item name'),
          ),
          TextField(
            controller: _priceController,
            decoration: InputDecoration(hintText: 'Price (optional)'),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_nameController.text.isNotEmpty) {
              double? price = _priceController.text.isNotEmpty ? double.tryParse(_priceController.text) : null;
              widget.onAdd({
                'name': _nameController.text,
                'price': price,
                'purchased': false,
              });
              Navigator.of(context).pop();
            }
          },
          child: Text('Add'),
        ),
      ],
    );
  }
}