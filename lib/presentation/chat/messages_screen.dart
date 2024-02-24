import 'dart:convert';

import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/chat/dm_screen.dart';
import 'package:app/presentation/chat/view_model/chat_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/dialogs/custom_dialog.dart';
import 'package:app/presentation/utils/shimmers/messageCardShimmer.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({Key? key}) : super(key: key);

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> with BaseMixin {
  bool isDataFetching = false;

  getUserChatList() async {
    ChatViewModel chatViewModel = context.read<ChatViewModel>();
    setState(() {
      isDataFetching = true;
    });
    await chatViewModel.getUserChatList(
        userID: iPrefHelper.retrieveUser()!.id!, context: context);
    setState(() {
      isDataFetching = false;
    });
  }

 Future<void> deleteChat({String? chatId, chatViewModel, index}) async {
    try {
      var response = await http.delete(
          Uri.parse(
              "https://services-dev.youonline.online/api/chat/delete_chat/"),
          body: {"chat": chatId},
          headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      d('response: ' + response.body.toString());
      d("Authorization: " + iPrefHelper.retrieveToken().toString());
      d("Authorization: " + iPrefHelper.retrieveUser()!.id.toString());
      d('Data: ' + chatId.toString());
      if (response.statusCode == 200) {
        chatViewModel.userChatList.removeAt(index);
        helper.showToast(
            '${jsonDecode(response.body)['response']["message"]} ..');
      } else {
        helper.showToast(
            'something went wrong ...');
        throw Exception();
      }
    } catch (e) {
      helper.showToast(
          'something went wrong ...');
    }
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getUserChatList();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ChatViewModel chatViewModel = context.watch<ChatViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        backgroundColor: CustomAppTheme().backgroundColor,
        elevation: 0,
        title: Text(
          'Messages',
          style: CustomAppTheme()
              .headingText
              .copyWith(fontSize: 20, color: CustomAppTheme().blackColor),
        ),
      ),
      body: isDataFetching
          ? ListView.builder(
              itemCount: 8,
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(vertical: 10),
              itemBuilder: (context, index) {
                return const MessageCardShimmer();
              },
            )
          : chatViewModel.userChatList.isNotEmpty
              ? ListView.builder(
                  itemCount: chatViewModel.userChatList.length,
                  shrinkWrap: true,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: GestureDetector(
                        onLongPress: () {
                          showMemberMenu(chatId: chatViewModel.userChatList[index].id!, chatViewModel: chatViewModel, index: index);
                        },
                        onTap: () {
                          d('ChAT IDD : ${chatViewModel.userChatList[index].id}');
                          chatViewModel.messageList = [];
                          chatViewModel
                              .changeMessageList(chatViewModel.messageList);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DirectMessageScreen(
                                chatId: chatViewModel.userChatList[index].id!,
                                receiver: chatViewModel.userChatList[index]
                                            .profile![0].id ==
                                        iPrefHelper.retrieveUser()!.id
                                    ? chatViewModel
                                        .userChatList[index].profile![1]
                                    : chatViewModel
                                        .userChatList[index].profile![0],
                              ),
                            ),
                          );
                        },
                        child: Container(
                          color: chatViewModel.userChatList[index].lastMessage!
                                      .unRead ==
                                  true
                              ? Colors.green.withOpacity(0.05)
                              : CustomAppTheme().backgroundColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 15, vertical: 5),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                              Container(
                                  height: med.height * 0.06,
                                  width: med.width * 0.12,
                                  decoration: BoxDecoration(
                                    color: CustomAppTheme().primaryColor,
                                    shape: BoxShape.circle,
                                    image: chatViewModel.userChatList[index]
                                                .profile![0].id ==
                                            iPrefHelper.retrieveUser()!.id
                                        ? DecorationImage(
                                            image: NetworkImage(chatViewModel
                                                .userChatList[index]
                                                .profile![1]
                                                .profilePicture
                                                .toString()),
                                            fit: BoxFit.cover)
                                        : DecorationImage(
                                            image: NetworkImage(chatViewModel
                                                .userChatList[index]
                                                .profile![0]
                                                .profilePicture
                                                .toString()),
                                            fit: BoxFit.cover),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: med.height * 0.06,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Row(
                                            children: [
                                              Text(
                                                chatViewModel
                                                            .userChatList[index]
                                                            .profile![0]
                                                            .id ==
                                                        iPrefHelper
                                                            .retrieveUser()!
                                                            .id
                                                    ? chatViewModel
                                                        .userChatList[index]
                                                        .profile![1]
                                                        .firstName!
                                                    : chatViewModel
                                                        .userChatList[index]
                                                        .profile![0]
                                                        .firstName!,
                                                style: CustomAppTheme()
                                                    .normalText
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w600),
                                              ),
                                               const SizedBox(width: 5),
                                              chatViewModel.userChatList[index]
                                                  .unReadCount! >
                                                  0
                                                  ? Container(
                                                height: med.height * 0.03,
                                                width: med.width * 0.06,
                                                decoration: BoxDecoration(
                                                  color: CustomAppTheme()
                                                      .primaryColor,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    chatViewModel
                                                        .userChatList[
                                                    index]
                                                        .unReadCount
                                                        .toString(),
                                                    style: CustomAppTheme()
                                                        .normalText
                                                        .copyWith(
                                                        fontSize: 10,
                                                        color: CustomAppTheme()
                                                            .backgroundColor,
                                                        fontWeight:
                                                        FontWeight
                                                            .w600),
                                                  ),
                                                ),
                                              )
                                                  : Container(
                                                height: med.height * 0.03,
                                                width: med.width * 0.06,
                                                decoration: BoxDecoration(
                                                  color: CustomAppTheme()
                                                      .backgroundColor,
                                                  shape: BoxShape.circle,
                                                ),
                                              ),
                                              // Row(
                                              //   mainAxisAlignment:
                                              //   MainAxisAlignment.spaceBetween,
                                              //   children: [
                                              //     // SizedBox(
                                              //     //   width: med.width * 0.65,
                                              //     //   child: Text(
                                              //     //     chatViewModel
                                              //     //         .userChatList[index]
                                              //     //         .lastMessage!
                                              //     //         .message ??
                                              //     //         "",
                                              //     //     maxLines: 1,
                                              //     //     overflow:
                                              //     //     TextOverflow.ellipsis,
                                              //     //     style: CustomAppTheme()
                                              //     //         .normalGreyText
                                              //     //         .copyWith(
                                              //     //         fontSize: 11,
                                              //     //         fontWeight:
                                              //     //         FontWeight.w500),
                                              //     //   ),
                                              //     // ),
                                              //     // chatViewModel.userChatList[index]
                                              //     //     .unReadCount! >
                                              //     //     0
                                              //     //     ? Container(
                                              //     //   height: med.height * 0.03,
                                              //     //   width: med.width * 0.06,
                                              //     //   decoration: BoxDecoration(
                                              //     //     color: CustomAppTheme()
                                              //     //         .primaryColor,
                                              //     //     shape: BoxShape.circle,
                                              //     //   ),
                                              //     //   child: Center(
                                              //     //     child: Text(
                                              //     //       chatViewModel
                                              //     //           .userChatList[
                                              //     //       index]
                                              //     //           .unReadCount
                                              //     //           .toString(),
                                              //     //       style: CustomAppTheme()
                                              //     //           .normalText
                                              //     //           .copyWith(
                                              //     //           fontSize: 10,
                                              //     //           color: CustomAppTheme()
                                              //     //               .backgroundColor,
                                              //     //           fontWeight:
                                              //     //           FontWeight
                                              //     //               .w600),
                                              //     //     ),
                                              //     //   ),
                                              //     // )
                                              //     //     : Container(
                                              //     //   height: med.height * 0.03,
                                              //     //   width: med.width * 0.06,
                                              //     //   decoration: BoxDecoration(
                                              //     //     color: CustomAppTheme()
                                              //     //         .backgroundColor,
                                              //     //     shape: BoxShape.circle,
                                              //     //   ),
                                              //     // ),
                                              //   ],
                                              // ),
                                              const Spacer(),
                                              GestureDetector(
                                                onTap: () {
                                                  showMemberMenu(chatId: chatViewModel.userChatList[index].id!, chatViewModel: chatViewModel, index: index);
                                                },
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  crossAxisAlignment: CrossAxisAlignment.end,
                                                  children: [
                                                    const Icon(Icons.more_vert),
                                                    Text(
                                                      timeago
                                                              .format(
                                                                DateTime.parse(
                                                                  chatViewModel
                                                                      .userChatList[
                                                                          index]
                                                                      .lastMessage!
                                                                      .createdAt
                                                                      .toString(),
                                                                ),
                                                              )
                                                              .contains("seconds")
                                                          ? timeago
                                                              .format(
                                                                DateTime.parse(
                                                                  chatViewModel
                                                                      .userChatList[
                                                                          index]
                                                                      .lastMessage!
                                                                      .createdAt
                                                                      .toString(),
                                                                ),
                                                              )
                                                              .replaceAll(
                                                                  "seconds", "sec")
                                                          : timeago
                                                                  .format(
                                                                    DateTime.parse(
                                                                      chatViewModel
                                                                          .userChatList[
                                                                              index]
                                                                          .lastMessage!
                                                                          .createdAt
                                                                          .toString(),
                                                                    ),
                                                                  )
                                                                  .contains("second")
                                                              ? timeago
                                                                  .format(
                                                                    DateTime.parse(
                                                                      chatViewModel
                                                                          .userChatList[
                                                                              index]
                                                                          .lastMessage!
                                                                          .createdAt
                                                                          .toString(),
                                                                    ),
                                                                  )
                                                                  .replaceAll(
                                                                      "second", "sec")
                                                              : timeago
                                                                      .format(
                                                                        DateTime
                                                                            .parse(
                                                                          chatViewModel
                                                                              .userChatList[
                                                                                  index]
                                                                              .lastMessage!
                                                                              .createdAt
                                                                              .toString(),
                                                                        ),
                                                                      )
                                                                      .contains(
                                                                          "minutes")
                                                                  ? timeago
                                                                      .format(
                                                                        DateTime
                                                                            .parse(
                                                                          chatViewModel
                                                                              .userChatList[
                                                                                  index]
                                                                              .lastMessage!
                                                                              .createdAt
                                                                              .toString(),
                                                                        ),
                                                                      )
                                                                      .replaceAll(
                                                                          "minutes",
                                                                          "mins")
                                                                  : timeago
                                                                          .format(
                                                                            DateTime
                                                                                .parse(
                                                                              chatViewModel
                                                                                  .userChatList[index]
                                                                                  .lastMessage!
                                                                                  .createdAt
                                                                                  .toString(),
                                                                            ),
                                                                          )
                                                                          .contains(
                                                                              "minute")
                                                                      ? timeago
                                                                          .format(
                                                                            DateTime
                                                                                .parse(
                                                                              chatViewModel
                                                                                  .userChatList[index]
                                                                                  .lastMessage!
                                                                                  .createdAt
                                                                                  .toString(),
                                                                            ),
                                                                          )
                                                                          .replaceAll(
                                                                              "minute",
                                                                              "min")
                                                                      : timeago
                                                                              .format(
                                                                                DateTime
                                                                                    .parse(
                                                                                  chatViewModel.userChatList[index].lastMessage!.createdAt.toString(),
                                                                                ),
                                                                              )
                                                                              .contains(
                                                                                  "months")
                                                                          ? timeago
                                                                              .format(
                                                                                DateTime
                                                                                    .parse(
                                                                                  chatViewModel.userChatList[index].lastMessage!.createdAt.toString(),
                                                                                ),
                                                                              )
                                                                              .replaceAll(
                                                                                  "months",
                                                                                  "mons")
                                                                          : timeago
                                                                                  .format(
                                                                                    DateTime.parse(
                                                                                      chatViewModel.userChatList[index].lastMessage!.createdAt.toString(),
                                                                                    ),
                                                                                  )
                                                                                  .contains(
                                                                                      "month")
                                                                              ? timeago
                                                                                  .format(
                                                                                    DateTime.parse(
                                                                                      chatViewModel.userChatList[index].lastMessage!.createdAt.toString(),
                                                                                    ),
                                                                                  )
                                                                                  .replaceAll("month",
                                                                                      "mon")
                                                                              : timeago
                                                                                  .format(
                                                                                  DateTime.parse(
                                                                                    chatViewModel.userChatList[index].lastMessage!.createdAt.toString(),
                                                                                  ),
                                                                                ),
                                                      style: CustomAppTheme()
                                                          .normalGreyText
                                                          .copyWith(
                                                              fontSize: 11,
                                                              fontWeight:
                                                                  FontWeight.w500),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                          // Row(
                                          //   mainAxisAlignment:
                                          //       MainAxisAlignment.spaceBetween,
                                          //   children: [
                                          //     SizedBox(
                                          //       width: med.width * 0.65,
                                          //       child: Text(
                                          //         chatViewModel
                                          //                 .userChatList[index]
                                          //                 .lastMessage!
                                          //                 .message ??
                                          //             "",
                                          //         maxLines: 1,
                                          //         overflow:
                                          //             TextOverflow.ellipsis,
                                          //         style: CustomAppTheme()
                                          //             .normalGreyText
                                          //             .copyWith(
                                          //                 fontSize: 11,
                                          //                 fontWeight:
                                          //                     FontWeight.w500),
                                          //       ),
                                          //     ),
                                          //     chatViewModel.userChatList[index]
                                          //                 .unReadCount! >
                                          //             0
                                          //         ? Container(
                                          //             height: med.height * 0.03,
                                          //             width: med.width * 0.06,
                                          //             decoration: BoxDecoration(
                                          //               color: CustomAppTheme()
                                          //                   .primaryColor,
                                          //               shape: BoxShape.circle,
                                          //             ),
                                          //             child: Center(
                                          //               child: Text(
                                          //                 chatViewModel
                                          //                     .userChatList[
                                          //                         index]
                                          //                     .unReadCount
                                          //                     .toString(),
                                          //                 style: CustomAppTheme()
                                          //                     .normalText
                                          //                     .copyWith(
                                          //                         fontSize: 10,
                                          //                         color: CustomAppTheme()
                                          //                             .backgroundColor,
                                          //                         fontWeight:
                                          //                             FontWeight
                                          //                                 .w600),
                                          //               ),
                                          //             ),
                                          //           )
                                          //         : Container(
                                          //             height: med.height * 0.03,
                                          //             width: med.width * 0.06,
                                          //             decoration: BoxDecoration(
                                          //               color: CustomAppTheme()
                                          //                   .backgroundColor,
                                          //               shape: BoxShape.circle,
                                          //             ),
                                          //           ),
                                          //   ],
                                          // ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                /*const Spacer(),
                            SizedBox(
                              height: med.height * 0.06,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    Text(
                                      timeago.format(
                                        DateTime.parse(
                                          chatViewModel.userChatList[index].lastMessage!.createdAt.toString(),
                                        ),
                                      ),
                                      style: CustomAppTheme().normalGreyText.copyWith(fontSize: 11, fontWeight: FontWeight.w500),
                                    ),
                                    chatViewModel.userChatList[index].unReadCount! > 0
                                        ? Container(
                                            height: med.height * 0.03,
                                            width: med.width * 0.06,
                                            decoration: BoxDecoration(
                                              color: CustomAppTheme().primaryColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Center(
                                              child: Text(
                                                chatViewModel.userChatList[index].unReadCount.toString(),
                                                style: CustomAppTheme()
                                                    .normalText
                                                    .copyWith(fontSize: 10, color: CustomAppTheme().backgroundColor, fontWeight: FontWeight.w600),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            height: med.height * 0.03,
                                            width: med.width * 0.06,
                                            decoration: BoxDecoration(
                                              color: CustomAppTheme().backgroundColor,
                                              shape: BoxShape.circle,
                                            ),
                                          ),
                                  ],
                                ),
                              ),
                            ),*/
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                )
              : Column(
                  children: [
                    SizedBox(
                      height: med.height * 0.1,
                    ),
                    Center(
                      child: Text(
                        "You don't have any chat in your inbox",
                        style: CustomAppTheme().normalGreyText.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    )
                  ],
                ),
    );
  }

  bool isLoading = false;

  void showMemberMenu({required String chatId, required ChatViewModel chatViewModel, required int index}) async {
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
                    title: 'Are you sure, you want to delete this chat.?',
                    rightButtonText: 'Delete',
                    cancelCallBack: () {
                      Get.back();
                      Get.back();
                    },
                    blockCallBack: () async {
                      setState(() {
                        isLoading = true;
                      });
                      CustomDialog.showAlertDialog();

                      final response = await deleteChat(
                          chatId: chatViewModel.userChatList[index].id!,
                          chatViewModel: chatViewModel,
                          index: index).then((value) {
                        print("=============");
                        setState(() {
                          isLoading = false;
                          Get.back();
                          Get.back();
                          Get.back();
                        });
                      });
                      // Get.back();
                      // Get.back();
                    });
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

}
