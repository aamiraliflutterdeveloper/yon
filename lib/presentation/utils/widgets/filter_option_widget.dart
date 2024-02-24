import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class FilterOptionWidget extends StatefulWidget {
  final String value;
  final VoidCallback onTab;
  final int selectedIndex;
  final int currentIndex;
  final int? totalCount;

  const FilterOptionWidget(
      {Key? key,
      required this.value,
      required this.onTab,
      required this.selectedIndex,
      required this.currentIndex,
      this.totalCount = 0})
      : super(key: key);

  @override
  State<FilterOptionWidget> createState() => _FilterOptionWidgetState();
}

class _FilterOptionWidgetState extends State<FilterOptionWidget> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: widget.onTab,
      child: Stack(
        children: <Widget>[
          Container(
            height: med.height * 0.05,
            width: med.width,
            margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 3),
            decoration: BoxDecoration(
              color: widget.currentIndex == widget.selectedIndex
                  ? CustomAppTheme().lightGreenColor
                  : CustomAppTheme().lightGreyColor,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                  color: widget.currentIndex == widget.selectedIndex
                      ? CustomAppTheme().primaryColor
                      : CustomAppTheme().greyColor),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    widget.value,
                    style: CustomAppTheme()
                        .normalText
                        .copyWith(fontWeight: FontWeight.w600),
                  ),
                  // Text(
                  //   widget.totalCount.toString() +' ads',
                  //   style: CustomAppTheme().normalGreyText.copyWith(fontWeight: FontWeight.w500, fontSize: 12),
                  // )
                ],
              ),
            ),
          ),
          widget.currentIndex == widget.selectedIndex
              ? Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    decoration: BoxDecoration(
                      color: CustomAppTheme().primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check,
                      size: 10,
                      color: CustomAppTheme().backgroundColor,
                    ),
                  ),
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }
}
