import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class WideCardShimmer extends StatelessWidget {
  const WideCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return SizedBox(
      height: med.height * 0.08,
      width: med.width * 0.2,
      child: Shimmer.fromColors(
        baseColor: CustomAppTheme().lightGreyColor,
        highlightColor: CustomAppTheme().backgroundColor,
        child: Container(
          height: med.height * 0.08,
          width: med.width * 0.2,
          decoration: BoxDecoration(
            color: CustomAppTheme().lightGreyColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }
}