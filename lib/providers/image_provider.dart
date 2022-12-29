import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ImageLink {
  final String? imageUrl;

  ImageLink({
    required this.imageUrl,
  });
}

class ImageItem {
  final String? id;
  final String? codret;
  final String? msgret;
  final List<ImageLink>? image;

  ImageItem({
    required this.id,
    required this.codret,
    required this.msgret,
    required this.image,
  });
}

class ImageProviderAPI with ChangeNotifier {
  List<ImageItem> _imageItem = [];

  List<ImageItem> get imageItem {
    return [..._imageItem];
  }

  Future<void> RetornaPopUpTeste(String vPalavraChave) async {
    try {
      const String user = 'CANDIDATO';
      const String password = 'DEV_TESTE@587';
      String basicAuth =
          'Basic ' + base64.encode(utf8.encode('$user:$password'));
      final url = Uri.parse(
          'http://mtb.no-ip.org:5190/mtb/v0100/api/RetornaPopUpTeste/$vPalavraChave');

      final response = await http.get(
        url,
        headers: {
          'Authorization': basicAuth,
        },
      );

      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }

      var msgretError;
      final List<ImageItem> loadedImage = [];
      extractedData.forEach(
        (imageID, imageData) {
          msgretError = imageData['msgret'].toString();
          loadedImage.add(
            ImageItem(
              id: imageID,
              codret: imageData['codret'],
              msgret: imageData['msgret'],
              image: (imageData['retornapopupteste'] as List<dynamic>)
                  .map(
                    (image) => ImageLink(
                      imageUrl: image['POPUP'],
                    ),
                  )
                  .toList(),
            ),
          );
        },
      );

      if (response.statusCode != 200) {
        print('ERROR msgret => $msgretError');
      }

      _imageItem = loadedImage.toList();
      notifyListeners();
    } catch (error) {
      print('ERRO => $error');
    }
  }
}
