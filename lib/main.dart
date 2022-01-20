import 'dart:convert';

import 'package:atacli/model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Atauni Yemek Listesi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

// async http response
Future<Menu> getData(String tarih) async {
  var url = Uri.parse('http://berkay.one/api/${tarih}');
  var response =
      await http.get(url, headers: {'Content-Type': 'application/json'});
  var menu = Menu.fromJson(json.decode(utf8.decode(response.bodyBytes)));

  return menu;
}

//MyHomePage
class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //icon
        leading: Padding(
          padding: const EdgeInsets.all(6.0),
          child: Image.network(
            "https://upload.wikimedia.org/wikipedia/tr/c/cc/Ataturkuni_logo.png",
          ),
        ),

        title: const Text('Ataüni Yemek Listesi'),
      ),
      //Future builder table
      body: const NextBuilder(tarih: "bugun"),
      //  onPressed return on new page FutureMenu("yarın");
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NewWidget()),
          );
        },
        label: const Text('Yarın'),
        icon: const Icon(Icons.today_rounded),
      ),
    );
  }
}

class NextBuilder extends StatelessWidget {
  const NextBuilder({
    Key? key,
    required this.tarih,
  }) : super(key: key);

  final String tarih;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Menu>(
      future: getData(tarih),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.menu.menuler.length + 1,
            itemBuilder: (context, index) {
              if (index == 0) {
                // Return date
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.all(15),
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.calendar_today),
                          title: Text(
                            'TARİH : ${snapshot.data!.menu.tarih}',
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                margin: const EdgeInsets.all(10),
                elevation: 10,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: const Icon(
                        Icons.food_bank_sharp,
                        size: 40,
                      ),
                      title: Text(snapshot.data!.menu.menuler[index - 1].name),
                      subtitle: Text("Gram : " +
                          snapshot.data!.menu.menuler[index - 1].gram),
                    ),
                  ],
                ),
              );
            },
          );
        } else if (snapshot.hasError) {
          return const Center(child: Text("Bir hata oluştu"));
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.data?.menu == null) {
          return const Center(child: Text("Bu tarihte veri yok"));
        }
        // By default, show a loading spinner.
        return const Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
          ),
        );
      },
    );
  }
}

class NewWidget extends StatelessWidget {
  const NewWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Yarının Yemek Listesi'),
      ),
      body: const NextBuilder(tarih: "yarin"),
    );
  }
}
