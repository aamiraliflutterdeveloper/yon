import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SkipButton extends StatelessWidget {
  final VoidCallback onTap;
  const SkipButton({Key? key, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text('Skip',
        style: GoogleFonts.inter(
          textStyle: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w700,
              fontSize: 18
          ),
        ),
      ),
    );
  }
}
