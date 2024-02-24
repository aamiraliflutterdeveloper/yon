

//  @dart=2.9
import 'package:app/brand/brand_landing_screen.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/chat/view_model/chat_view_model.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/connectivity/BindingNetwork/binding_network.dart';
import 'package:app/presentation/home/view_model/home_view_model.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/notification/notifications_services.dart';
import 'package:app/presentation/notification/view_model/notification_view_model.dart';
import 'package:app/presentation/profile/business_mode/view_model/business_view_model.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'presentation/authentication/view_model/user_view_model.dart';
import 'presentation/searchs/view_model/search_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupLocator();
  await FlutterDownloader.initialize(
      debug:
          true, // optional: set to false to disable printing logs to console (default: true)
      ignoreSsl:
          true // option: set to false to disable working with http links (default: false)
      );

  /*IPrefHelper iPrefHelper = inject<IPrefHelper>();
  if (iPrefHelper.retrieveUser() != null) {
    */
  /* var channel = WebSocketChannel.connect(
        Uri.parse('ws://192.168.18.163:9000/ws/notification/${iPrefHelper.retrieveUser()!.id}/?token=${iPrefHelper.retrieveToken()}'));
    // final channel = WebSocketChannel.connect(
    //   Uri.parse(
    //       'ws://192.168.18.71:9000/ws/chat-room/1635a122-c42f-4eaf-9731-a6ebcca206f1/?token=${iPrefHelper.retrieveToken()}'),
    // );
    /// Listen for all incoming data
    channel.stream.listen(
      (data) {
        log(data.toString());
        // d(data.toString());
        NotificationModel notificationModel = NotificationModel.fromJson(json.decode(data));
        log("Notification $notificationModel");
        if (notificationModel.text != null) {
          log("svdkjcvasdk");
          log(notificationModel.text.toString());
          NotificationService().showNotifications(id: int.parse(notificationModel.totalCount!), title: "Market Place", body: notificationModel.text);
        }
      },
      onError: (error) => d(error),
    );*/
  /*
    var channel1 = WebSocketChannel.connect(
      Uri.parse('ws://192.168.18.163:9000/ws/user-socket/${iPrefHelper.retrieveUser()!.id}/?token=${iPrefHelper.retrieveToken()}'),
    );

    /// Listen for all incoming data
    channel1.stream.listen(
      (data) {
        IPrefHelper iPrefHelper = inject<IPrefHelper>();
        d(data.toString());
        ChatSocketResModel chatSocketResModel = ChatSocketResModel.fromJson(json.decode(data));
        if (chatSocketResModel.singleMessageModel!.id != null) {
          SingleMessage singleMessage = SingleMessage(
            id: chatSocketResModel.singleMessageModel!.id,
            chatID: chatSocketResModel.singleMessageModel!.chat!.id,
            createdAt: chatSocketResModel.singleMessageModel!.createdAt,
            deletedBy: chatSocketResModel.singleMessageModel!.deletedBy,
            deliveredTo: chatSocketResModel.singleMessageModel!.deliveredTo,
            message: chatSocketResModel.singleMessageModel!.message,
            user: chatSocketResModel.singleMessageModel!.receiver,
            unRead: chatSocketResModel.singleMessageModel!.unRead,
          );
          d('This is single : $singleMessage');
          d('This is single message : ${singleMessage.message}');
          log('${chatSocketResModel.singleMessageModel!.chat!.profile![0].id == iPrefHelper.retrieveUser()!.id ? chatSocketResModel.singleMessageModel!.chat!.profile![1].firstName : chatSocketResModel.singleMessageModel!.chat!.profile![0].firstName}');
          String? endUser = chatSocketResModel.singleMessageModel!.chat!.profile![0].id == iPrefHelper.retrieveUser()!.id
              ? chatSocketResModel.singleMessageModel!.chat!.profile![1].firstName
              : chatSocketResModel.singleMessageModel!.chat!.profile![0].firstName;
          String? receiver =
              chatSocketResModel.singleMessageModel!.receiverId == iPrefHelper.retrieveUser()!.id ? iPrefHelper.retrieveUser()!.id : null;
          if (receiver != null) {
            NotificationService()
                .showNotifications(id: 1, title: endUser.toString(), body: chatSocketResModel.singleMessageModel!.message.toString());
          }
        }
      },
      onError: (error) => d(error),
    );
  }*/
  await NotificationService().init();
  await NotificationService().requestIOSPermissions();
  runApp(const MyApp());
}

class MyApp extends GetView {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<UserViewModel>(
          create: (_) => UserViewModel(),
        ),
        ChangeNotifierProvider<HomeViewModel>(
          create: (_) => HomeViewModel(),
        ),
        ChangeNotifierProvider<ClassifiedViewModel>(
          create: (_) => ClassifiedViewModel(),
        ),
        ChangeNotifierProvider<CreateAdPostViewModel>(
          create: (_) => CreateAdPostViewModel(),
        ),
        ChangeNotifierProvider<AutomotiveViewModel>(
          create: (_) => AutomotiveViewModel(),
        ),
        ChangeNotifierProvider<PropertiesViewModel>(
          create: (_) => PropertiesViewModel(),
        ),
        ChangeNotifierProvider<JobViewModel>(
          create: (_) => JobViewModel(),
        ),
        ChangeNotifierProvider<GeneralViewModel>(
          create: (_) => GeneralViewModel(),
        ),
        ChangeNotifierProvider<ProfileViewModel>(
          create: (_) => ProfileViewModel(),
        ),
        ChangeNotifierProvider<SearchViewModel>(
          create: (_) => SearchViewModel(),
        ),
        ChangeNotifierProvider<BusinessViewModel>(
          create: (_) => BusinessViewModel(),
        ),
        ChangeNotifierProvider<ChatViewModel>(
          create: (_) => ChatViewModel(),
        ),
        ChangeNotifierProvider<NotificationViewModel>(
          create: (_) => NotificationViewModel(),
        ),
      ],
      child: GetMaterialApp(
        title: 'YouOnline Market',
        debugShowCheckedModeBanner: false,
        initialBinding: BindingNetwork(),
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        // home: const BrandDetailScreen(),
        home: const SplashScreen(),
      ),
    );
  }
}





