import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget {
  final String image;

  MyAppBar({required this.image});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4.0),
          child: image.isEmpty
              ? const Icon(
                  Icons.ac_unit_rounded,
                  color: Colors.white,
                  size: 30,
                )
              : Image.asset(
                  image,
                  scale: 16,
                ),
        ),
        const SizedBox(width: 10),
        const Text('APP'),
      ],
    );
  }
}
