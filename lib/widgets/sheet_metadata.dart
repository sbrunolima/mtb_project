import 'package:flutter/material.dart';

class SheetMetadata extends StatefulWidget {
  final String image;

  SheetMetadata({required this.image});

  @override
  State<SheetMetadata> createState() => _SheetMetadataState();
}

class _SheetMetadataState extends State<SheetMetadata> {
  //Se WIDGET.IMAGE for null, aparece essa imagem no lugar
  final emptyImagePath = 'images/no_image.png';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(4.0)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4.0),
              child: Card(
                elevation: 0,
                child: widget.image.isEmpty
                    ? Image.asset(
                        emptyImagePath,
                        height: 350,
                        width: 350,
                        fit: BoxFit.contain,
                      )
                    : Image.asset(
                        widget.image,
                        height: 350,
                        width: 350,
                        fit: BoxFit.contain,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
