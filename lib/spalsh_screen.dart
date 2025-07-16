import 'package:communicate/Screens/home_screen.dart';
import 'package:flutter/material.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(Duration(seconds: 2),()=>{
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> HomeScreen()) , (Route<dynamic> route) => false,)
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset("assets/speak_master.png")),);
  }
}