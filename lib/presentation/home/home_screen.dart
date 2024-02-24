import 'dart:convert';
import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/chat/chat_models.dart';
import 'package:app/data/models/chat/chat_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/ad_type_screen.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/categories/categories_screen.dart';
import 'package:app/presentation/chat/messages_screen.dart';
import 'package:app/presentation/chat/view_model/chat_view_model.dart';
import 'package:app/presentation/classified/classified_screen.dart';
import 'package:app/presentation/home/mixins/home_mixin.dart';
import 'package:app/presentation/home/view_model/home_view_model.dart';
import 'package:app/presentation/home/widgets/navigation_bar_item_widget.dart';
import 'package:app/presentation/notification/notifications_services.dart';
import 'package:app/presentation/profile/profile_menu_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with TickerProviderStateMixin, HomeMixin, BaseMixin {
  int selectedMenuIndex = 0;
  int selectedFeaturedMenuIndex = 0;
  int currentAdIndex = 0;
  int pageIndex = 0;
  int featuredAdsLength = 6;

  DateTime? currentBackPressTime;

  Future<bool> onWillPop() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(width * .03),
            topRight: Radius.circular(width * .03),
          ),
        ),
        builder: (context) {
          return SizedBox(
            height: height * .2,
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: width * .03,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(
                    height: height * .01,
                  ),
                  Text(
                    'YouOnline',
                    style: CustomAppTheme().normalText.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                  ),
                  SizedBox(
                    height: height * .01,
                  ),
                  Text(
                    "Confirm to exit from YouOnline.",
                    style: CustomAppTheme().normalText.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                        ),
                  ),
                  const Spacer(),
                  Row(
                    children: <Widget>[
                      const Spacer(),
                      SizedBox(
                        height: height * .05,
                        width: width * .3,
                        child: YouOnlineButton(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          text: 'Cancel',
                        ),
                      ),
                      SizedBox(
                        width: width * .03,
                      ),
                      SizedBox(
                        height: height * .05,
                        width: width * .3,
                        child: YouOnlineButton(
                          onTap: () {
                            SystemNavigator.pop();
                          },
                          text: 'Confirm',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: height * .02,
                  ),
                ],
              ),
            ),
          );
        },
      );
      return Future.value(false);
    }
    return Future.value(true);
  }

  @override
  void initState() {
    super.initState();
    IPrefHelper iPrefHelper = inject<IPrefHelper>();
    IExternalValues iExternalValues = inject<IExternalValues>();
    GeneralViewModel generalViewModel = context.read<GeneralViewModel>();
    generalViewModel.getCurrentLocation(context: context);
    if (iPrefHelper.retrieveUser() != null) {
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
      var channel1 = WebSocketChannel.connect(
        Uri.parse(
            'ws://services-dev.youonline.online/ws/user-socket/${iPrefHelper.retrieveUser()!.id}/?token=${iPrefHelper.retrieveToken()}'),
      );

      /// Listen for all incoming data
      channel1.stream.listen(
        (data) {
          IPrefHelper iPrefHelper = inject<IPrefHelper>();
          d('SOCKET DATA ::: ' + data.toString());
          ChatSocketResModel chatSocketResModel =
              ChatSocketResModel.fromJson(json.decode(data));
          if (chatSocketResModel.message != null) {
            ChatViewModel chatViewModel = context.read<ChatViewModel>();
            SingleMessage singleMessage = SingleMessage(
              chatID: chatSocketResModel.message!.chatId,
              deliveredTo: iPrefHelper.retrieveUser()!.id ==
                      chatSocketResModel.message!.receiverId
                  ? [
                      iPrefHelper.retrieveUser()!,
                      chatSocketResModel.message!.sender!
                    ]
                  : null,
              message: chatSocketResModel.message!.text,
              sender: chatSocketResModel.message!.sender!,
            );
            d('This is single : $singleMessage');
            d('This is single message : ${singleMessage.message}');
            if (chatSocketResModel.message!.receiverId ==
                iPrefHelper.retrieveUser()!.id) {
              d('IN.  ${chatSocketResModel.message!.receiverId} == ${iPrefHelper.retrieveUser()!.id}');
              if (chatViewModel.messageList.isNotEmpty) {
                d('IN. LIST');
                if (chatViewModel.messageList[0].chatID ==
                    singleMessage.chatID) {
                  d('INn.');
                  chatViewModel.messageList.add(singleMessage);
                  chatViewModel.changeMessageList(chatViewModel.messageList);
                }
              }
              NotificationService().showNotifications(
                  id: 1,
                  title: singleMessage.sender!.firstName.toString(),
                  body: singleMessage.message);
            }
            /*log('${chatSocketResModel.singleMessageModel!.chat!.profile![0].id == iPrefHelper.retrieveUser()!.id ? chatSocketResModel.singleMessageModel!.chat!.profile![1].firstName : chatSocketResModel.singleMessageModel!.chat!.profile![0].firstName}');
            String? endUser = chatSocketResModel.singleMessageModel!.chat!.profile![0].id == iPrefHelper.retrieveUser()!.id
                ? chatSocketResModel.singleMessageModel!.chat!.profile![1].firstName
                : chatSocketResModel.singleMessageModel!.chat!.profile![0].firstName;
            String? receiver =
                chatSocketResModel.singleMessageModel!.receiverId == iPrefHelper.retrieveUser()!.id ? iPrefHelper.retrieveUser()!.id : null;

            if (receiver != null) {
              NotificationService()
                  .showNotifications(id: 1, title: endUser.toString(), body: chatSocketResModel.singleMessageModel!.message.toString());
            }*/
          }
        },
        onError: (error) => d(error),
      );
    }
    d('USER TOKEN : ' + iPrefHelper.retrieveToken().toString());
    d('USER ID : ' + iPrefHelper.retrieveUser()!.id.toString());
  }

  @override
  Widget build(BuildContext context) {
    final HomeViewModel userViewModel = context.watch<HomeViewModel>();
    Size med = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        body: PageView(
          controller: pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: const <Widget>[
            ClassifiedScreen(),
            CategoriesScreen(),
            MessagesScreen(),
            ProfileMenuScreen(),
          ],
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(top: 20),
          child: SizedBox(
            height: 65,
            width: 65,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const AdTypeScreen()));
              },
              child: Container(
                height: 65,
                width: 65,
                decoration: BoxDecoration(
                  border: Border.all(
                      color: CustomAppTheme().primaryColor, width: 4),
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: const Alignment(0.7, -0.5),
                    end: const Alignment(0.6, 0.5),
                    colors: [
                      CustomAppTheme().backgroundColor,
                      CustomAppTheme().backgroundColor,
                    ],
                  ),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/svgs/addIcon.svg',
                  ),
                ),
              ),
            ),
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBar(
          elevation: 15,
          color: Colors.white,
          child: Container(
            height: med.height * 0.09,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: <Widget>[
                  NavigationBarItemWidget(
                    onTab: () {
                      d('HOME PRESSED');
                      setState(() {
                        pageIndex = 0;
                        pageController.jumpToPage(0);
                      });
                    },
                    svgUrl: 'assets/svgs/homeIcon.svg',
                    title: 'Home',
                    isActive: pageIndex == 0 ? true : false,
                  ),
                  SizedBox(width: med.width * 0.0),
                  NavigationBarItemWidget(
                    onTab: () {
                      setState(() {
                        pageIndex = 1;
                        pageController.jumpToPage(1);
                      });
                    },
                    svgUrl: 'assets/svgs/categoriesIcon.svg',
                    title: 'Categories',
                    isActive: pageIndex == 1 ? true : false,
                  ),
                  const Spacer(),
                  NavigationBarItemWidget(
                    onTab: () {
                      setState(() {
                        pageIndex = 2;
                        pageController.jumpToPage(2);
                      });
                    },
                    svgUrl: 'assets/svgs/chat_icon.svg',
                    title: 'Chat',
                    isActive: pageIndex == 2 ? true : false,
                  ),
                  SizedBox(width: med.width * 0.0),
                  NavigationBarItemWidget(
                    onTab: () {
                      setState(() {
                        pageIndex = 3;
                        pageController.jumpToPage(3);
                      });
                    },
                    svgUrl: 'assets/svgs/userProfileIcon.svg',
                    title: 'Profile',
                    isActive: pageIndex == 3 ? true : false,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<String> menuOptions = [
    'Classified',
    'Automotive',
    'Property',
    'Jobs',
  ];
}
