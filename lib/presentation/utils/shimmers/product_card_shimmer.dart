import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductCardShimmer extends StatelessWidget {
  const ProductCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return SizedBox(
      height: med.height * 0.32,
      width: med.width * 0.45,
      child: Shimmer.fromColors(
        baseColor: CustomAppTheme().lightGreyColor,
        highlightColor: CustomAppTheme().backgroundColor,
        child: Container(
          height: med.height * 0.32,
          width: med.width * 0.45,
          decoration: BoxDecoration(
            color: CustomAppTheme().lightGreyColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}
