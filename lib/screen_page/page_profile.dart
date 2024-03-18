import 'package:aplikasi_health/screen_page/page_edit_profile.dart';
import 'package:aplikasi_health/screen_page/page_login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/check_session.dart';

class PageProfile extends StatefulWidget {
  const PageProfile({Key? key}) : super(key: key);

  @override
  State<PageProfile> createState() => _PageProfileState();
}

class _PageProfileState extends State<PageProfile> {
  String? id, fullname, username, email;

  Future getSession() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      id = pref.getString("id") ?? '';
      fullname = pref.getString("fullname") ?? '';
      username = pref.getString("username") ?? '';
      email = pref.getString("email") ?? '';
      // print('username $username');
      // print('fullname $fullname');
      // print('id $id');
      // print('$email');
    });
  }

  @override
  void initState() {
    super.initState();
    getSession();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            tooltip: 'Edit Profile',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PageEditProfile(
                    onProfileUpdate: (String newUsername, String newFullName, String newEmail, String newPassword) {
                      // Implement the logic to update the profile with the new data
                      setState(() {
                        username = newUsername;
                        fullname = newFullName;
                        email = newEmail;
                        // You may or may not want to update the password based on your application's requirements
                      });
                    },
                  ),
                ),
              );

            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: (){
                if (kDebugMode) {
                  print('LOL!');
                }
              },
             child: CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Text(
                  username?.isNotEmpty == true ? username![0].toUpperCase() : '?',
                  style: const TextStyle(fontSize: 36, color: Colors.blueAccent),
                ),
                // backgroundImage: AssetImage('images/user.png'),
              ),
            ),
          ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title:  Text('Fullname',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(fullname ?? ''),
                leading: const Icon(CupertinoIcons.person),
              ),
            ),
            Card(
              child: ListTile(
                title:  Text('Username',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(username ?? ''),
                leading: const Icon(CupertinoIcons.personalhotspot),
              ),
            ),
            Card(
              child: ListTile(
                title:  Text('ID',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(id ?? ''),
                leading: const Icon(CupertinoIcons.number_circle),
              ),
            ),
            Card(
                child: ListTile(
              title:  Text('Email',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(email ?? ''),
              leading: const Icon(CupertinoIcons.mail),
            )),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                session.clearSession();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const PageLogin()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.red,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

