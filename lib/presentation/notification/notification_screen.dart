import 'dart:convert';

import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/notification_models/notification_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/presentation/chat/dm_screen.dart';
import 'package:app/presentation/notification/view_model/notification_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/messageCardShimmer.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:http/http.dart' as http;

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  bool isDataFetching = false;

  void getAllNotifications() async {
    NotificationViewModel notificationViewModel = context.read<NotificationViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await notificationViewModel.getAllNotifications();
    result.fold((l) {}, (r) {
      d('This is result : $r');
      notificationViewModel.changeNotificationList(r.notificationList!);
    });
    setState(() {
      isDataFetching = false;
    });
  }

  Future updateNotificationStatus({
    required String notificationId,
  }) async {
    try {
      IPrefHelper iPrefHelper = inject<IPrefHelper>();
      Uri uri = Uri.parse(
          'https://services-dev.youonline.online/api/mark_as_read_notification/');
      d('UPDATED USER PROFILE URL :: $uri');
      var request = http.MultipartRequest("PUT", uri);

      request.fields['notification_id'] = notificationId;
      // request.fields['company_status'] = true.toString();

      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      d(response);
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      d('STATUS CODE : ${response.statusCode}');
      d(decodedResponse);
      if (response.statusCode == 201 || response.statusCode == 200) {
        print("Notification Status :: Updated");
        print("============");
      } else {
        d('ERROR : ${decodedResponse['response']['message']}');
      }
    } catch (e) {
      d(e);
    }
  }

  @override
  void initState() {
    super.initState();
    getAllNotifications();
  }



  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    NotificationViewModel notificationViewModel = context.watch<NotificationViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Notifications', context: context, onTap: () {
        Navigator.of(context).pop();
      }),
      body: !isDataFetching
          ? ListView.builder(
              itemCount: notificationViewModel.notificationList.length,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                print(notificationViewModel.notificationList[index].isRead);
                print(" ==================  =================  ================= ");
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                  child: GestureDetector(
                    onTap: () {
                      onNotificationTab(notificationViewModel.notificationList[index]);
                      updateNotificationStatus(notificationId: notificationViewModel.notificationList[index].id!);
                      print(notificationViewModel.notificationList[index].id);
                      setState(() {
                        notificationViewModel.notificationList[index].isRead = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.only(left: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: notificationViewModel.notificationList[index].isRead == true ? Colors.transparent : Colors.grey.shade200,
                      ),
                      child: Row(
                        children: <Widget>[
                          Container(
                            height: med.height * 0.08,
                            width: med.width * 0.12,
                            decoration: BoxDecoration(
                              color: CustomAppTheme().primaryColor,
                              shape: BoxShape.circle,
                              image: notificationViewModel.notificationList[index].profile!.profilePicture != null
                                  ? DecorationImage(
                                      image: NetworkImage(notificationViewModel.notificationList[index].profile!.profilePicture.toString()),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: SizedBox(
                              height: med.height * 0.045,
                              width: med.width * 0.75,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    // crossAxisAlignment: WrapCrossAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        notificationViewModel.notificationList[index].profile!.firstName.toString(),
                                        style: CustomAppTheme().normalText.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        timeago.format(
                                          DateTime.parse(
                                            notificationViewModel.notificationList[index].createdAt.toString(),
                                          ),
                                        ),
                                        style: CustomAppTheme().normalGreyText.copyWith(fontSize: 9),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    notificationViewModel.notificationList[index].text.toString(),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : ListView.builder(
              itemCount: 7,
              padding: const EdgeInsets.symmetric(vertical: 15),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return const MessageCardShimmer();
              },
            ),
    );
  }

  void onNotificationTab(NotificationModel notification) {
    if (notification.type == 'Classified') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            classifiedProduct: notification.classified,
            productType: 'Classified',
          ),
        ),
      );
    } else if (notification.type == 'Automotive') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            automotiveProduct: notification.automotive,
            productType: 'Automotive',
          ),
        ),
      );
    } else if (notification.type == 'Property') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            propertyProduct: notification.property,
            productType: 'Property',
          ),
        ),
      );
    } else if (notification.type == 'Job') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(
            jobProduct: notification.job,
            productType: 'Job',
            isJobAd: true,
          ),
        ),
      );
    } else if (notification.type == 'Chat') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DirectMessageScreen(
            chatId: notification.chatId!,
            receiver: notification.profile!,
          ),
        ),
      );
    }
  }
}
