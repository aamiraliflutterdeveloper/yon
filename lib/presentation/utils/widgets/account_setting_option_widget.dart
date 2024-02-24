import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_switch/flutter_switch.dart';

class AccountSettingOption extends StatefulWidget {
  final String headingText;
  final String detailText;
  final bool isActive;
  final ValueChanged<bool> onToggle;
  const AccountSettingOption({Key? key, required this.isActive, required this.onToggle, required this.headingText, required this.detailText}) : super(key: key);

  @override
  State<AccountSettingOption> createState() => _AccountSettingOptionState();
}

class _AccountSettingOptionState extends State<AccountSettingOption> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Row(
      children: <Widget>[
        SizedBox(
          width: med.width*0.65,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(widget.headingText,
                style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w600, fontSize: 15),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(widget.detailText,
                  style: CustomAppTheme().normalGreyText.copyWith(fontWeight: FontWeight.w400, fontSize: 13),
                ),
              ),
            ],
          ),
        ),

        const Spacer(),

        FlutterSwitch(
          height: med.height*0.03,
          width: med.width*0.12,
          toggleSize: 18.0,
          value: widget.isActive,
          activeColor: CustomAppTheme().primaryColor,
          padding: 2.0,
          onToggle: widget.onToggle,
        ),
      ],
    );
  }
}
