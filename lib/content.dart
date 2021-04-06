import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;



class ContentWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => ColorStateWidget();
}

class ColorStateWidget extends State<ContentWidget> {

  Future<List<ColorModel>> futureData;

  @override
  void initState() {
    super.initState();
    futureData = fetchAlbum();
  }

  Future<List<ColorModel>> fetchAlbum() async {
    final response = await http.get(Uri.https('jsonplaceholder.typicode.com', 'photos'));

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      final List<ColorModel> data = [];
      final List<dynamic> fetchData = jsonDecode(response.body);
      for (var i = 0; i < fetchData.length; i++) {
        final ColorModel model = ColorModel(
            title: fetchData[i]['title'],
            url: fetchData[i]['url']);
        data.add(model);
      }
      return data;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
          child: FutureBuilder<List<ColorModel>> (
            future: futureData,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return Center(
                    child: new GridView.builder(gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3, //每行三列
                        childAspectRatio: 1.0 //显示区域宽高相等
                    ),
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return
                            new Image.network(snapshot.data[index].url);
                        }
                    )
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              // By default, show a loading spinner.
              return CircularProgressIndicator();
            }
          )
        )
      );
    }
  }

class ColorModel {
  final String url;
  final String title;

  ColorModel({this.url, this.title});

  factory ColorModel.fromJson(Map<String, dynamic> json) {
    return ColorModel(
      url: json['url'],
      title: json['title'],
    );
  }
}



