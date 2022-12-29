import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'dart:io';

//Widgets
import '../widgets/sheet_metadata.dart';
import '../widgets/my_app_bar.dart';

//Providers
import '../providers/image_provider.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Armazena o caminho que o arquivo será salvo
  final _filePath = 'assets/LOGO.jpg';
  //Null se o caminho da imagem não existir
  var _imagePath = '';

  @override
  void initState() {
    super.initState();

    //Acessa o ImageProviderAPI usando o Provider Package e amazena em imageProvider
    final imageProvider = Provider.of<ImageProviderAPI>(context, listen: false);

    //Chama a função RetornaPopUpTeste e captura os dados da API da MTB
    Provider.of<ImageProviderAPI>(context, listen: false)
        .RetornaPopUpTeste('DEV FLUTTER')
        .then((_) async {
      //Armazena o Base64 ZIP retornado do Backend
      String base64Image =
          imageProvider.imageItem[0].image![0].imageUrl.toString();

      //Transforma a String em bytes
      final bytes = base64Decode(base64Image);

      //Decodifica o aqruivo ZIP
      final zipFile = ZipDecoder().decodeBytes(bytes);

      //Verifica se o arquivo já existe no projeto
      //Caso não, o extrai
      if (!await File(_filePath).exists()) {
        //Se o caminho existe, _imagePath deixa de ser null e carrega a imagem
        _imagePath = _filePath;

        //Extrai a imagem do ZIP e armazena ele na pasta ASSETS
        for (final image in zipFile) {
          final filename = image.name;
          if (image.isFile) {
            final data = image.content as List<int>;

            File('assets/' + filename)
              ..createSync(recursive: true)
              ..writeAsBytesSync(data);
          } else {
            Directory('assets/' + filename).create(recursive: true);
          }
        }
      } else {
        //Se o caminho existe, _imagePath deixa de ser null e carrega a imagem
        _imagePath = _filePath;

        //Caso sim, printa a mensage,
        print('Arquivo já existente.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //Cridos o MediaQuery e o SizedBox aqui pra que ele
    //não seja recriado sem necessidade durante a execução do app
    final sizeWidth = MediaQuery.of(context).size.width - 30;
    const sizedBox = SizedBox(height: 100);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: MyAppBar(image: _imagePath),
        elevation: 0,
      ),
      body: Center(
        child: SizedBox(
          height: 50,
          width: sizeWidth,
          child: ElevatedButton(
            onPressed: () {
              //Usado showModalBottomSheet por ser mais apresentavel
              showModalBottomSheet(
                enableDrag: false,
                isDismissible: false,
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
                context: context,
                builder: (context) => DraggableScrollableSheet(
                  initialChildSize: 1,
                  builder: (_, controller) => Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(10.0),
                      ),
                    ),
                    //Usado ListView pra evitar Bottom Overflow
                    child: ListView(
                      children: [
                        sizedBox,
                        SheetMetadata(image: _imagePath),
                        sizedBox,
                        SizedBox(
                          height: 50,
                          width: sizeWidth,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: Text(
                                'Close',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium!
                                    .copyWith(
                                      color: Colors.white,
                                      fontSize: 18,
                                    ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            child: Text(
              'Press',
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: Colors.white,
                    fontSize: 18,
                  ),
            ),
          ),
        ),
      ),
    );
  }
}
