
import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:capstone/list_item.dart';
import 'package:capstone/monster.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MaterialApp(title:'DiceyProductivity',home:MyApp()));
}
var isLoaded = false;
int rollDice( int largestNum){
  return Random().nextInt(largestNum);
}
_writeFile(String text, String filename) async {
  final directory = await getApplicationDocumentsDirectory();
  final path = directory.path;
File file = File('$path/$filename');

    bool bolean = await file.exists();
    if (!bolean) {
      file.create();
      file.writeAsString(text);
       // Close the file
    }
    // Open the file in write mode
      IOSink sink = file.openWrite(mode: FileMode.writeOnly);
      try {
        // Write your data to the file
        sink.write(text);
        await sink.flush(); // Ensure data is written
      } finally {
        await sink.close();
      }
  //final File file = File('Assets\\files\\'+filename);
  //await file.writeAsString(text);
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
  
  Future<bool> askPermissions() async{
    PermissionStatus status = await Permission.manageExternalStorage.request();
      if (status.isDenied) {
        await Permission.manageExternalStorage.request();
      }
      return status.isGranted;
    }
  @override
  Widget build(BuildContext context) {
    askPermissions();
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
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File("$path/$filename");
    text = await file.readAsString();
  } catch (e) {
    print(e);
  }
  if(text != ""){
  var decoded = jsonDecode(text)[listname] as List;
  List<listItem> items =decoded.map((listitemjson) => listItem.fromJson(listitemjson)).toList();
  return items;
  }
  return <listItem> [listItem.withDescription('','', 0, false)];
}
  Future<Monster> _readMonsterFile(String filename) async {
  String text ="";
  try {
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File("$path/$filename");
    text = await file.readAsString();
  } catch (e) {
    print(e);
  }
  if(text != ""){
    var decoded = jsonDecode(text);
  return Monster.fromJson(decoded);
  }
  return Monster(100, 100, "temp_dragpn.jpg");
}
class YourList extends StatefulWidget{
@override
  State<YourList> createState()=> _stateYourList();
  const YourList({super.key});

}
// ignore: camel_case_types
class _stateYourList extends State<YourList>{
  List<listItem>? yourlist;
  Monster? yourMonster;
  getData() async{
    yourlist = await _readFile("yourlist.txt", "yourlist");
    yourMonster = await _readMonsterFile("yourmonster.txt");
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
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController weightController = TextEditingController();

  var listitem = await  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: Text(
            "Edit $title",
            style: const TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Name of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          
                          hintText: 'Enter Name here ex: $title',
                          labelText: 'Name'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Description of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: descriptionController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter description here ex: $description',
                          labelText: 'Description'),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Weight of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: weightController,
                      decoration: InputDecoration(
                          border: const OutlineInputBorder(),
                          hintText: 'Enter weight here ex: $weight',
                          labelText: 'Weight'),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 60,
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        if(nameController.text != ""){
                          title = nameController.text;
                        }
                        if(weightController.text != ""){
                          weight = int.parse(weightController.text);
                        }
                        if(descriptionController.text != ""){
                          description = descriptionController.text;
                        }
                        listItem item = listItem.withDescription(title, description,weight,false);
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
      listitem ??= listItem.withDescription(title, description,weight,false);
return listitem;
}
  Future<String> showRemoveScreen() async {
    final TextEditingController  nameController = TextEditingController();

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text(
            "Edit ",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 400,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "Name of quest",
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
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
  showDicePopUp(String name) async {

    return await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(
                20.0,
              ),
            ),
          ),
          contentPadding: const EdgeInsets.only(
            top: 10.0,
          ),
          title: const Text(
            "Edit",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
            height: 400,
            child:  Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Name of quest: $name",
                    ),
                  ),
                  
                ],
              ),
            ),
        );
      });

  }
  
  @override
  Widget build(BuildContext context){

    
    
    return Scaffold(
      appBar: AppBar(
        title:  const Text("Your List"),
        
      ),
      body: Visibility(
        visible: isLoaded,
        replacement: const Center(
          child: CircularProgressIndicator(),
        ),
        child:
        Column(
          children: [
            Container(
              child: Expanded(child:
            ListView.builder(
          itemCount: yourlist?.length,
          itemBuilder: (context, index){
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children:[
                    Checkbox(
                    checkColor: Colors.white,
                    value: yourlist![index].done,
                    onChanged: (bool? value) {
                      yourlist![index].done = value!;
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
                        yourlist![index].done = value;
                        if(value){
                          yourMonster?.setCurrentHealth(((yourMonster!.getCurrentHealth()- yourlist![index].weight) as int?)!);
                        }else{
                          yourMonster?.setCurrentHealth(((yourMonster!.getCurrentHealth()+ yourlist![index].weight) as int?)!);
                        }
                        if(yourMonster!.getCurrentHealth() <= 0){
                          yourMonster?.setImageName("deadDragon.jpg");
                        }else{
                          yourMonster?.setImageName("temp_dragpn.jpg");
                        }
                      });
                      String yourdragonJson = "${yourMonster!.toJson()}";
                      _writeFile(yourdragonJson, "yourmonster.txt");
                    }),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsetsDirectional.all(10),
                        child: Text(
                    yourlist![index].title,
                    style: const TextStyle(
                      fontSize: 24,
                    ),
                    
                  ),
                        ) 
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
                    await getData();
                  },
                  heroTag: "edit$index",
                  child: const Icon(Icons.edit),
                  ),
                  ]
                ),
                Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                        yourlist![index].description,
                        style: 
                          const TextStyle(
                            fontSize: 12,
                          ),
                          )
                        )
                      
                    ),
                  ],
                ),
                
              ],
              );
          },
        ), 
        ),
            ),
            
        Column(
          children:[
            Row(
              children: [
                Image.asset("Assets/images/${yourMonster?.getimageName()}",
                height: 200,
                scale: 2,
                )
                
              ],
              
            ),
            Row(
              children: [
                Text("${yourMonster?.getCurrentHealth()}/${yourMonster?.getHealth()}"),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      yourMonster!.setCurrentHealth(yourMonster!.getHealth());
                    });
                    String yourdragonJson = "${yourMonster!.toJson()}";
                    _writeFile(yourdragonJson, "yourmonster.txt");
                  },
                  child: Text("Reset Health")
                )
            ],
            ),
            Row(
              children:[
                Padding(padding: const EdgeInsets.all(10),
                child: FloatingActionButton(onPressed: () async {
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
                await getData();
              },
              heroTag: "addItem",
              
                child: const Icon(Icons.add),
              ) ,
                ),
              Padding(padding: const EdgeInsets.all(10),
              child:FloatingActionButton(onPressed: () async {
                String name = await showRemoveScreen();
                for(int i = 0; i< yourlist!.length; i++){
                  if(name== yourlist![i].getTitle()){
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
                await getData();
                }
              ,
              heroTag: "removeItem",
              child: const Icon(Icons.remove ),
              ), 
              ),
              
              ElevatedButton(
                onPressed: (){
                  showDicePopUp(yourlist![rollDice(yourlist!.length)].getTitle());
                }, 
                child: const Text("Randomly assign Quest")
                ),
              ]
            ),
          ],),
          
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
            return Column(
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
// ignore: camel_case_types
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

