import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_health/main.dart';
import 'package:aplikasi_health/model/model_login.dart';
import 'package:aplikasi_health/screen_page/page_register.dart';
import 'package:aplikasi_health/utils/check_session.dart';


class PageLogin extends StatefulWidget {
  const PageLogin({Key? key}) : super(key: key);

  @override
  State<PageLogin> createState() => _PageLoginState();
}

class _PageLoginState extends State<PageLogin> {
  TextEditingController username = TextEditingController();
  TextEditingController password = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(
        Uri.parse("http://localhost/kamusDb/login.php"),
        body: {
          "username": username.text,
          "password": password.text,
        },
      );
      ModelLogin data = modelLoginFromJson(res.body);

      if (data.value == 1) {
        setState(() {
          isLoading = false;
        });

        session.saveSession(
          data.value ?? 0,
          data.id ?? "",
          data.username ?? "",
        );

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageHome()),
              (route) => false,
        );
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${data.message}',
              textAlign: TextAlign.center,
            ),
          ),
        );
      }
      return data;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to Sign In, Username or Password is Invalid",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return null;
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
                Container(
                  decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: isLoading
                      ? const Center(
                    child: CircularProgressIndicator(),
                  )
                      : MaterialButton(
                    minWidth: 150,
                    elevation: 3,
                    height: 45,
                    color: Colors.white,
                    onPressed: () {
                      if (keyForm.currentState?.validate() == true) {
                        loginAccount();
                      }
                    },
                    child: const Text(
                      "SIGN IN",
                      style: TextStyle(
                        color: Colors.purple,
                        fontWeight: FontWeight.bold,
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
                          builder: (context) => PageRegistrasi(),
                        ),
                      );
                    },
                    child: Text(
                      "Don't have an account? Sign Up here",
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
