import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';


Future<void> showAlertDialog({required VoidCallback onDelete, required BuildContext context}) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete Ad'),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                'Are you sure want to delete this Ad?',
                style: CustomAppTheme().normalText,
              ),
            ],
          ),
        ),
        actions: <Widget>[
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.035,
            child: YouOnlineButton(
              onTap: () {
                Navigator.pop(context);
              },
              text: 'No',
              fontSize: 12,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.035,
            child: YouOnlineButton(
              onTap: onDelete,
              text: 'Delete',
              fontSize: 12,
            ),
          ),
        ],
      );
    },
  );
}
