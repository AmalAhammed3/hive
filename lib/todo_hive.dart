import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

class TodoHiveExample extends StatefulWidget {
  const TodoHiveExample({super.key});

  @override
  State<TodoHiveExample> createState() => _TodoHiveExampleState();
}

class _TodoHiveExampleState extends State<TodoHiveExample> {
  late Box box;
  TextEditingController taskController =TextEditingController();
  List<String> todoItemList = [];

  void initState(){
    super.initState();
    openBox();
  }

  openBox() async {
    box =await Hive.box('mybox');
    loadTodoItems();
  }

  loadTodoItems() async{
   List<String> tasks=box.get('todoItems')?.cast<String>();
   print("Task loaded:$tasks");
   if(tasks != null){
    setState(() {
      todoItemList=tasks;
    });
   }
  }
  void saveTodoItems() async{
    box.put('todoItems',todoItemList);
  }

  void addTodoItems(){
    if(taskController.text.isNotEmpty){
      setState(() {
        todoItemList.add(taskController.text);
      });
    }
    saveTodoItems();
  }

  void deletetodoItems(int index){
    setState(() {
      todoItemList.removeAt(index);
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TodoApp Hive"),backgroundColor: Colors.blue,centerTitle: true,),
      body: Expanded(
        child: ListView.builder(
          itemCount: todoItemList.length,
          itemBuilder: (context, index){
        return ListTile(
          title: Text(todoItemList[index]),
          trailing: IconButton(onPressed: () {
            deletetodoItems(index);
          },icon: Icon(Icons.delete),),
        );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          showModalBottomSheet(context: context, builder: (BuildContext context){
            return Container(
              height: 250,
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    TextField(
                      controller: taskController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),labelText: "Enter Task",
                      ),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                    ElevatedButton(onPressed: () {
                      addTodoItems();
                      Navigator.pop(context);
                    }, child: Text("Add")),
                    SizedBox(width: 5),
                    ElevatedButton(onPressed: () {
                      Navigator.pop(context);
                    }, child: Text("cancel")),
                      ],
                    ),
                  
                  ],
                ),
              ),
            );
          });
        },
        child: Text("+"),),
    );
  }
}
    