import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'package:capstone/list_item.dart';
import 'package:capstone/main.dart';
import 'package:capstone/monster.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
  
bool isLoaded2 = false;
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

class YourList extends StatefulWidget{
@override
  State<YourList> createState()=> _stateYourList();  
  YourList({super.key, required this.listfilename, required this.listname, required this.monsterfilename, required this.listTitle, required this.healMonster});
  final String listfilename;
  final String listname;
  final String monsterfilename;
  final String listTitle;
  final bool healMonster;
  final bool isLoaded = false;
  

}
// ignore: camel_case_types
class _stateYourList extends State<YourList>{
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
  if(listname == "yourlist"){
    return <listItem> [
    listItem.withDescription('Eat Breakfast','Eat something in the morning', 10, false),
    listItem.withDescription('Brush Teeth','Brush your teeth in the morning', 10, false),
    listItem.withDescription('Change your clothes','put on clothes for the day', 10, false),
    listItem.withDescription('Brush Hair','Brush your hair', 10, false),
    listItem.withDescription('Eat Lunch','Eat something in the middle of the day', 10, false), 
    listItem.withDescription('Drink water','Drink a glass of water', 10, false),
    listItem.withDescription('Eat Dinner','Eat something in the evening', 10, false),
    listItem.withDescription('Brush Teeth','Brush your teeth in the evening', 10, false),
    listItem.withDescription('Take a Shower','Take a shower, get clean!', 20, false),
    ];
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
  if(healMonster){
    return Monster(0, 100, "dragon.jpg");
  }
  return Monster(100, 100, "dragon.jpg");
}

  List<listItem>? yourlist;
  Monster? yourMonster;
  getData() async{
    isLoaded2 = widget.isLoaded;
    yourlist = await _readFile(widget.listfilename, widget.listname);
    yourMonster = await _readMonsterFile(widget.monsterfilename);
setState(() {
    isLoaded2=true;
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
        title:   Text(widget.listTitle),
        
      ),
      body: Visibility(
        visible: isLoaded2,
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
                    value: yourlist![index].getDone(),
                    onChanged: (bool? value) {
                      yourlist![index].done = value!;
                      String yourlistjson = "{\"${widget.listname}\":[";
                      for (int i =0; i < yourlist!.length; i++){
                        yourlistjson += yourlist![i].toJson().toString();
                        if(i!=yourlist!.length-1){
                          yourlistjson +=",";
                        }
                      }
                      yourlistjson+= "]}";
                      _writeFile(yourlistjson, widget.listfilename);
                      setState(() {
                        yourlist![index].done = value;
                        if(healMonster){
                          if(value){
                            yourMonster?.setCurrentHealth(((yourMonster!.getCurrentHealth()+ yourlist![index].weight)));
                          }else{
                            yourMonster?.setCurrentHealth(((yourMonster!.getCurrentHealth()- yourlist![index].weight)));
                          }
                          if(yourMonster!.getCurrentHealth() >= yourMonster!.getHealth()){
                            yourMonster?.setImageName("healedDragon.jpg");
                          }else{
                            yourMonster?.setImageName("dragon.jpg");
                          }
                        }
                        else{
                          if(value){
                            yourMonster?.setCurrentHealth(((yourMonster!.getCurrentHealth()- yourlist![index].weight)));
                          }else{
                            yourMonster?.setCurrentHealth(((yourMonster!.getCurrentHealth()+ yourlist![index].weight)));
                          }
                          if(yourMonster!.getCurrentHealth() <= 0){
                            yourMonster?.setImageName("defetedDragon.jpg");
                          }else{
                            yourMonster?.setImageName("dragon.jpg");
                          }
                        }
                      });
                      String yourdragonJson = "${yourMonster!.toJson()}";
                      _writeFile(yourdragonJson, widget.monsterfilename);
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
                    String yourlistjson = "{\"${widget.listname}\":[";
                    for (int i =0; i < yourlist!.length; i++){
                      yourlistjson += yourlist![i].toJson().toString();
                      if(i!=yourlist!.length-1){
                        yourlistjson +=",";
                      }
                    }
                    yourlistjson+= "]}";
                    _writeFile(yourlistjson, widget.listfilename);
                    setState(() {
                      isLoaded2=false;
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
              mainAxisAlignment: MainAxisAlignment.center,
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
                      if(healMonster){
                        yourMonster!.setCurrentHealth(0);
                      }else{
                        yourMonster!.setCurrentHealth(yourMonster!.getHealth());
                      }
                    });
                    String yourdragonJson = "${yourMonster!.toJson()}";
                    _writeFile(yourdragonJson, widget.monsterfilename);
                  },
                  child: const Text("Reset Health")
                )
            ],
            ),
            Row(
              children:[
                Padding(padding: const EdgeInsets.all(10),
                child: FloatingActionButton(onPressed: () async {
                listItem newlistItem = await showEditScreen("New quest","a quest to help defeat the dragon", 5);
                yourlist?.add(newlistItem);
                String yourlistjson = "{\"${widget.listname}\":[";
                for (int i =0; i < yourlist!.length; i++){
                  yourlistjson += yourlist![i].toJson().toString();
                  if(i!=yourlist!.length-1){
                    yourlistjson +=",";
                  }
                }
                yourlistjson+= "]}";
                _writeFile(yourlistjson, widget.listfilename);
                setState(() {
                  isLoaded2=false;
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
                  String yourlistjson = "{\"${widget.listname}\":[";
                for (int j = 0; j < yourlist!.length; j++){
                  yourlistjson += yourlist![j].toJson().toString();
                  if(j!=yourlist!.length-1){
                    yourlistjson +=",";
                  }
                }
                yourlistjson+= "]}";
                _writeFile(yourlistjson, widget.listfilename);
                setState(() {
                  isLoaded2=false;
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