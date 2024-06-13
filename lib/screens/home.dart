import 'package:cybercheck/model/todo.dart';
import 'package:cybercheck/widgets/todo_item.dart';
import 'package:flutter/material.dart';
import 'package:cybercheck/components/colors.dart';
import 'package:cybercheck/screens/settings.dart';
import 'package:cybercheck/screens/login_screen.dart';
import 'package:cybercheck/model/database_helper.dart';

class Home extends StatefulWidget {
  final Function toggleTheme;

  Home({Key? key, required this.toggleTheme}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ToDo> _foundToDo = [];
  final _todoController = TextEditingController();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    _loadToDos();
  }

  Future<void> _loadToDos() async {
    final todos = await _dbHelper.todos();
    setState(() {
      _foundToDo = todos;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark
          ? Theme.of(context).scaffoldBackgroundColor
          : backgroundColor,
      appBar: _buildAppBar(context),
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Column(
              children: [
                searchBox(),
                Expanded(
                  child: ListView(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 50, bottom: 20),
                        child: Text('Tarefas', style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500)),
                      ),
                      for (ToDo todoo in _foundToDo.reversed)
                        ToDoItem(
                          todo: todoo,
                          onToDoChanged: _handleToDoChange,
                          onDeleteItem: _deleteToDoItem,
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(bottom: 20, right: 20, left: 20),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    decoration: BoxDecoration(
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.grey[800] : Colors.white,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(0.0, 0.0),
                          blurRadius: 10.0,
                          spreadRadius: 0.0,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: TextField(
                      controller: _todoController,
                      style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black),
                      decoration: InputDecoration(
                        hintText: 'Adicione uma nova tarefa',
                        hintStyle: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.5)),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(bottom: 20, right: 20),
                  child: FloatingActionButton(
                    child: Icon(Icons.add, size: 30),
                    onPressed: () {
                      _addToDoItem(_todoController.text);
                    },
                    backgroundColor: Color(0xFF25BBFD),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _dbHelper.updateToDo(todo); // Atualize no banco de dados
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      _dbHelper.deleteToDo(id); // Delete do banco de dados
      _foundToDo.removeWhere((item) => item.id == id);
    });
  }

  void _addToDoItem(String todoText) async {
    if (todoText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('A tarefa não pode estar vazia!'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }
    
    final newToDo = ToDo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      todoText: todoText,
    );

    await _dbHelper.insertToDo(newToDo); // Insira no banco de dados

    setState(() {
      _foundToDo.add(newToDo);
    });

    _todoController.clear();
  }

  void _runFilter(String enteredKeyword) {
    List<ToDo> results = [];
    if (enteredKeyword.isEmpty) {
      _loadToDos(); // Recarregue todas as tarefas
    } else {
      results = _foundToDo.where((item) => item.todoText!.toLowerCase().contains(enteredKeyword.toLowerCase())).toList();
      setState(() {
        _foundToDo = results;
      });
    }
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('CyberCheck'),
      actions: [
        IconButton(
          icon: const Icon(Icons.settings),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SettingsScreen(toggleTheme: widget.toggleTheme)),
            );
          },
        ),
      ],
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: const Text('Menu'),
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
          ),
          ListTile(
            leading: Icon(Icons.settings),
            title: Text('Configurações'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen(toggleTheme: widget.toggleTheme)),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text('Sair'),
            onTap: () {
              Navigator.pop(context);
              _signOut();
            },
          ),
        ],
      ),
    );
  }

void _signOut() {
Navigator.of(context).pushReplacement(
  MaterialPageRoute(builder: (context) => LoginScreen(toggleTheme: widget.toggleTheme)),
  );
}

  Widget searchBox() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        onChanged: (value) => _runFilter(value),
        decoration: const InputDecoration(
          hintText: 'Pesquisar',
          hintStyle: TextStyle(color: Colors.grey),
          border: InputBorder.none,
          icon: Icon(Icons.search),
        ),
      ),
    );
  }
}
