import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CategoryCardShimmer extends StatelessWidget {
  const CategoryCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return SizedBox(
      height: med.height*0.15,
      width: med.width*0.26,
      child: Shimmer.fromColors(
        baseColor: CustomAppTheme().lightGreyColor,
        highlightColor: CustomAppTheme().backgroundColor,
        child: Container(
          height: med.height*0.15,
          width: med.width*0.26,
          decoration: BoxDecoration(
            color: CustomAppTheme().lightGreyColor,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
