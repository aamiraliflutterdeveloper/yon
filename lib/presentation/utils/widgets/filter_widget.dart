import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FilterWidget extends StatelessWidget {
  final VoidCallback onTab;
  final Color? backgroundColor;
  const FilterWidget({Key? key, required this.onTab, this.backgroundColor = const Color(0xFFFF9800)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTab,
      child: Container(
        height: med.height * 0.045,
        width: med.width * 0.1,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Center(
          child: SvgPicture.asset(
            'assets/svgs/filterIcon.svg',
            height: MediaQuery.of(context).size.height * 0.02,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
