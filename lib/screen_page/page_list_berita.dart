// Make sure to import necessary dependencies
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aplikasi_health/model/model_berita.dart';
import 'package:aplikasi_health/screen_page/page_detail_berita.dart';

class PageListBerita extends StatefulWidget {
  const PageListBerita({Key? key}) : super(key: key);

  @override
  _PageListBeritaState createState() => _PageListBeritaState();
}

class _PageListBeritaState extends State<PageListBerita> {
  late Future<List<Datum>?> _beritaFuture;

  @override
  void initState() {
    super.initState();
    _beritaFuture = getBerita();
  }

  Future<List<Datum>?> getBerita() async {
    try {
      final response = await http.get(Uri.parse('http://localhost/aplikasihealth/getBerita.php'));
      if (response.statusCode == 200) {
        return modelBeritaFromJson(response.body).data;
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        backgroundColor: Colors.orange,
      ),
      body: FutureBuilder<List<Datum>?>(
        future: _beritaFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: Colors.orange));
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No data available'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                Datum data = snapshot.data![index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => PageDetailBerita(data)),
                    );
                  },
                  child: Card(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              'http://localhost/aplikasihealth/gambar_berita/${data.gambarBerita}',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                return Center(child: Text('Image not available'));
                              },
                            ),
                          ),
                        ),
                        ListTile(
                          title: Text(
                            data.judul ?? '',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            data.isiBerita ?? '',
                            maxLines: 2,
                            style: TextStyle(color: Colors.black54, fontSize: 12),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}