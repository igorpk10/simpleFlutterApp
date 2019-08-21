import 'package:flutter/material.dart';
import 'package:simple/services/ShareImages.dart';

class Gif extends StatelessWidget {
  final Map _gifData;

  Gif(this._gifData);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _appBar(), body: _body());
  }

  Widget _body() {
    return Center(
      child: Image.network(_gifData["images"]["fixed_height"]["url"]),
    );
  }

  Widget _appBar() {
    return AppBar(
      title: Text(_gifData["title"]),
      backgroundColor: Colors.black,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.share),
          onPressed: () {
            ShareImages.onImageShared(_gifData);
            // Share.share(_gifData["images"]["fixed_height"]["url"]);
          },
        ),
      ],
    );
  }
}
