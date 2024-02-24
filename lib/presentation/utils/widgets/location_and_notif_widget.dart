import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/notification/notification_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class LocationAndNotificationWidget extends StatefulWidget {
  const LocationAndNotificationWidget({Key? key}) : super(key: key);

  @override
  State<LocationAndNotificationWidget> createState() =>
      _LocationAndNotificationWidgetState();
}

class _LocationAndNotificationWidgetState
    extends State<LocationAndNotificationWidget> with BaseMixin {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        children: <Widget>[
          Icon(Icons.location_on_rounded,
              color: CustomAppTheme().secondaryColor),
          Padding(
            padding: const EdgeInsets.only(left: 8),
            child: Text(
              iPrefHelper.userCurrentCountry().toString(),
              style: CustomAppTheme()
                  .normalText
                  .copyWith(color: CustomAppTheme().darkGreyColor),
            ),
          ),
          // Icon(
          //   Icons.keyboard_arrow_down,
          //   color: CustomAppTheme().darkGreyColor,
          //   size: 16,
          // ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const NotificationScreen()));
            },
            child: Icon(Icons.notifications,
                color: CustomAppTheme().darkGreyColor),
          ),
        ],
      ),
    );
  }
}
