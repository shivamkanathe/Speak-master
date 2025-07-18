import 'package:communicate/Screens/conversation_screen.dart';
import 'package:communicate/Screens/practice_screen.dart';
import 'package:communicate/Screens/translate_screen.dart';
import 'package:communicate/Screens/verb_screen.dart';
import 'package:communicate/helperfunction.dart/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

class HomeScreen extends StatefulWidget {

  String? name;
  HomeScreen({this.name});
  
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List items = [
    {"name": "Real Time Communication", "img": "assets/Conversation-pana.png", "id":"1"},
    {
      "name": "Practice Communication",
      "img": "assets/practice_communicate.png",
      "id":"2"
    },
    {"name": "Translate", "img": "assets/translate.png","id":"3"},
    
    {"name": "Verbs", "img": "assets/verb.png","id":"4"},
  ];

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("working this print here or not");
    welcomeSound();
  }

  final FlutterTts _flutterTts = FlutterTts();

  welcomeSound(){
    _flutterTts.setSpeechRate(0.4);
    _flutterTts.setLanguage("en-US");
    _flutterTts.speak("Welcome to the speak master, ${widget.name}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( 
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text("Welcome, ${widget.name}",style: Theme.of(context).textTheme.bodyLarge,),
      ),
      body: GridView.builder(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // Number of columns
          crossAxisSpacing: 12, // Horizontal space between items
          mainAxisSpacing: 12, // Vertical space between items
          childAspectRatio: 1, // Width/Height ratio of each item
        ),
        itemCount: items.length,
        itemBuilder: (context, index) { 
          return InkWell(
            onTap: (){
              if(items[index]['id'] == "1"){ 
              Navigator.push(context, MaterialPageRoute(builder: (context)=> ConversationScreen()));
              }
              else if(items[index]['id'] == "2"){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> PracticeScreen()));
              }
              else if(items[index]['id'] == "3"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> TranslatorScreen()));
              }
              else if(items[index]['id'] == "4"){
                Navigator.push(context, MaterialPageRoute(builder: (context)=> VerbsTableScreen()));
              }
            }, 
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5), // shadow color
                    spreadRadius: 0.5, // how much the shadow spreads
                    blurRadius: 0.5, // how soft the shadow is
                    offset: Offset(0, 1), // x and y offset
                  ),
                ],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("${items[index]['img']}", height: 80, width: 80),
                  Text(
                    items[index]['name'],
                    style: TextTheme.of(context).bodyLarge,
                    textAlign: TextAlign.center, 
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
