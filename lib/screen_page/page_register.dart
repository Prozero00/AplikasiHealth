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

  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> registerAccount() async {
    if (!keyForm.currentState!.validate()) {
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      http.Response res = await http.post(
        Uri.parse("http://localhost/kamusDb/register.php"),
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
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue, Colors.purple],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: keyForm,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  Icons.accessibility_new_rounded,
                  size: 130,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Health+",
                  style: GoogleFonts.merriweather(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: fullname,
                  validator: (val) =>
                  val!.isEmpty ? "Full name can't be empty" : null,
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  decoration: InputDecoration(
                    hintText: "FULLNAME",
                    hintStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: username,
                  validator: (val) =>
                  val!.isEmpty ? "Username can't be empty" : null,
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  decoration: InputDecoration(
                    hintText: "USERNAME",
                    hintStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: email,
                  validator: (val) =>
                  val!.isEmpty ? "Email can't be empty" : null,
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  decoration: InputDecoration(
                    hintText: "EMAIL",
                    hintStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  controller: password,
                  validator: (val) =>
                  val!.isEmpty ? "Password can't be empty" : null,
                  style: TextStyle(color: Colors.white.withOpacity(0.8)),
                  decoration: InputDecoration(
                    hintText: "PASSWORD",
                    hintStyle:
                    TextStyle(color: Colors.white.withOpacity(0.8)),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.3),
                  ),
                  obscureText: true,
                ),
                const SizedBox(
                  height: 25,
                ),
                Center(
                  child: isLoading
                      ? Center(
                    child: CircularProgressIndicator(),
                  )
                      : MaterialButton(
                    minWidth: 150,
                    height: 45,
                    color: Colors.white,
                    onPressed: () {
                      registerAccount();
                    },
                    child: Text(
                      "SIGN UP",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(width: 1, color: Colors.white30),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PageLogin(),
                        ),
                      );
                    },
                    child: Text(
                      "Already have an account? Sign In here",
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
