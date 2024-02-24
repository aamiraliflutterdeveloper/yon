import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ExploreMoreButton extends StatefulWidget {
  final VoidCallback onTab;
  const ExploreMoreButton({Key? key, required this.onTab}) : super(key: key);

  @override
  State<ExploreMoreButton> createState() => _ExploreMoreButtonState();
}

class _ExploreMoreButtonState extends State<ExploreMoreButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: widget.onTab,
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(CustomAppTheme().primaryColor),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6.0),
            )
        ),
      ),
      child: Text('Explore More',
        style: GoogleFonts.inter(
          textStyle: TextStyle(
              color: CustomAppTheme().backgroundColor,
              fontWeight: FontWeight.w500,
              fontSize: 14
          ),
        ),
      ),
    );
  }
}
