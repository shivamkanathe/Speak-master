import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:communicate/Screens/home_screen.dart';
import 'package:communicate/helperfunction.dart/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserFormScreen extends StatefulWidget {
  const UserFormScreen({super.key});

  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  bool _isLoading = false;

  // Future<void> _submitForm() async {
  //   if (!_formKey.currentState!.validate()) return;

  //   setState(() {
  //     _isLoading = true;
  //   });

  //   String name = _nameController.text.trim();
  //   String email = _emailController.text.trim();
  //   String phone = _phoneController.text.trim();

  //   try {
  //     // Save to Firestore
  //     await FirebaseFirestore.instance.collection('users').add({
  //       'name': name,
  //       'email': email,
  //       'phone': phone,
  //       'createdAt': Timestamp.now(),
  //     });

  //     // Save to SharedPreferences
  //     SharedPreferences prefs = await SharedPreferences.getInstance();
  //     await prefs.setString('name', name);
  //     await prefs.setString('email', email);
  //     await prefs.setString('phone', phone);

  //     if (mounted) {
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (_) => HomeScreen(name: name)),
  //       );
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Error: ${e.toString()}')),
  //     );
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isLoading = false;
  //       });
  //     }
  //   }
  // }


  Future<void> _submitForm() async {
  if (!_formKey.currentState!.validate()) return;

  setState(() {
    _isLoading = true;
  });

  String name = _nameController.text.trim();
  String email = _emailController.text.trim();
  String phone = _phoneController.text.trim();

  try {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: email)
        .get();

    // Only save to Firestore if email does not exist
    if (querySnapshot.docs.isEmpty) {
      await FirebaseFirestore.instance.collection('users').add({
        'name': name,
        'email': email,
        'phone': phone,
        'createdAt': Timestamp.now(),
      });
    } else {
      debugPrint("Email already exists, skipping Firestore write.");
    }

    // Save to SharedPreferences regardless
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('name', name);
    await prefs.setString('email', email);
    await prefs.setString('phone', phone);

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => HomeScreen(name: name)),
      );
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: ${e.toString()}')),
    );
  } finally {
    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // title: const Text('Enter Your Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
             Image.asset("assets/speak_master.png",height: 150,width: 200,),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: Colors.white,fontSize: 14),
                  prefixIcon: Icon(Icons.person,color: Colors.white,),
                  filled: true,
                  fillColor: AppColors.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7)
                  ),
                  
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter name' : null,
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration:  InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email,color: Colors.white,),
                  labelStyle: TextStyle(color: Colors.white,fontSize: 14),
                
                  filled: true,
                  fillColor: AppColors.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7)
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Enter email';
                  }
                  final emailRegex = RegExp(r'\S+@\S+\.\S+');
                  if (!emailRegex.hasMatch(value)) {
                    return 'Enter valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _phoneController,
                decoration:  InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone,color: Colors.white,),
                  labelStyle: TextStyle(color: Colors.white,fontSize: 14),
                  filled: true,
                  fillColor: AppColors.cardColor,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(7)
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter phone number' : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _isLoading ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
