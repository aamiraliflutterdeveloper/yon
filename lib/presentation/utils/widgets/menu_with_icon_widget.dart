import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MenuWithIconWidget extends StatefulWidget {
  final int index;
  final int selectedSubMenuIndex;
  final String menuText;
  final String? iconUrl;
  const MenuWithIconWidget(
      {Key? key, required this.index, required this.selectedSubMenuIndex, required this.menuText, this.iconUrl = 'assets/temp/allIcon.svg'})
      : super(key: key);

  @override
  State<MenuWithIconWidget> createState() => _MenuWithIconWidgetState();
}

class _MenuWithIconWidgetState extends State<MenuWithIconWidget> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 5),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: widget.selectedSubMenuIndex == widget.index ? CustomAppTheme().primaryColor : CustomAppTheme().greyColor,
          ),
          color: widget.selectedSubMenuIndex == widget.index ? CustomAppTheme().lightGreenColor : CustomAppTheme().lightGreyColor,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              children: <Widget>[
                SvgPicture.asset(
                  widget.iconUrl!,
                  color: widget.selectedSubMenuIndex == widget.index ? CustomAppTheme().primaryColor : CustomAppTheme().greyColor,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    widget.menuText,
                    style: CustomAppTheme().normalText.copyWith(
                          letterSpacing: 0.5,
                          color: widget.selectedSubMenuIndex == widget.index ? CustomAppTheme().primaryColor : CustomAppTheme().darkGreyColor,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
