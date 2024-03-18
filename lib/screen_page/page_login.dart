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
  bool isPasswordVisible = false;

  Future<ModelLogin?> loginAccount() async {
    try {
      setState(() {
        isLoading = true;
      });
      http.Response res = await http.post(
        Uri.parse("http://localhost/aplikasihealth/login.php"),
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
          data.fullname ?? "",
          data.email ?? "",
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
        const SnackBar(
          content: Text(
            "Failed to Sign In, Username or Password is Invalid",
            textAlign: TextAlign.center,
          ),
        ),
      );
      return null;
    }
  }

  //key form
  GlobalKey<FormState> keyform = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              Text(
                "Health+",
                style: GoogleFonts.merriweather(
                    textStyle: const TextStyle(
                        color: Colors.blueAccent,
                        fontWeight: FontWeight.bold,
                        fontSize: 70
                    )
                ),
              ),
              const SizedBox(height: 10),
              Form(
                key: keyform,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  children: [
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
                        suffixIcon: IconButton(
                          onPressed: () {
                            username.clear();
                          },
                          icon: const Icon(Icons.clear),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: password,
                      validator: (val) {
                        return val!.isEmpty ? "Password is required" : null;
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
                    const SizedBox(height: 16),
                    SizedBox( // Wrap the ElevatedButton with SizedBox
                      width: double.infinity, // Set width to match the width of the form fields
                      child: ElevatedButton(
                        onPressed: () {
                          if (keyform.currentState!.validate()) {
                            loginAccount();
                          }
                        },
                        child: const Text('Login'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const PageRegistrasi()),
                  );
                },
                child: const Text('Don\'t have an account? Register here'),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
