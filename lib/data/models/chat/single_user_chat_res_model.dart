import 'package:app/data/models/chat/chat_models.dart';

class SingleUserChatResModel {
  int? count;
  int? perPageResult;
  List<SingleMessage>? messageList;

  SingleUserChatResModel({this.count, this.perPageResult, this.messageList});

  SingleUserChatResModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    perPageResult = json['per_page_result'];
    if (json['results'] != null) {
      messageList = <SingleMessage>[];
      json['results'].forEach((v) {
        messageList!.add(SingleMessage.fromMap(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['per_page_result'] = perPageResult;
    if (messageList != null) {
      data['results'] = messageList!.map((v) => v.toMap()).toList();
    }
    return data;
  }
}
