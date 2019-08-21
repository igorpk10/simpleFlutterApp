import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:simple/services/ShareImages.dart';
import 'package:simple/ui/gif_page.dart';
import 'package:transparent_image/transparent_image.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search;
  int _offset = 0;

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search == "") {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=IWH0uy2d05hog0NnVguqM7X5M2PBz02R&limit=25&rating=G");
    } else {
      response = await http.get(
          "https://api.giphy.com/v1/gifs/search?api_key=IWH0uy2d05hog0NnVguqM7X5M2PBz02R&q=$_search&limit=19&offset=$_offset&rating=G&lang=en");
    }
    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHome(),
      body: bodyHome(),
    );
  }

//region Widgets
  Widget appBarHome() {
    return AppBar(
      backgroundColor: Colors.black,
      title: Image.network(
          "https://developers.giphy.com/branch/master/static/header-logo-8974b8ae658f704a5b48a2d039b8ad93.gif"),
      centerTitle: true,
    );
  }

  Widget bodyHome() {
    return Column(
      children: <Widget>[inputTextTop(), gifsList()],
    );
  }

  Widget inputTextTop() {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: TextField(
        decoration: InputDecoration(
            labelText: "Pesquise aqui:",
            labelStyle: TextStyle(color: Colors.black87),
            border: OutlineInputBorder()),
        style: TextStyle(color: Colors.black87, fontSize: 18.0),
        textAlign: TextAlign.left,
        onSubmitted: (text) {
          setState(() {
            _search = text;
            _offset = 0;
          });
        },
      ),
    );
  }

  Widget gifsList() {
    return Expanded(
      child: FutureBuilder(
        future: _getGifs(),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.none:
              return loadingContainer();

            default:
              if (snapshot.hasError)
                return errorContainer();
              else
                return listContainer(context, snapshot);
          }
        },
      ),
    );
  }

  Widget loadingContainer() {
    return Container(
      width: 200.0,
      height: 200.0,
      alignment: Alignment.center,
      child: CircularProgressIndicator(
        valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
        strokeWidth: 5.0,
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget listContainer(context, AsyncSnapshot snapshot) {
    return GridView.builder(
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
      ),
      itemCount: _getCount(snapshot.data["data"]),
      itemBuilder: (context, index) {
        if (_search == null || index < snapshot.data["data"].length) {
          return GestureDetector(
            child:FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image:  snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover
            ),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Gif(snapshot.data["data"][index])));
            },
            onLongPress: () {
               ShareImages.onImageShared(snapshot.data["data"][index]);
            },
          );
        } else {
          return _buttonMoreGifs();
        }
      },
    );
  }

  Widget _buttonMoreGifs() {
    return Container(
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add, color: Colors.lightBlue, size: 70.0)
          ],
        ),
        onTap: () {
          setState(() {
            _offset += 19;
          });
        },
      ),
    );
  }

  Widget errorContainer() {
    return Container();
  }
  //endregion
}
