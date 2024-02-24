import 'package:app/data/models/general_res_models/user_profile_model.dart';

class ChatSocketResModel {
  String? type;
  Message? message;

  ChatSocketResModel({type, message});

  ChatSocketResModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    message = json['message'] != null ? Message.fromJson(json['message']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (message != null) {
      data['message'] = message!.toJson();
    }
    return data;
  }
}

class Message {
  String? chatId;
  String? text;
  UserProfileModel? sender;
  String? receiverId;

  Message({chatId, text, profile, receiver});

  Message.fromJson(Map<String, dynamic> json) {
    chatId = json['chat_id'] ?? "";
    text = json['text'] ?? "";
    sender = json['profile'] != null ? UserProfileModel.fromJson(json['profile']) : UserProfileModel();
    receiverId = json['receiver'] ?? "";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['chat_id'] = chatId;
    data['text'] = text;
    if (sender != null) {
      data['profile'] = sender!.toJson();
    }
    data['receiver'] = receiverId;
    return data;
  }
}
