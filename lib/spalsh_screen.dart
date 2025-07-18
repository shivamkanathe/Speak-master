import 'package:communicate/Screens/home_screen.dart';
import 'package:communicate/Screens/login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
      _checkUser()
      // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context)=> UserFormScreen()) , (Route<dynamic> route) => false,)
    });
  }

  String? userName;


  Future<void> _checkUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    await Future.delayed(const Duration(seconds: 2)); // Just for splash effect
    if (name != null && name.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(name: name)),    
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const UserFormScreen()),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: Image.asset("assets/speak_master.png")),);
  }
}