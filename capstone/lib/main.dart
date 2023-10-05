import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(title:'DiceyProductivity',home:MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Home',
      theme: ThemeData(

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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
_counter++;
    });
  }

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
                    onPressed: _incrementCounter,
                    extendedPadding: EdgeInsets.all(10),
                    
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
                FloatingActionButton.extended(
                  onPressed: _incrementCounter,
                  extendedPadding: EdgeInsets.all(10),
                  
                  tooltip: 'opens your list',
                  label: const Text("Your list"),
                ),
              ]
            ),
            Row(
              
              mainAxisAlignment: MainAxisAlignment.center,
              
              children: <Widget>[
                FloatingActionButton.extended(
                  onPressed: _incrementCounter,
                  tooltip: 'opens self care list',
                  label: const Text("Self Care"),
                ),
              ]
            ),
            
            FloatingActionButton(
              onPressed: _incrementCounter,
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
