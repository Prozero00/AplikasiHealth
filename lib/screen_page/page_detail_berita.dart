import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_health/model/model_berita.dart';

class PageDetailBerita extends StatelessWidget {
  final Datum? data;

  const PageDetailBerita(this.data, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: Text(data!.judul),
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  'http://localhost/aplikasihealth/gambar_berita/${data?.gambarBerita}',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          ListTile(
            title: Text(
              data?.judul ?? "",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            subtitle: Text(
              DateFormat('MMM d, yyyy').format(data?.tglBerita ?? DateTime.now()),
              style: TextStyle(color: Colors.grey),
            ),
            trailing: Icon(
              Icons.star,
              color: Colors.orange,
            ),
          ),
          Divider(),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              data?.isiBerita ?? "",
              style: TextStyle(fontSize: 14),
            ),
          )
        ],
      ),
    );
  }
}