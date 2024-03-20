import 'package:shared_preferences/shared_preferences.dart';

class SessionManager{
  int? value;
  String? idUser, username;

  Future<void> saveSession(int val, String id, String user) async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setInt("value", val);
    pref.setString("idUser", id);
    pref.setString("username", user);
  }

  Future getSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.getInt("value");
    pref.getString("idUser");
    pref.getString("username");
    return username;
  }

  Future clearSession() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.clear();
  }
}

SessionManager session = SessionManager();