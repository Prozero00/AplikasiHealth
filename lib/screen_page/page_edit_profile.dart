import 'dart:async';
import 'package:aplikasi_health/model/model_edit_profile.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class PageEditProfile extends StatefulWidget {
  final Function(String, String, String, String)
      onProfileUpdate; //callback func
  const PageEditProfile({Key? key, required this.onProfileUpdate})
      : super(key: key);

  @override
  _PageEditProfileState createState() => _PageEditProfileState();
}

class _PageEditProfileState extends State<PageEditProfile> {
  TextEditingController txtFullName = TextEditingController();
  TextEditingController txtUsername = TextEditingController();
  TextEditingController txtEmail = TextEditingController();
  TextEditingController txtPassword = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  String? id;

  bool isLoading = false;
  bool isPasswordVisible = false;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  Future<ModelEditProfile?> editProfile() async {
    try {
      bool confirmAction = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Confirmation'),
            content: Text('Are you sure you want to save changes?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context, false);
                },
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                },
                child: Text('Save'),
              ),
            ],
          );
        },
      );

      if (confirmAction == true) {
        setState(() {
          isLoading = true;
        });

        http.Response res = await http.post(
          Uri.parse('http://localhost/aplikasihealth/edit_profile.php'),
          body: {
            "id": id,
            "username": txtUsername.text,
            "password": txtPassword.text,
            "fullname": txtFullName.text,
            "email": txtEmail.text,
          },
        );

        ModelEditProfile data = modelEditProfileFromJson(res.body);
        if (data.value == 1) {
          widget.onProfileUpdate(
            txtUsername.text,
            txtFullName.text,
            txtEmail.text,
            txtPassword.text,
          );
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(data.message)));

            Navigator.pop(context);
          });
        } else {
          setState(() {
            isLoading = false;
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(data.message)));
          });
        }
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Error: $e')));
      });
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Edit Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                controller: txtFullName,
                decoration: InputDecoration(
                  labelText: 'Fullname',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      txtFullName.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtUsername,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      txtUsername.clear();
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your username';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtEmail,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      txtEmail.clear();
                    },
                    icon: Icon(Icons.clear),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: txtPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.auto,
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        isPasswordVisible = !isPasswordVisible;
                      });
                    },
                    icon: Icon(isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                  ),
                ),
                obscureText: !isPasswordVisible,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : () {
                  if (_formKey.currentState!.validate()) { // Validate form
                    editProfile();
                  }
                },
                // style: ElevatedButton.styleFrom(
                //   backgroundColor: Colors.teal.shade400, // Set the background color to green
                //   padding: EdgeInsets.symmetric(vertical: 15), // Adjust padding as needed
                // ),
                child: SizedBox(
                  width: double.infinity, // Set button width to match its parent container
                  child: Center( // Center the text
                    child: isLoading
                        ? const CircularProgressIndicator() // Loading indicator
                        : const Text('Save'),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
