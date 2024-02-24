import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YouOnlineButton extends StatelessWidget {
  final VoidCallback onTap;
  final String text;
  final bool? isButtonWhite;
  final double? fontSize;
  const YouOnlineButton({Key? key, required this.onTap, required this.text, this.isButtonWhite = false, this.fontSize = 18}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return SizedBox(
      height: med.height*0.05,
      child: ElevatedButton(
        onPressed: onTap,
        style: ButtonStyle(
          backgroundColor: isButtonWhite! ? MaterialStateProperty.all<Color>(CustomAppTheme().backgroundColor)  : MaterialStateProperty.all<Color>(CustomAppTheme().primaryColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6.0),
                )
            ),
        ),
        child: Text(text,
          style: GoogleFonts.inter(
            textStyle: TextStyle(
                color: isButtonWhite! ? CustomAppTheme().primaryColor : CustomAppTheme().backgroundColor,
                fontWeight: FontWeight.w700,
                fontSize: fontSize!
            ),
          ),
        ),
      ),
    );
  }
}
