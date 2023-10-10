
import 'dart:math';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:capstone/list_item.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title:'DiceyProductivity',home:MyApp()));
}
int rollDice( int largestNum){
  return Random().nextInt(largestNum);
}
_writeFile(String text, String filename) async {
  final Directory directory = await getApplicationDocumentsDirectory();
  final File file = File('C:\\A Neumont\\Year3\\Q1\\Capstone\\capstone\\lib\\files\\${filename}');
  await file.writeAsString(text);
}

Future<String> _readFile(String filename) async {
  String text ="";
  try {
    final Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('C:\\A Neumont\\Year3\\Q1\\Capstone\\capstone\\lib\\files\\${filename}');
    text = await file.readAsString();
  } catch (e) {
    print("Couldn't read file");
  }
  return text;
}
var font = 'OpenDyslexic';

class MyApp extends StatefulWidget {
  const MyApp({super.key});
@override
State<MyApp> createState()=> _MyApp();
}
class _MyApp extends State<MyApp>{
  // This widget is the root of your application.
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
    /*void changefont(){
      setState((){
        MaterialApp(
      title: 'Home',
      theme: ThemeData(
        fontFamily: font,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffCA9CE1)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Home'),
      );});
    }
    */
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
                  MaterialPageRoute(builder:(context) => Settings()),
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
                  child: Text("Your list"),
                  onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder:(context) => YourList()),
                  );
              },

                ),
              ]
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.all(10),
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
                  margin: EdgeInsets.all(10),
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

class YourList extends StatelessWidget{
  
  YourList({super.key});
  final yourlist = [listItem('title', 5)];
  
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your list"),
        
      ),
      body: Center(
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
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                      yourlist![index].title,
                      style: TextStyle(
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
          padding: EdgeInsets.all(10),
          child:
          FloatingActionButton(onPressed: (){
            String yourlistjson = "";
            for (int i =0; i < yourlist.length; i++){
              yourlistjson += yourlist[i].toJson().toString()+",";
            }
            _writeFile(yourlistjson, 'yourlist.txt');
            
          },
          heroTag: "addItem",
            child: const Icon(Icons.add),
          ) ,
        )
          
        
        ],) 
        
      ),
    );

  }
}

class SelfCareList extends StatelessWidget{

final selfcarelist = [listItem('title', 5), listItem("2", 5)];
//List<listItem> readFile(){

//}
    void addItem(String title, String description, int weight){
      selfcarelist.add(listItem.withDescription(title, description, weight));
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
          itemCount: selfcarelist?.length,
          itemBuilder: (context, index){
            return Container(
              child:
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children:[
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Text(
                      selfcarelist![index].title,
                      style: TextStyle(
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
          padding: EdgeInsets.all(10),
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
  State<Settings> createState()=> _stateSettings();
}
class _stateSettings extends State<Settings>{
  @override
  Widget build(BuildContext context){
    
    

    void onChanged(bool boolean){};
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
                if(boolean){
                font = 'OpenDyslexic';
                }else {font = 'Ariel';
                }
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
      body: Center(),
    );
  }
}

