import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ResumeWidget extends StatefulWidget {
  final String docTitle;
  final VoidCallback onDelete;
  const ResumeWidget({Key? key, required this.docTitle, required this.onDelete})
      : super(key: key);

  @override
  State<ResumeWidget> createState() => _ResumeWidgetState();
}

class _ResumeWidgetState extends State<ResumeWidget> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Container(
      height: med.height * 0.08,
      width: med.width,
      decoration: BoxDecoration(
        color: const Color(0xfffdf4f1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/svgs/pdfIcon.svg',
              height: med.height * 0.05,
              width: med.width * 0.15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                height: med.height * 0.04,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: med.width * 0.6,
                      child: Text(
                        widget.docTitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomAppTheme().normalText.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '805 KB',
                      style: CustomAppTheme()
                          .normalText
                          .copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: widget.onDelete,
              child: SvgPicture.asset(
                'assets/svgs/deleteIcon2.svg',
                height: med.height * 0.02,
                width: med.width * 0.6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
