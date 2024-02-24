import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class HomeScreenHeadingWidget extends StatelessWidget {
  final String headingText;
  final VoidCallback? viewAllCallBack;
  final bool? isSuffix;

  const HomeScreenHeadingWidget({Key? key, required this.headingText, this.viewAllCallBack, this.isSuffix = true}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          headingText,
          style: CustomAppTheme().headingText.copyWith(fontSize: 18),
        ),
        const Spacer(),
        isSuffix!
            ? GestureDetector(
                onTap: viewAllCallBack,
                child: Text(
                  'View All',
                  style: CustomAppTheme().normalGreyText.copyWith(fontSize: 14, color: Colors.grey),
                ),
              )
            : const SizedBox.shrink(),
      ],
    );
  }
}
