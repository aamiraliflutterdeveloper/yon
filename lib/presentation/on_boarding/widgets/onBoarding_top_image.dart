import 'package:flutter/material.dart';


class OnBoardingTopImage extends StatelessWidget {
  final String imageUrl;
  const OnBoardingTopImage({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Container(
      height: med.height * 0.2,
      width: med.width,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
