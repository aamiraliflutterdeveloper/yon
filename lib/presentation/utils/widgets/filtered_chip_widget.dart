import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FilterChipWidget extends StatefulWidget {
  final String filteredText;
  final VoidCallback? onDeleteTap;

  const FilterChipWidget({Key? key, required this.filteredText, this.onDeleteTap}) : super(key: key);

  @override
  State<FilterChipWidget> createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  @override
  Widget build(BuildContext context) {
    final ClassifiedViewModel classifiedViewModel = context.watch<ClassifiedViewModel>();
    return Row(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
            color: CustomAppTheme().lightGreenColor,
            border: Border.all(color: CustomAppTheme().primaryColor),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            child: Row(
              children: <Widget>[
                Text(
                  widget.filteredText,
                  style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w600, color: CustomAppTheme().blackColor, fontSize: 10),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: GestureDetector(
                    onTap: widget.onDeleteTap ?? () {},
                    child: Icon(Icons.cancel, color: CustomAppTheme().primaryColor, size: 12),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
