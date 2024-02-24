import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/chat/chat_models.dart';
import 'package:app/data/models/chat/single_user_chat_res_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class ChatViewModel extends ChangeNotifier {
  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  IExternalValues iExternalValues = inject<IExternalValues>();
  Dio dio = Dio();

  List<Chat> userChatList = [];

  changeUserChatList(List<Chat> newUserChatList) {
    userChatList = newUserChatList;
    notifyListeners();
  }

  Future getUserChatList({
    required String userID,
    required BuildContext context,
  }) async {
    await dio
        .get(
      '${iExternalValues.getBaseUrl()}api/chat/get_user_chatslist/?profile=$userID',
      options: Options(
        headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"},
      ),
    )
        .then(
      (value) {
        userChatList = [];
        d('Status Code : ${value.statusCode}');
        d('VALUE : $value');
        if (value.statusCode == 200 || value.statusCode == 201) {
          value.data['response'].forEach((element) {
            userChatList.add(Chat.fromMap(element));
          });
        }
        changeUserChatList(userChatList);
      },
    );
  }

  Future sendMessage({
    required String receiverId,
    required String chatId,
    required String textMessage,
    required BuildContext context,
  }) async {
    d('This is receiverId ::::: $receiverId');
    await dio
        .post(
      '${iExternalValues.getBaseUrl()}api/chat/send_chat_message/',
      data: {
        'profile': receiverId,
        'chat': chatId,
        'text': textMessage,
      },
      options: Options(
        headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"},
      ),
    )
        .then(
      (value) {
        d('SEND MESSAGE STATUS CODE : ${value.statusCode}');
        d('SEND MESSAGE DATA : ${value.data}');
        if (value.statusCode == 200 || value.statusCode == 201) {}
      },
    );
  }

  Future<Chat> startChat({
    required String receiverId,
    required BuildContext context,
  }) async {
    Chat chat = Chat();
    await dio
        .post(
      '${iExternalValues.getBaseUrl()}api/chat/start_individual_chat/',
      data: {
        'profile2': receiverId,
      },
      options: Options(
        headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"},
      ),
    )
        .then(
      (value) {
        d('START CHAT STATUS CODE : ${value.statusCode}');
        d('START CHAT DATA : ${value.data}');
        if (value.statusCode == 201 || value.statusCode == 200) {
          chat = Chat.fromMap(value.data['response']);
          d('chatchatchatchat : ${chat.id}');
          userChatList.add(Chat.fromMap(value.data['response']));
        }
        changeUserChatList(userChatList);
      },
    );
    return chat;
  }

  List<SingleMessage> messageList = [];

  changeMessageList(List<SingleMessage> updatedMessageList) {
    messageList = updatedMessageList;
    notifyListeners();
  }

  Future<SingleUserChatResModel> getSingleUserMessageList({
    required String userID,
    required String chatId,
    required BuildContext context,
  }) async {
    SingleUserChatResModel chatList = SingleUserChatResModel();
    await dio
        .get(
      '${iExternalValues.getBaseUrl()}api/chat/get_chat/?chat=$chatId&profile=$userID',
      options: Options(
        headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"},
      ),
    )
        .then(
      (value) {
        d('Status Code : ${value.statusCode}');
        if (value.statusCode == 200 || value.statusCode == 201) {
          chatList = SingleUserChatResModel.fromJson(value.data);
          d('chatList :: $chatList');
        }
      },
    );
    return chatList;
  }
}
