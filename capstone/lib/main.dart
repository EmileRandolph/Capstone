import 'dart:convert';
import 'dart:io';
import 'package:capstone/listUI.dart';
import 'package:flutter/material.dart';
import 'package:capstone/settings.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;


Future<settings> _readSettingsFile(String filename)async {
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
  return settings.fromJson(decoded);
  }

  return settings(false, false, true, false, true);
}

Future<List<YourList>> _readListFile(String filename) async{
  try{
        final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File("$path/$filename");
      List<String> lines = file.readAsLinesSync();
      bool boolean = await file.exists();
  if(boolean){
    List<YourList>? list = List.empty(growable: true);for (var line in lines) {
      stdout.writeln(line);
      list.add(YourList(listfilename: "$line.txt", listname: line, monsterfilename: "monster$line.txt", listTitle: line, healMonster: setting.healMonster));
    } 
      return list;
  }
  }catch(e){
    print(e);
  }
  return  [
  YourList(listfilename: 'yourlist.txt', listname: 'yourlist', monsterfilename: 'yourmonster.txt', listTitle: 'Your List', healMonster: setting.healMonster,),
  YourList(listfilename: 'selfcare.txt', listname: 'selfcare', monsterfilename: 'selfcaremonster.txt', listTitle: 'Self Care',healMonster: setting.healMonster,)
  ];
}
Future<num> _getData()async{
    setting = await _readSettingsFile("settings.txt");
    lists = await _readListFile("lists.txt");
    return 0;
  }

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

/// Streams are created so that app can respond to notification-related events
/// since the plugin is initialised in the `main` function
final StreamController<ReceivedNotification> didReceiveLocalNotificationStream =
    StreamController<ReceivedNotification>.broadcast();

final StreamController<String?> selectNotificationStream =
    StreamController<String?>.broadcast();

const MethodChannel platform =
    MethodChannel('dexterx.dev/flutter_local_notifications_example');

const String portName = 'notification_send_port';
/// Defines a iOS/MacOS notification category for text input actions.
const String darwinNotificationCategoryText = 'textCategory';

/// Defines a iOS/MacOS notification category for plain actions.
const String darwinNotificationCategoryPlain = 'plainCategory';

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
        'notification action tapped with input: ${notificationResponse.input}');
  }
}

class ReceivedNotification {
  ReceivedNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.payload,
  });

  final int id;
  final String? title;
  final String? body;
  final String? payload;
}

int id = 0;
const String navigationActionId = 'id_3';
String? selectedNotificationPayload;

Future<void> _configureLocalTimeZone() async {
  if (kIsWeb || Platform.isLinux) {
    return;
  }
  tz.initializeTimeZones();
  final String timeZoneName = await FlutterTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName));
}


void main() async{
    // needed if you intend to initialize in the `main` function
  WidgetsFlutterBinding.ensureInitialized();

  await _configureLocalTimeZone();
await _getData();
  final NotificationAppLaunchDetails? notificationAppLaunchDetails = !kIsWeb &&
          Platform.isLinux
      ? null
      : await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();

  if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
    selectedNotificationPayload =
        notificationAppLaunchDetails!.notificationResponse?.payload;

  }

  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final List<DarwinNotificationCategory> darwinNotificationCategories =
      <DarwinNotificationCategory>[
    DarwinNotificationCategory(
      darwinNotificationCategoryText,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.text(
          'text_1',
          'Action 1',
          buttonTitle: 'Send',
          placeholder: 'Placeholder',
        ),
      ],
    ),
    DarwinNotificationCategory(
      darwinNotificationCategoryPlain,
      actions: <DarwinNotificationAction>[
        DarwinNotificationAction.plain('id_1', 'Action 1'),
        DarwinNotificationAction.plain(
          'id_2',
          'Action 2 (destructive)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.destructive,
          },
        ),
        DarwinNotificationAction.plain(
          navigationActionId,
          'Action 3 (foreground)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.foreground,
          },
        ),
        DarwinNotificationAction.plain(
          'id_4',
          'Action 4 (auth required)',
          options: <DarwinNotificationActionOption>{
            DarwinNotificationActionOption.authenticationRequired,
          },
        ),
      ],
      options: <DarwinNotificationCategoryOption>{
        DarwinNotificationCategoryOption.hiddenPreviewShowTitle,
      },
    )
  ];

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification:
        (int id, String? title, String? body, String? payload) async {
      didReceiveLocalNotificationStream.add(
        ReceivedNotification(
          id: id,
          title: title,
          body: body,
          payload: payload,
        ),
      );
    },
    notificationCategories: darwinNotificationCategories,
  );
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
    macOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse:
        (NotificationResponse notificationResponse) {
      switch (notificationResponse.notificationResponseType) {
        case NotificationResponseType.selectedNotification:
          selectNotificationStream.add(notificationResponse.payload);
          break;
        case NotificationResponseType.selectedNotificationAction:
          if (notificationResponse.actionId == navigationActionId) {
            selectNotificationStream.add(notificationResponse.payload);
          }
          break;
      }
    },
    onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
  );
  runApp(const MaterialApp(title:'DiceyProductivity',home:MyApp()));
}
var isLoaded = false;

  tz.TZDateTime _nextInstanceOfTenAM() {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, 10);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

var font = 'OpenDyslexic';

class MyApp extends StatefulWidget {
  const MyApp({super.key, this.notificationAppLaunchDetails});
  final NotificationAppLaunchDetails? notificationAppLaunchDetails;

  bool get didNotificationLaunchApp =>
      notificationAppLaunchDetails?.didNotificationLaunchApp ?? false;
@override
State<MyApp> createState()=> _MyApp();

}

class _MyApp extends State<MyApp>{
  // This widget is the root of your application.
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _isAndroidPermissionGranted();
    _requestPermissions();
    _configureDidReceiveLocalNotificationSubject();
    _configureSelectNotificationSubject();
  }

  Future<void> _isAndroidPermissionGranted() async {
    if (Platform.isAndroid) {
      final bool granted = await flutterLocalNotificationsPlugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.areNotificationsEnabled() ??
          false;

      setState(() {
        _notificationsEnabled = granted;
      });
    }
  }

  Future<void> _requestPermissions() async {
    if (Platform.isIOS || Platform.isMacOS) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              MacOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    } else if (Platform.isAndroid) {
      final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
          flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();

      final bool? grantedNotificationPermission =
          await androidImplementation?.requestNotificationsPermission();
      setState(() {
        _notificationsEnabled = grantedNotificationPermission ?? false;
      });
    }
  }

  void _configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationStream.stream
        .listen((ReceivedNotification receivedNotification) async {
      await showDialog(
        context: context,
        builder: (BuildContext context) => CupertinoAlertDialog(
          title: receivedNotification.title != null
              ? Text(receivedNotification.title!)
              : null,
          content: receivedNotification.body != null
              ? Text(receivedNotification.body!)
              : null,
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              onPressed: () async {
                Navigator.of(context, rootNavigator: true).pop();
                await Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) =>
                        const MyHomePage(title: 'Home'),
                  ),
                );
              },
              child: const Text('Ok'),
            )
          ],
        ),
      );
    });
  }

  void _configureSelectNotificationSubject() {
    selectNotificationStream.stream.listen((String? payload) async {
      await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (BuildContext context) => const MyHomePage(title: 'Home'),
      ));
    });
  }

  @override
  void dispose() {
    didReceiveLocalNotificationStream.close();
    selectNotificationStream.close();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
      Future<void> _scheduleDailyTenAMNotification() async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        'Have you done a quest today?',
        'Just a friendly reminder to get some work done if you can.',
        _nextInstanceOfTenAM(),
        const NotificationDetails(
          android: AndroidNotificationDetails('daily notification channel id',
              'DiceProductivity',
              channelDescription: 'reminder to do some quests'),
        ),
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time);
  }
  _scheduleDailyTenAMNotification();
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
List<YourList> lists = [
  YourList(listfilename: 'quests.txt', listname: 'quests', monsterfilename: 'questsmonster.txt', listTitle: 'Quests', healMonster: setting.healMonster,),
  YourList(listfilename: 'selfcare.txt', listname: 'selfcare', monsterfilename: 'selfcaremonster.txt', listTitle: 'Self Care',healMonster: setting.healMonster,)
  ];
class _MyHomePageState extends State<MyHomePage> {

_NewListPopUp() async {
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
            "Make a new List ",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
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
                      "Name of List",
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
                      onPressed: () async {
                        lists.add(YourList(listfilename: "${nameController.text}.txt", listname: nameController.text, monsterfilename: "monster${nameController.text}.txt", listTitle: nameController.text, healMonster: setting.healMonster));
                        String text = "";
                        for (YourList list in lists){
                          text += "${list.listname}\n";
                        }
                        await writeFile(text, "lists.txt");
                        lists = await _readListFile("lists.txt");
                        setState(() {
                        });
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
                        "Add List",
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

_DeleteListPopUp() async {
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
            "Make a new List ",
            style: TextStyle(fontSize: 24.0),
          ),
          content: SizedBox(
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
                      "Name of List",
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
                      onPressed: () async {
                        for(int i =0; i < lists.length; i++){
                          if(nameController.text==lists[i].listname){
                            final directory = await getApplicationDocumentsDirectory();
                            final path = directory.path;
                            final file = File("$path/${lists[i].listfilename}");
                            try{
                              await file.delete();
                            }catch(e){
                              print(e);
                            }
                            
                            lists.remove(lists[i]);
                          }
                        }
                        String text = "";
                        for (YourList list in lists){
                          text += "${list.listname}\n";
                        }
                        await writeFile(text, "lists.txt");
                        lists = await _readListFile("lists.txt");
                        setState(() {
                        });
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
                        "Remove List",
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
  Widget build(BuildContext context) {
    _getData();
    setState((){
    });
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
            Container(
              child:
            Expanded(child:
            ListView.builder(
              itemCount: lists.length,
              itemBuilder: (context, index){
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(
                      style: ButtonStyle(backgroundColor: MaterialStatePropertyAll<Color>(Theme.of(context).colorScheme.inversePrimary)),
                      child: Text(lists[index].listname),
                      onPressed: (){
                        isLoaded=false;
                        lists[index].healMonster=setting.healMonster;
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder:(context) =>  lists[index]),
                      );
                  },
                    ),
                  ]
                ),
                  ]
                );
              },
            ),
            ),

            ),
            Row(
              children: [
                Padding(padding: const EdgeInsetsDirectional.all(10),
                  child:FloatingActionButton(
                onPressed: () async {
                await _NewListPopUp();
                },
                heroTag: "AddList",
                tooltip: 'opens make new list screen',
                child: const Icon(Icons.add),
                ),
              ),
              Padding(padding: const EdgeInsetsDirectional.all(10),
                  child:FloatingActionButton(
                onPressed: () async {
                await _DeleteListPopUp();
                setState(() {
                  
                });
                },
                heroTag: "RemoveList",
                tooltip: 'opens delete a list screen',
                child: const Icon(Icons.remove),
                ),
              )
              ],
            )
            
              ],
            ),
            
          
        ),
      );
      
  }
}

settings setting = settings.empty();



class Settings extends StatefulWidget{
  const Settings({super.key});
  @override
  State<Settings> createState()=> _stateSettings();
}

// ignore: camel_case_types
class _stateSettings extends State<Settings>{


  @override
  Widget build(BuildContext context){
    
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
              Switch(value: setting.healMonster, onChanged: (bool boolean){
                if(boolean){}
                else{}
                setState(() {
                  setting.healMonster = boolean;
                });
                String settingsJson = "${setting.toJson()}";
                writeFile(settingsJson, "settings.txt");
              }),
              const Text(
                "Heal Monster",
                )
            ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: setting.openDyslexicfont, 
              onChanged: (bool boolean){
                setState((){
                  setting.openDyslexicfont = boolean;
                });
                String settingsJson = "${setting.toJson()}";
                writeFile(settingsJson, "settings.txt");
              }),
              const Text("OpenDyslexic font")
            ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: setting.halloweenMode, onChanged: (bool boolean){
                if(boolean){}
                else{}
                setState(() {
                  setting.halloweenMode = boolean;
                });
                String settingsJson = "${setting.toJson()}";
                writeFile(settingsJson, "settings.txt");
              }),
              const Text("Halloween mode")
            ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: setting.darkMode, onChanged: (bool boolean){
                if(boolean){}
                else{}
                setState(() {
                  setting.darkMode = boolean;
                });
                String settingsJson = "${setting.toJson()}";
                writeFile(settingsJson, "settings.txt");
                }),
              const Text("Dark mode")
            ],
            ),
            Row(mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Switch(value: setting.notification, onChanged: (bool boolean){
                if(boolean){}
                else{}
                setState(() {
                  setting.notification = boolean;
                });
                String settingsJson = "${setting.toJson()}";
                writeFile(settingsJson, "settings.txt");
                }),
              const Text("Notifications")
            ],
            ),
          ],
          ),
      ),
    );
    
  }
}

