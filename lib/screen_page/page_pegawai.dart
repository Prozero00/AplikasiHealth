import 'package:aplikasi_health/model/model_create_pegawai.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

import '../model/model_pegawai.dart';

class PageListPegawai extends StatefulWidget {
  const PageListPegawai({super.key});

  @override
  State<PageListPegawai> createState() => _PageListPegawaiState();
}

//Page Pegawai
class _PageListPegawaiState extends State<PageListPegawai> {
  bool isLoading = true;
  List<Datum> listPegawai = [];
  TextEditingController txtCari = TextEditingController();

  Future<List<Datum>> getPegawai() async {
    try {
      http.Response response = await http
          .get(Uri.parse('http://localhost/aplikasihealth/getPegawai.php'));
      return modelPegawaiFromJson(response.body).data;
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return []; // Return an empty list in case of an error
    }
  }

  Future deletePegawai(String id) async {
    try {
      http.Response response = await http.post(
          Uri.parse('http://localhost/aplikasihealth/deletePegawai.php'),
          body: {
            "id": id,
          });
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      isLoading = false;
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // Do in background
  @override
  void initState() {
    super.initState();
    getPegawai().then((pegawais) {
      setState(() {
        listPegawai = pegawais;
        isLoading = false;
      });
    });
  }

  bool isCari = true;
  List<Datum> filterPegawai = [];

  _PageListPegawaiState() {
    txtCari.addListener(() {
      if (txtCari.text.isEmpty) {
        setState(() {
          isCari = true;
          txtCari.text = "";
        });
      } else {
        setState(() {
          isCari = false;
          txtCari.text != "";
        });
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.blue,
          title: Text("List Data User",
              style: GoogleFonts.merriweather(
                  textStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              )))),
      body: Container(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            TextField(
              controller: txtCari,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: const BorderSide(color: Colors.lightBlue)),
              ),
            ),
            isCari
                ? Expanded(
                    child: ListView.builder(
                      itemCount: listPegawai.length,
                      itemBuilder: (context, index) {
                        Datum data = listPegawai[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => PageDetailPegawai(data)),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6),
                            child: Card(
                              child: ListTile(
                                title: Text(
                                  '${data.nama}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (_) =>
                                                  PageUpdatePegawai(data)),
                                        );
                                      },
                                      icon: Icon(Icons.edit),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                          barrierDismissible: false,
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            content: Text('Hapus data ?',
                                            style: GoogleFonts.merriweather(
                                              textStyle: const TextStyle(
                                                  color: Colors.black,
                                              ))),
                                            actions: [
                                              ElevatedButton(
                                                onPressed: () {
                                                  deletePegawai(data.id)
                                                      .then((value) {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: ((context) =>
                                                              PageListPegawai())),
                                                      (route) => false,
                                                    );
                                                  });
                                                },
                                                child: Text('Hapus'),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                                child: Text('Batal'),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      icon: Icon(Icons.delete),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  )
                : CreateFilterList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text(
          '+',
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
        backgroundColor: Colors.blueAccent,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PageInsertPegawai()),
          );
        },
      ),
    );
  }

  Widget CreateFilterList() {
    filterPegawai = listPegawai
        .where((pegawai) =>
            pegawai.nama.toLowerCase().contains(txtCari.text.toLowerCase()))
        .toList();
    return HasilSearch(filterPegawai);
  }

  Widget HasilSearch(List<Datum> filteredList) {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredList.length,
        itemBuilder: (context, index) {
          Datum data = filteredList[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => PageDetailPegawai(data)),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Card(
                child: ListTile(
                  title: Text(
                    '${data.nama}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Colors.black,
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => PageUpdatePegawai(data)),
                          );
                        },
                        icon: Icon(Icons.edit),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) => AlertDialog(
                              content: Text('Hapus data ?'),
                              actions: [
                                ElevatedButton(
                                  onPressed: () {
                                    deletePegawai(data.id).then((value) {
                                      Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: ((context) =>
                                                PageListPegawai())),
                                        (route) => false,
                                      );
                                    });
                                  },
                                  child: Text('Hapus'),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Batal'),
                                ),
                              ],
                            ),
                          );
                        },
                        icon: Icon(Icons.delete),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

//Page Insert Pegawai
class PageInsertPegawai extends StatefulWidget {
  const PageInsertPegawai({Key? key}) : super(key: key);

  @override
  State<PageInsertPegawai> createState() => _PageInsertPegawaiState();
}

class _PageInsertPegawaiState extends State<PageInsertPegawai> {
  TextEditingController nama = TextEditingController();
  TextEditingController no_bp = TextEditingController();
  TextEditingController no_hp = TextEditingController();
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future<ModelCreatePegawai?> createPegawai() async {
    try {
      http.Response res = await http.post(
        Uri.parse("http://localhost/aplikasihealth/createPegawai.php"),
        body: {
          "nama": nama.text,
          "no_bp": no_bp.text,
          "no_hp": no_hp.text,
          "email": email.text,
        },
      );
      ModelCreatePegawai data = modelCreatePegawaiFromJson(res.body);

      if (data.value == 1) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => PageListPegawai()),
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
      return data;
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Gagal menambahkan pegawai",
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
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Tambah Pegawai',
            style: GoogleFonts.merriweather(
                textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ))),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: nama,
                validator: (val) =>
                    val!.isEmpty ? "Nama tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "NAMA",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: no_bp,
                validator: (val) =>
                    val!.isEmpty ? "Nomor BP tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "NO BP",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: no_hp,
                validator: (val) =>
                    val!.isEmpty ? "Nomor HP tidak boleh kosong" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "NO HP",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: email,
                validator: (val) =>
                    val!.isEmpty ? "Email can't be empty" : null,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "EMAIL",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : MaterialButton(
                        minWidth: 150,
                        height: 45,
                        color: Colors.white,
                        onPressed: () {
                          if (keyForm.currentState!.validate()) {
                            createPegawai();
                          }
                        },
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Page Detail Pegawai
class PageDetailPegawai extends StatelessWidget {
  final Datum? data;

  const PageDetailPegawai(this.data, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail User',
            style: GoogleFonts.merriweather(
                textStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ))),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Berikut ini adalah detail Pegawai: ",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nama : ${data?.nama}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Nomor BP : ${data?.noBp}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Nomor HP : ${data?.noHp}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Email : ${data?.email}',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
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

// Page Update Pegawai
class PageUpdatePegawai extends StatefulWidget {
  final Datum data;

  const PageUpdatePegawai(this.data, {super.key});

  @override
  State<PageUpdatePegawai> createState() => _PageUpdatePegawaiState();
}

class _PageUpdatePegawaiState extends State<PageUpdatePegawai> {
  TextEditingController id = TextEditingController();
  TextEditingController nama = TextEditingController();
  TextEditingController no_bp = TextEditingController();
  TextEditingController no_hp = TextEditingController();
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();

  bool isLoading = false;

  Future updatePegawai() async {
    final res = await http.post(
      Uri.parse("http://localhost/aplikasihealth/updatePegawai.php"),
      body: {
        "id": id.text, // Pass the id of the employee to update
        "nama": nama.text,
        "no_bp": no_bp.text,
        "no_hp": no_hp.text,
        "email": email.text,
      },
    );

    if (res.statusCode == 200) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    id.text = widget.data.id;
    nama.text = widget.data.nama;
    no_bp.text = widget.data.noBp;
    no_hp.text = widget.data.noHp;
    email.text = widget.data.email;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text('Update Pegawai',
        style: GoogleFonts.merriweather(
        textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
    ))
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Form(
          key: keyForm,
          child: Column(
            children: [
              TextFormField(
                controller: nama,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "Nama",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: no_bp,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "NO BP",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: no_hp,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "NO HP",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 8),
              TextFormField(
                controller: email,
                style: TextStyle(color: Colors.black.withOpacity(0.8)),
                decoration: InputDecoration(
                  hintText: "EMAIL",
                  hintStyle: TextStyle(color: Colors.black.withOpacity(0.8)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.3),
                ),
              ),
              SizedBox(height: 25),
              Center(
                child: isLoading
                    ? CircularProgressIndicator()
                    : MaterialButton(
                        minWidth: 150,
                        height: 45,
                        color: Colors.white,
                        onPressed: () {
                          if (keyForm.currentState!.validate()) {
                            updatePegawai();
                          }
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => PageListPegawai()),
                              (route) => false);
                        },
                        child: Text(
                          "SIMPAN",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
