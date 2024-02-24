import 'dart:convert';
import 'package:app/presentation/utils/dialogs/custom_dialog.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:http/http.dart' as http;
import 'package:app/common/logger/log.dart';
import 'package:app/data/models/chat/chat_models.dart';
import 'package:app/data/models/chat/single_user_chat_res_model.dart';
import 'package:app/data/models/general_res_models/user_profile_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/chat/view_model/chat_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DirectMessageScreen extends StatefulWidget {
  final String chatId;
  final UserProfileModel receiver;
  const DirectMessageScreen(
      {Key? key, required this.chatId, required this.receiver})
      : super(key: key);

  @override
  State<DirectMessageScreen> createState() => _DirectMessageScreenState();
}

class _DirectMessageScreenState extends State<DirectMessageScreen>
    with BaseMixin {
  TextEditingController textMessageController = TextEditingController();
  ScrollController scrollController = ScrollController();
  // List<SingleMessage> messageList = [];

  final formKey = GlobalKey<FormState>();

  getUserMessagesList() async {
    ChatViewModel chatViewModel = context.read<ChatViewModel>();
    chatViewModel.changeMessageList([]);
    SingleUserChatResModel userChat =
        await chatViewModel.getSingleUserMessageList(
            userID: iPrefHelper.retrieveUser()!.id!,
            chatId: widget.chatId,
            context: context);
    for (int i = 0; i < userChat.messageList!.length; i++) {
      setState(() {
        chatViewModel.messageList.add(userChat.messageList![i]);
        chatViewModel.changeMessageList(chatViewModel.messageList);
      });
    }
    print(userChat.messageList!.length);
    print("this is above the line");
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 100,
      duration: const Duration(microseconds: 1),
      curve: Curves.linear,
    );
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    d('Receiver Id : ${widget.receiver.id}');
    getUserMessagesList();

    // var channel1 = WebSocketChannel.connect(
    //   Uri.parse('ws://192.168.18.163:9000/ws/user-socket/${iPrefHelper.retrieveUser()!.id}/?token=${iPrefHelper.retrieveToken()}'),
    // );
    //
    // channel1.stream.listen((data) {
    //   scrollController.animateTo(
    //     scrollController.position.maxScrollExtent + 100,
    //     duration: const Duration(seconds: 1),
    //     curve: Curves.fastOutSlowIn,
    //   );
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ChatViewModel chatViewModel = context.watch<ChatViewModel>();
    print(chatViewModel.messageList.length);
    print("hahahhhahhaa ==== this is on the chat == === === ==== ");
    /*Timer(const Duration(milliseconds: 500), () => scrollController.jumpTo(scrollController.position.maxScrollExtent));*/
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            SizedBox(
              height: med.height * 0.01,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: CustomAppTheme().backgroundColor,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            spreadRadius: 0.3,
                            blurRadius: 2,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Icon(Icons.arrow_back_ios_rounded,
                            size: 15, color: CustomAppTheme().blackColor),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: med.width * 0.05,
                  ),
                  Container(
                    height: med.height * 0.06,
                    width: med.width * 0.12,
                    decoration: BoxDecoration(
                      color: CustomAppTheme().primaryColor,
                      shape: BoxShape.circle,
                      image: widget.receiver.profilePicture != null
                          ? DecorationImage(
                              image:
                                  NetworkImage(widget.receiver.profilePicture!))
                          : null,
                    ),
                  ),
                  SizedBox(
                    height: med.height * 0.06,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(
                            widget.receiver.firstName!,
                            style: CustomAppTheme().normalText.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              color: CustomAppTheme().greyColor.withOpacity(0.3),
            ),
            Expanded(
              child: Container(
                color: CustomAppTheme().backgroundColor,
                child: chatViewModel.messageList.isEmpty
                    ? Center(
                        child: Text(
                          "No Chat",
                          style: CustomAppTheme().normalGreyText.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w600),
                        ),
                      )
                    : ListView.builder(
                        itemCount: chatViewModel.messageList.length,
                        shrinkWrap: true,
                        // reverse: true,
                        controller: chatViewModel.messageList.isNotEmpty
                            ? scrollController
                            : null,
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {

                          DateTime now = DateTime.now();
                          DateTime parsedDate = DateTime.parse(
                              chatViewModel.messageList[index].createdAt!);
                          String formattedDate = DateFormat('MMM d, yyyy').format(parsedDate);
                          String formattedTime = DateFormat('kk:mm:a').format(parsedDate);
                          var requiredDifference = daysBetween(parsedDate, now);
                          // print(requiredDifference);
                          // print("hahahahahah");

                          print(parsedDate);
                          return Column(
                            children: [
                              GestureDetector(
                                onTap: () {},
                                child: Container(
                                  padding: chatViewModel
                                              .messageList[index].sender!.id !=
                                          iPrefHelper.retrieveUser()!.id
                                      ? const EdgeInsets.only(
                                          left: 14,
                                          right: 30,
                                          top: 10,
                                          bottom: 10)
                                      : const EdgeInsets.only(
                                          left: 30,
                                          right: 14,
                                          top: 10,
                                          bottom: 10),
                                  child: Align(
                                    alignment: (chatViewModel
                                                .messageList[index].sender!.id !=
                                            iPrefHelper.retrieveUser()!.id
                                        ? Alignment.topLeft
                                        : Alignment.topRight),
                                    child: GestureDetector(
                                      onLongPress: () {
                                        d('Long Press');

                                        showMemberMenu(messageId: chatViewModel.messageList[index].id!, chatViewModel: chatViewModel, index: index);

                                        // CustomDialog.blockAdDialog(
                                        //     context: context,
                                        //     title: 'Are you sure do you want to delete this message!',
                                        //     rightButtonText: 'Delete',
                                        //     cancelCallBack: () {
                                        //       Get.back();
                                        //     },
                                        //     blockCallBack: () async {
                                        //       setState(() {
                                        //         isLoading = true;
                                        //       });
                                        //       CustomDialog.showAlertDialog();
                                        //
                                        //       final response = await deleteMessage(
                                        //           messageId: chatViewModel.messageList[index].id,
                                        //           chatViewModel: chatViewModel,
                                        //           index: index).then((value) {
                                        //         print("=============");
                                        //         setState(() {
                                        //           isLoading = false;
                                        //           Get.back();
                                        //           Get.back();
                                        //           // Get.back();
                                        //         });
                                        //       });
                                        //       // Get.back();
                                        //       // Get.back();
                                        //     });
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius: chatViewModel
                                                      .messageList[index]
                                                      .sender!
                                                      .id !=
                                                  iPrefHelper.retrieveUser()!.id
                                              ? const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                  bottomLeft: Radius.circular(0),
                                                  bottomRight:
                                                      Radius.circular(20),
                                                )
                                              : const BorderRadius.only(
                                                  topLeft: Radius.circular(20),
                                                  topRight: Radius.circular(20),
                                                  bottomLeft: Radius.circular(20),
                                                  bottomRight: Radius.circular(0),
                                                ),
                                          color: (chatViewModel.messageList[index]
                                                      .sender!.id !=
                                                  iPrefHelper.retrieveUser()!.id
                                              ? CustomAppTheme().lightGreyColor
                                              : CustomAppTheme().primaryColor),
                                        ),
                                        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                        child: Column(
                                          crossAxisAlignment:
                                          chatViewModel
                                              .messageList[index]
                                              .sender!
                                              .id !=
                                              iPrefHelper
                                                  .retrieveUser()!
                                                  .id ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                                          children: <Widget>[
                                            Text(
                                              chatViewModel
                                                  .messageList[index].message
                                                  .toString(),
                                              style: chatViewModel
                                                          .messageList[index]
                                                          .sender!
                                                          .id !=
                                                      iPrefHelper
                                                          .retrieveUser()!
                                                          .id
                                                  ? CustomAppTheme()
                                                      .normalText
                                                      .copyWith(
                                                          color: CustomAppTheme()
                                                              .blackColor)
                                                  : CustomAppTheme()
                                                      .normalText
                                                      .copyWith(
                                                          color: CustomAppTheme()
                                                              .backgroundColor),
                                            ),
                                            const SizedBox(height: 5),
                                            chatViewModel.messageList[index].createdAt != null ?  Container(
                                                padding: chatViewModel
                                                    .messageList[index].sender!.id !=
                                                    iPrefHelper.retrieveUser()!.id
                                                    ? const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0)
                                                    : const EdgeInsets.only(
                                                    left: 0,
                                                    right: 0,
                                                    top: 0,
                                                    bottom: 0),
                                                child: Align(
                                                    alignment: (chatViewModel
                                                        .messageList[index]
                                                        .sender!
                                                        .id !=
                                                        iPrefHelper.retrieveUser()!.id
                                                        ? Alignment.topLeft
                                                        : Alignment.topRight),
                                                    child: requiredDifference >= 1 ? Text("$formattedDate $formattedTime", style: const TextStyle(color: Colors.grey, fontSize: 12),) : Text(formattedTime, style: const TextStyle(color: Colors.grey, fontSize: 12),))) : const SizedBox.shrink(),


                                            // const SizedBox(
                                            //   height: 3,
                                            // ),
                                            // Text(
                                            //   timeago
                                            //           .format(
                                            //             DateTime.parse(
                                            //               chatViewModel
                                            //                   .messageList[index]
                                            //                   .createdAt
                                            //                   .toString(),
                                            //             ),
                                            //           )
                                            //           .contains("seconds")
                                            //       ? timeago
                                            //           .format(
                                            //             DateTime.parse(
                                            //               chatViewModel
                                            //                   .messageList[index]
                                            //                   .createdAt
                                            //                   .toString(),
                                            //             ),
                                            //           )
                                            //           .replaceAll("seconds", "sec")
                                            //       : timeago
                                            //               .format(
                                            //                 DateTime.parse(
                                            //                   chatViewModel
                                            //                       .messageList[index]
                                            //                       .createdAt
                                            //                       .toString(),
                                            //                 ),
                                            //               )
                                            //               .contains("second")
                                            //           ? timeago
                                            //               .format(
                                            //                 DateTime.parse(
                                            //                   chatViewModel
                                            //                       .messageList[index]
                                            //                       .createdAt
                                            //                       .toString(),
                                            //                 ),
                                            //               )
                                            //               .replaceAll("second", "sec")
                                            //           : timeago
                                            //                   .format(
                                            //                     DateTime.parse(
                                            //                       chatViewModel
                                            //                           .messageList[
                                            //                               index]
                                            //                           .createdAt
                                            //                           .toString(),
                                            //                     ),
                                            //                   )
                                            //                   .contains("minutes")
                                            //               ? timeago
                                            //                   .format(
                                            //                     DateTime.parse(
                                            //                       chatViewModel
                                            //                           .messageList[
                                            //                               index]
                                            //                           .createdAt
                                            //                           .toString(),
                                            //                     ),
                                            //                   )
                                            //                   .replaceAll(
                                            //                       "minutes", "mins")
                                            //               : timeago
                                            //                       .format(
                                            //                         DateTime.parse(
                                            //                           chatViewModel
                                            //                               .messageList[
                                            //                                   index]
                                            //                               .createdAt
                                            //                               .toString(),
                                            //                         ),
                                            //                       )
                                            //                       .contains("minute")
                                            //                   ? timeago
                                            //                       .format(
                                            //                         DateTime.parse(
                                            //                           chatViewModel
                                            //                               .messageList[
                                            //                                   index]
                                            //                               .createdAt
                                            //                               .toString(),
                                            //                         ),
                                            //                       )
                                            //                       .replaceAll(
                                            //                           "minute", "min")
                                            //                   : timeago
                                            //                           .format(
                                            //                             DateTime
                                            //                                 .parse(
                                            //                               chatViewModel
                                            //                                   .messageList[
                                            //                                       index]
                                            //                                   .createdAt
                                            //                                   .toString(),
                                            //                             ),
                                            //                           )
                                            //                           .contains(
                                            //                               "months")
                                            //                       ? timeago
                                            //                           .format(
                                            //                             DateTime
                                            //                                 .parse(
                                            //                               chatViewModel
                                            //                                   .messageList[
                                            //                                       index]
                                            //                                   .createdAt
                                            //                                   .toString(),
                                            //                             ),
                                            //                           )
                                            //                           .replaceAll(
                                            //                               "months",
                                            //                               "mons")
                                            //                       : timeago
                                            //                               .format(
                                            //                                 DateTime
                                            //                                     .parse(
                                            //                                   chatViewModel
                                            //                                       .messageList[index]
                                            //                                       .createdAt
                                            //                                       .toString(),
                                            //                                 ),
                                            //                               )
                                            //                               .contains(
                                            //                                   "month")
                                            //                           ? timeago
                                            //                               .format(
                                            //                                 DateTime
                                            //                                     .parse(
                                            //                                   chatViewModel
                                            //                                       .messageList[index]
                                            //                                       .createdAt
                                            //                                       .toString(),
                                            //                                 ),
                                            //                               )
                                            //                               .replaceAll(
                                            //                                   "month",
                                            //                                   "mon")
                                            //                           : timeago
                                            //                               .format(
                                            //                               DateTime
                                            //                                   .parse(
                                            //                                 chatViewModel
                                            //                                     .messageList[
                                            //                                         index]
                                            //                                     .createdAt
                                            //                                     .toString(),
                                            //                               ),
                                            //                             ),

                                            //   // timeago.format(DateTime.parse(
                                            //   //     chatViewModel
                                            //   //         .messageList[index].createdAt
                                            //   //         .toString())),
                                            //   style: chatViewModel.messageList[index]
                                            //               .sender!.id !=
                                            //           iPrefHelper.retrieveUser()!.id
                                            //       ? CustomAppTheme()
                                            //           .normalText
                                            //           .copyWith(
                                            //               fontSize: 10,
                                            //               color: CustomAppTheme()
                                            //                   .blackColor)
                                            //       : CustomAppTheme()
                                            //           .normalText
                                            //           .copyWith(
                                            //               fontSize: 10,
                                            //               color: CustomAppTheme()
                                            //                   .backgroundColor),
                                            // ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                             // Text(chatViewModel
                             //     .messageList[index].createdAt
                             //     .toString()),
                            ],
                          );
                        },
                      ),
              ),
            ),
            Form(
              key: formKey,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: SizedBox(
                  height: med.height * 0.08,
                  width: med.width,
                  child: Column(
                    children: <Widget>[
                      Divider(
                        height: 5,
                        color: CustomAppTheme().greyColor.withOpacity(0.3),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: <Widget>[
                            SizedBox(
                              width: med.width * 0.75,
                              child: TextFormField(
                                controller: textMessageController,
                                style: CustomAppTheme().normalText.copyWith(
                                    color: CustomAppTheme().blackColor),
                                decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Write a message....',
                                    hintStyle: CustomAppTheme()
                                        .normalGreyText
                                        .copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500)),
                              ),
                            ),
                            const Spacer(),
                            GestureDetector(
                              onTap: () {
                                if (textMessageController.text.isNotEmpty) {
                                  if (chatViewModel.messageList.isEmpty) {
                                    getUserMessagesList();
                                  }
                                  chatViewModel.sendMessage(
                                    receiverId: widget.receiver.id!,
                                    chatId: widget.chatId,
                                    textMessage: textMessageController.text,
                                    context: context,
                                  );
                                  setState(() {
                                    chatViewModel.messageList.add(
                                      SingleMessage(
                                        unRead: false,
                                        message: textMessageController.text,
                                        chatID: widget.chatId,
                                        createdAt: DateTime.now().toString(),
                                        sender: iPrefHelper.retrieveUser(),
                                      ),
                                    );
                                    messages.add(ChatMessage(
                                        messageContent:
                                            textMessageController.text,
                                        messageType: 'sender'));
                                    textMessageController.clear();
                                    scrollController.jumpTo(scrollController
                                        .position.maxScrollExtent);
                                  });
                                  scrollController.animateTo(
                                    scrollController.position.maxScrollExtent +
                                        100,
                                    duration: const Duration(seconds: 1),
                                    curve: Curves.fastOutSlowIn,
                                  );
                                  FlutterRingtonePlayer.play(
                                    fromAsset: "assets/sounds/sendMessage.wav",
                                    volume: 1.0,
                                  );
                                  setState(() {});
                                } else {
                                  helper.showToast('Please write your message');
                                }
                                print(chatViewModel.messageList.length);
                                print(
                                    "hahahhhahhaa ==== this is on the chat == === === ==== ");
                              },
                              child: Container(
                                height: med.height * 0.05,
                                width: med.width * 0.1,
                                decoration: BoxDecoration(
                                    color: CustomAppTheme().primaryColor,
                                    shape: BoxShape.circle),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: SvgPicture.asset(
                                    'assets/svgs/sendIcon.svg',
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isLoading = false;



  void showMemberMenu({required String messageId, required ChatViewModel chatViewModel, required int index}) async {
    await showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(200, 150, 100, 100),
      items: [
        PopupMenuItem(
          value: 1,
          height: 40,
          padding: const EdgeInsets.only(left: 5, right: 5),
          child: SizedBox(
            width: 105,
            child: GestureDetector(
              onTap: () async{

                CustomDialog.blockAdDialog(
                    context: context,
                    title: 'Are you sure do you want to delete this message!',
                    rightButtonText: 'Delete',
                    cancelCallBack: () {
                      Get.back();
                    },
                    blockCallBack: () async {
                      setState(() {
                        isLoading = true;
                      });
                      CustomDialog.showAlertDialog();

                      final response = await deleteMessage(
                          messageId: chatViewModel.messageList[index].id,
                          chatViewModel: chatViewModel,
                          index: index).then((value) {
                        print("=============");
                        setState(() {
                          isLoading = false;
                          Get.back();
                          Get.back();
                          // Get.back();
                        });
                      });
                      // Get.back();
                      // Get.back();
                    }).then((value) => Get.back());

                // CustomDialog.blockAdDialog(
                //     context: context,
                //     title: 'Are you sure, you want to delete this chat.?',
                //     rightButtonText: 'Delete',
                //     cancelCallBack: () {
                //       Get.back();
                //       Get.back();
                //     },
                //     blockCallBack: () async {
                //       setState(() {
                //         isLoading = true;
                //       });
                //       CustomDialog.showAlertDialog();
                //
                //       final response = await deleteChat(
                //           chatId: chatViewModel.userChatList[index].id!,
                //           chatViewModel: chatViewModel,
                //           index: index).then((value) {
                //         print("=============");
                //         setState(() {
                //           isLoading = false;
                //           Get.back();
                //           Get.back();
                //           Get.back();
                //         });
                //       });
                //       // Get.back();
                //       // Get.back();
                //     });
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Icon(Icons.delete, size: 20, color: Colors.red),
                  Text("Delete",
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Roboto',
                          color: Colors.black), textAlign: TextAlign.center),
                ],
              ),
            ),
          ),
        ),
      ],
      elevation: 8.0,
    ).then((value) {
      if (value != null) print(value);
    });
  }




  Future<void> deleteMessage({String? messageId, chatViewModel, index}) async {
    try {
      var response = await http.delete(
          Uri.parse(
              "https://services-dev.youonline.online/api/chat/delete_chat_message/"),
          body: {"chat_message": messageId, "delete_for": "Foreveryone"},
          headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      d('response: ' + response.body.toString());
      d("Authorization: " + iPrefHelper.retrieveToken().toString());
      d("Authorization: " + iPrefHelper.retrieveUser()!.id.toString());
      d('Data: ' + messageId.toString());
      if (response.statusCode == 200) {
        setState(() {
          chatViewModel.messageList.removeAt(index);
        });
        helper.showToast(
            '${jsonDecode(response.body)['response']["message"]} ..');
      } else {
        helper.showToast(
            '${jsonDecode(response.body)['response']["message"]} ..');
        throw Exception();
      }
    } catch (e) {
      helper.showToast("You don't have the access to delete this message for everyone!");
    }
    setState(() {});
  }


  void _showText(BuildContext context) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return const AlertDialog(
            content: Text(
                "User name "),
            actions: <Widget>[
              // new FlatButton(
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //     child: new Text("OK"))
            ],
          );
        });
  }






  int daysBetween(DateTime from, DateTime to) {
    from = DateTime(from.year, from.month, from.day);
    to = DateTime(to.year, to.month, to.day);
    return (to.difference(from).inHours / 24).round();
  }

  List<ChatMessage> messages = [
    ChatMessage(messageContent: "Hello, Will", messageType: "receiver"),
    ChatMessage(messageContent: "How have you been?", messageType: "receiver"),
    ChatMessage(
        messageContent: "Hey Kriss, I am doing fine dude. wbu?",
        messageType: "sender"),
    ChatMessage(messageContent: "ehhhh, doing OK.", messageType: "receiver"),
    ChatMessage(
        messageContent: "Is there any thing wrong?", messageType: "sender"),
    ChatMessage(messageContent: "This is a game.", messageType: "receiver"),
    ChatMessage(messageContent: "OK", messageType: "sender"),
  ];
}

class ChatMessage {
  String messageContent;
  String messageType;

  ChatMessage({required this.messageContent, required this.messageType});
}
