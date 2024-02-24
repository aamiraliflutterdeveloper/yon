import 'package:flutter/material.dart';

class OnBoardingCenterImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  const OnBoardingCenterImage({Key? key, required this.imageUrl, this.width = 0.55}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Center(
      child: Container(
        height: med.height * 0.3,
        width: med.width*width!,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imageUrl),
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
