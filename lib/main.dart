import 'package:aplikasi_health/screen_page/page_login.dart';
import 'package:aplikasi_health/screen_page/page_pegawai.dart';
import 'package:aplikasi_health/screen_page/page_profile.dart';
import 'package:flutter/material.dart';
import 'package:aplikasi_health/screen_page/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        primaryColor: Colors.blueAccent,
        secondaryHeaderColor: Colors.teal,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PageHome extends StatefulWidget {
  const PageHome({super.key});

  @override
  State<PageHome> createState() => _State();
}

class _State extends State<PageHome> with SingleTickerProviderStateMixin {
  late TabController tabController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: TabBarView(
          controller: tabController,
          children: const [PageTabView(), PageTabView(), PagePegawai(), PageProfile()],
        ),
        bottomNavigationBar: BottomAppBar(
          elevation: 8,
          color: Colors.white,
          child: SizedBox(
            height: kBottomNavigationBarHeight,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 0),
              child: TabBar(
                isScrollable: true,
                labelColor: Colors.teal,
                unselectedLabelColor: Colors.grey,
                controller: tabController,
                tabs: const [
                  Tab(
                    text: "Home",
                    icon: Icon(Icons.home_rounded),
                  ),
                  Tab(
                    text: "Galeri",
                    icon: Icon(Icons.insert_photo_rounded),
                  ),
                  Tab(
                    text: "Pegawai",
                    icon: Icon(Icons.supervised_user_circle_rounded),
                  ),
                  Tab(
                    text: "Profil",
                    icon: Icon(Icons.person),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

}

class PageTabView extends StatelessWidget {
  const PageTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
        title: const Text('Page Registrasi'),
      ),
      body: const Center(
        child: Text('Ini adalah Page Tab Bar Setelah di Klik'),
      ),
    );
  }
}
