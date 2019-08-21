import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';

class ShareImages {
  static void onImageShared(Map _gifData) async {
    var request = await HttpClient().getUrl(Uri.parse(_gifData['images']['fixed_height']['url']));
    var response = await request.close();
    Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    await Share.file(_gifData['title'], 'gifind.gif', bytes, 'image/gif');
  }
}
