
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:capstone/list_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title:'DiceyProductivity',home:MyApp()));
}
var isLoaded = false;
int rollDice( int largestNum){
  return Random().nextInt(largestNum);
}
_writeFile(String text, String filename) async {

  final File file = File('lib\\Assets\\files\\${filename}');
  await file.writeAsString(text);
  
}


var font = 'OpenDyslexic';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
@override
State<MyApp> createState()=> _MyApp();

}
class _MyApp extends State<MyApp>{
  // This widget is the root of your application.
      /*static void changefont(){
      setState((){
      if(font == 'OpenDyslexic'){
        font = 'Ariel';
      }else{
        font = 'OpenDyslexic';
      }
      });
    }*/
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(
        fontFamily: font,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffCA9CE1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
    );

    
}


  }


class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;
  
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(

        child: Column(

          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                  FloatingActionButton.extended(
                    heroTag: "settings",
                    onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => const Settings()),
                  );
              },
                    
                    tooltip: 'opens settings',
                    label: const Icon(Icons.settings),
                  ),
                ],
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.inversePrimary)),
                  child: const Text("Your list"),
                  onPressed: (){
                    isLoaded=false;
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => const YourList()),
                  );
              },

                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                )
              ],
            ),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.inversePrimary)),
                  child: const Text("Self Care"),
                  onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => SelfCareList()),
                  );
              }, 
                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: const EdgeInsets.all(10),
                )
              ],
            ),
            FloatingActionButton(
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) =>const NewList()),
                  );
              },
              tooltip: 'opens make new list screen',
              child: const Icon(Icons.add),
            ),
              ],
            ),
            
          ],
        ),
      ),
      
    );
  }
}
  Future<List<listItem>> _readFile(String filename,String listname) async {
  String text ="";
  try {
    final File file = File('lib\\Assets\\files\\$filename');
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
    print(e);
  }
  if(text != ""){
  var decoded = jsonDecode(text)[listname] as List;
  List<listItem> items =decoded.map((listitemjson) => listItem.fromJson(listitemjson)).toList();
  return items;
  }
  return <listItem> [listItem('null', 0, false)];
}
class YourList extends StatefulWidget{
@override
  State<YourList> createState()=> _stateYourList();
  const YourList({super.key});
}
class _stateYourList extends State<YourList>{
  List<listItem>? yourlist;

  getData() async{
    yourlist = await _readFile("yourlist.txt", "yourlist");
setState(() {
    isLoaded=true;
  });
  }

  @override
  void initState(){
    super.initState();
    getData();
  }

  Future<listItem> showEditScreen(String title, String description, int weight) async {
    var newName;
    var newDescription;
    int newWeight = 5;
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

  listItem listitem = await  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: EdgeInsets.only(
            top: 10.0,
          ),
          title: Text(
            "Edit "+title,
            style: TextStyle(fontSize: 24.0),
          ),
          content: Container(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Name of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Name here ex: ' + title,
                          labelText: 'Name'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Description of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter description here ex: '+description,
                          labelText: 'Description'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Weight of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: weightController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter weight here ex: '+weight.toString(),
                          labelText: 'Weight'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        newName =  nameController.text;
                        newWeight = int.parse(weightController.text);
                        newDescription = descriptionController.text;
                        listItem item = new listItem.withDescription(newName, newDescription,newWeight,false);
                        Navigator.of(context).pop(item);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        // fixedSize: Size(250, 50),
                      ),
                      child: Text(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                          ),
                        "Submit",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });
return listitem;
}
  Future<String> showRemoveScreen() async {
    final TextEditingController  nameController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: EdgeInsets.only(
            top: 10.0,
          ),
          title: Text(
            "Edit ",
            style: TextStyle(fontSize: 24.0),
          ),
          content: Container(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Name of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Name here ',
                          labelText: 'Name'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(nameController.text);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        // fixedSize: Size(250, 50),
                      ),
                      child: Text(
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary
                          ),
                        "delete quest",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      });

  }
  @override
  Widget build(BuildContext context){
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your list"),
        
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child:Column(
          children: [
            Expanded(child:
            ListView.builder(
          itemCount: yourlist?.length,
          itemBuilder: (context, index){
            return Container(
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children:[
                      Checkbox(
                      checkColor: Colors.white,
                      value: yourlist![index].done,
                      onChanged: (bool? value) {
                        String yourlistjson = "{\"yourlist\":[";
                        for (int i =0; i < yourlist!.length; i++){
                          yourlistjson += yourlist![i].toJson().toString();
                          if(i!=yourlist!.length-1){
                            yourlistjson +=",";
                          }
                        }
                        yourlistjson+= "]}";
                        _writeFile(yourlistjson, 'yourlist.txt');
                        setState(() {
                          yourlist![index].done = value!;
                        });
                      }),
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                      yourlist![index].title,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                      
                    ), 
                    ),
                    
                    FloatingActionButton(onPressed: () async {
                      listItem item =  await showEditScreen(yourlist![index].title, yourlist![index].description, yourlist![index].weight);
                      yourlist![index] = item;
                      String yourlistjson = "{\"yourlist\":[";
                      for (int i =0; i < yourlist!.length; i++){
                        yourlistjson += yourlist![i].toJson().toString();
                        if(i!=yourlist!.length-1){
                          yourlistjson +=",";
                        }
                      }
                      yourlistjson+= "]}";
                      _writeFile(yourlistjson, 'yourlist.txt');
                      setState(() {
                        isLoaded=false;
                      });
                      getData();
                    },
                    heroTag: "edit$index",
                    child: const Icon(Icons.edit),
                    )
                    ]
                  ),
                  
                ],
                )
            );
          },
        ), 
        ),
        Row(
          children:[
          FloatingActionButton(onPressed: () async {
            listItem newlistItem = await showEditScreen("New quest","a quest to help defeat the dragon", 5);
            yourlist?.add(newlistItem);
            String yourlistjson = "{\"yourlist\":[";
            for (int i =0; i < yourlist!.length; i++){
              yourlistjson += yourlist![i].toJson().toString();
              if(i!=yourlist!.length-1){
                yourlistjson +=",";
              }
            }
            yourlistjson+= "]}";
            _writeFile(yourlistjson, 'yourlist.txt');
            setState(() {
              isLoaded=false;
            });
            getData();
          },
          heroTag: "addItem",
          
            child: const Icon(Icons.add),
          ) ,
          FloatingActionButton(onPressed: () async {
            String name = await showRemoveScreen();
            for(int i = 0; i< yourlist!.length; i++){
              if(name== yourlist![i].title){
                yourlist!.removeAt(i);
                break;
              }
            }
              String yourlistjson = "{\"yourlist\":[";
            for (int j = 0; j < yourlist!.length; j++){
              yourlistjson += yourlist![j].toJson().toString();
              if(j!=yourlist!.length-1){
                yourlistjson +=",";
              }
            }
            yourlistjson+= "]}";
            _writeFile(yourlistjson, 'yourlist.txt');
            setState(() {
              isLoaded=false;
            });
            getData();
            }
          ,
          heroTag: "removeItem",
          child: const Icon(Icons.remove ),
          ),
          ]
        )
          
          
        ],) 
        
      ),
    );

  }
}

class SelfCareList extends StatelessWidget{

final selfcarelist = [listItem('title', 5, false), listItem("2", 5, false)];
//List<listItem> readFile(){

//}
    void addItem(String title, String description, int weight){
      selfcarelist.add(listItem.withDescription(title, description, weight, false));
    }
    
  SelfCareList({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Self Care Tasks"),
      ),
      body: Center(
        child:Column(
          children: [
            Expanded(child:
            ListView.builder(
          itemCount: selfcarelist.length,
          itemBuilder: (context, index){
            return Container(
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children:[
                      Container(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                      selfcarelist[index].title,
                      style: const TextStyle(
                        fontSize: 24,
                      ),
                      
                    ), 
                    ),
                    
                    FloatingActionButton(onPressed: (){

                    },
                    child: const Icon(Icons.edit),
                    )
                    ]
                  ),
                  

                ],
                )
            );
          },
        ), 
        ),
        Container(
          padding: const EdgeInsets.all(10),
          child:
          FloatingActionButton(onPressed: (){
          },
            child: const Icon(Icons.add),
          ) ,
        )
          
        
        ],) 
        
      ),
    );
  }
}
bool healMonster = false;
bool openDylexicfont = false;
bool halloween = false;
bool dark = false;
class Settings extends StatefulWidget{
  const Settings({super.key});
  @override
  State<Settings> createState()=> _stateSettings();
}
class _stateSettings extends State<Settings>{


  @override
  Widget build(BuildContext context){
    
    

    void onChanged(bool boolean){}
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: healMonster, onChanged: (bool boolean){
                if(boolean){}
                else{}
                setState(() {
                  healMonster = boolean;
                });
              }),
              const Text(
                "Heal Monster",
                
                )
            ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: openDylexicfont, 
              onChanged: (bool boolean){

                //_MyApp _myApp = new _MyApp();
                //_myApp.build(context);
                setState((){
                  openDylexicfont = boolean;
                });
              }),
              const Text("OpenDyslexic font")
            ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: halloween, onChanged: (bool boolean){
                if(boolean){}
                else{}
                setState(() {
                  halloween = boolean;
                });
              }),
              const Text("Halloween mode")
            ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: dark, onChanged: (bool boolean){
                if(boolean){}
                else{}
                setState(() {
                  dark = boolean;
                });
                }),
              const Text("Dark mode")
            ],
            ),
          ],
          ),
      ),
    );
    
  }
}

class NewList extends StatelessWidget{
  const NewList({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Make a new List"),
      ),
      body: const Center(),
    );
  }
}

