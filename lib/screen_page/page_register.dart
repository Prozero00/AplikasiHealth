import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_health/screen_page/page_login.dart';

import '../model/model_register.dart';

class PageRegistrasi extends StatefulWidget {
  const PageRegistrasi({Key? key}) : super(key: key);

  @override
  State<PageRegistrasi> createState() => _PageRegistrasiState();
}

class _PageRegistrasiState extends State<PageRegistrasi> {
  TextEditingController fullname = TextEditingController();
  TextEditingController username = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  GlobalKey<FormState> keyform = GlobalKey<FormState>();
  bool isLoading = false;
  bool isPasswordVisible = false;

  Future<void> registerAccount() async {
    if (!keyform.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      http.Response res = await http.post(
        Uri.parse("http://localhost/aplikasihealth/register.php"),
        body: {
          "fullname": fullname.text,
          "username": username.text,
          "password": password.text,
          "email": email.text,
        },
      );

      ModelRegister data = modelRegisterFromJson(res.body);

      if (data.value == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${data.message}',
              textAlign: TextAlign.center,
            ),
          ),
        );
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageLogin()),
              (route) => false,
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${data.message}',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString(),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text('Register Form'),
      ),
      body: Form(
        key: keyform,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: fullname,
                  validator: (val) {
                    return val!.isEmpty ? "Full name is required" : null;
                  },
                  decoration: InputDecoration(
                    hintText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: username,
                  validator: (val) {
                    return val!.isEmpty ? "Username is required" : null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: email,
                  validator: (val) {
                    return val!.isEmpty ? "Email is Required" : null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: password,
                  validator: (val) {
                    return val!.isEmpty ? "Password is Required!" : null;
                  },
                  decoration: InputDecoration(
                    hintText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
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
                const SizedBox(
                  height: 16,
                ),
                ElevatedButton(
                  onPressed: () {
                    //cek kondisi & get data inputan
                    if (keyform.currentState?.validate() == true) {
                      //panggil func register
                      registerAccount();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    // backgroundColor: Colors.tealAccent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 30)),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text('Sign Up'),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => const PageLogin()),
                    );
                  },
                  child: const Text('Already have an account? Login here'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

}