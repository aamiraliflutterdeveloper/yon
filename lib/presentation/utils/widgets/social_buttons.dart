import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class SocialButton extends StatefulWidget {
  final String iconUrl;
  final String text;
  const SocialButton({Key? key, required this.iconUrl, required this.text}) : super(key: key);

  @override
  State<SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<SocialButton> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Container(
      height: med.height * 0.05,
      width: med.width * 0.44,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(widget.iconUrl,
            height: med.height*0.025,
            width: med.width*0.05,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Text(widget.text,
              style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
