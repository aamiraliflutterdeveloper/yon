import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class MessageCardShimmer extends StatelessWidget {
  const MessageCardShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          Shimmer.fromColors(
            baseColor: CustomAppTheme().lightGreyColor,
            highlightColor: CustomAppTheme().backgroundColor,
            child: Container(
              height: med.height * 0.06,
              width: med.width * 0.12,
              decoration: BoxDecoration(
                color: CustomAppTheme().lightGreyColor,
                shape: BoxShape.circle,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Shimmer.fromColors(
                  baseColor: CustomAppTheme().lightGreyColor,
                  highlightColor: CustomAppTheme().backgroundColor,
                  child: Container(
                    height: med.height * 0.02,
                    width: med.width * 0.3,
                    decoration: BoxDecoration(
                      color: CustomAppTheme().lightGreyColor,
                    ),
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: CustomAppTheme().lightGreyColor,
                  highlightColor: CustomAppTheme().backgroundColor,
                  child: Container(
                    height: med.height * 0.02,
                    width: med.width * 0.7,
                    decoration: BoxDecoration(
                      color: CustomAppTheme().lightGreyColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
