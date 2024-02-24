import 'package:app/data/models/general_res_models/user_profile_model.dart';

class Chat {
  String? id;
  String? title;
  String? chatType;
  String? createdBy;
  String? createdAt;
  List<UserProfileModel>? deletedBy;
  List<UserProfileModel>? profile;
  SingleMessage? lastMessage;
  int? unReadCount;

  Chat({
    this.id,
    this.title,
    this.chatType,
    this.createdBy,
    this.createdAt,
    this.profile,
    this.lastMessage,
    this.deletedBy,
    this.unReadCount,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'chat_type': chatType,
      'create_by': createdBy,
      'created_at': createdAt,
      'profiles': profile?.map((x) => x.toJson()).toList(),
      'last_message': lastMessage?.toMap(),
      'deleted_by': deletedBy?.map((e) => e.toJson()).toList(),
      'unread_count': unReadCount,
    };
  }

  factory Chat.fromMap(Map<String, dynamic> map) {
    return Chat(
      id: map['id'],
      title: map['title'] ?? '',
      chatType: map['chat_type'],
      createdBy: map['create_by'],
      createdAt: map['created_at'],
      lastMessage: map['last_message'] != null ? SingleMessage.fromMap(map['last_message']) : null,
      profile: map['profiles'] != null ? List<UserProfileModel>.from(map['profiles']?.map((x) => UserProfileModel.fromJson(x))) : null,
      deletedBy: map['deleted_by'] != null && map['deleted_by'] is Map
          ? List<UserProfileModel>.from(map['deleted_by']?.map((x) => UserProfileModel.fromJson(x)))
          : null,
      unReadCount: map['unread_count'] ?? 0,
    );
  }
}

class SingleMessage {
  String? id;
  UserProfileModel? sender;
  String? chatID;
  String? message;
  String? createdAt;
  List<ChatMedia>? media;
  List<SingleMessage>? messages;
  bool? unRead;
  List<String>? deletedBy;
  List<UserProfileModel>? deliveredTo;
  SingleMessage({
    this.id,
    this.chatID,
    this.sender,
    this.message,
    this.createdAt,
    this.media,
    this.messages,
    this.unRead,
    this.deletedBy,
    this.deliveredTo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'chat': chatID,
      'profile': sender?.toJson(),
      'text': message,
      'created_at': createdAt,
      'media': media?.map((x) => x.toMap()).toList(),
      'chat_messages': messages?.map((x) => x.toMap()).toList(),
      'deleted_by': deletedBy?.map((e) => e).toList(),
    };
  }

  factory SingleMessage.fromMap(Map<String, dynamic> map) {
    return SingleMessage(
      id: map['id'],
      chatID: map['chat'],
      sender: map['profile'] != null
          ? map['profile'] is Map
              ? UserProfileModel.fromJson(map['profile'])
              : null
          : null,
      message: map['text'],
      createdAt: map['created_at'],
      media: map['media'] != null ? List<ChatMedia>.from(map['media']?.map((x) => ChatMedia.fromMap(x))) : null,
      messages: map['chat_messages'] != null && map['chat_messages'] is Map
          ? List<SingleMessage>.from(
              map['chat_messages']?.map(
                (x) => SingleMessage.fromMap(x),
              ),
            )
          : null,
      deletedBy: map['deleted_by'] != null && map['deleted_by'] is List
          ? map['deleted_by'].length > 0 && map['deleted_by'][0] is String
              ? List<String>.from(map['deleted_by'])
              : []
          : null,
      deliveredTo: map['deleted_by'] != null && map['deleted_by'] is List
          ? map['deleted_by'].length > 0 && map['deleted_by'][0] is Map
              ? List<UserProfileModel>.from(map['deleted_by'].map((x) => UserProfileModel.fromJson(x)))
              : []
          : null,
    );
  }
}

class ChatMedia {
  String? image;
  String? video;
  String? gif;
  String? audio;
  String? file;
  String? id;
  ChatMedia({
    this.image,
    this.video,
    this.gif,
    this.audio,
    this.file,
    this.id,
  });

  Map<String, dynamic> toMap() {
    return {
      'image': image,
      'video': video,
      'gif': gif,
      'audio': audio,
      'file': file,
      'id': id,
    };
  }

  factory ChatMedia.fromMap(Map<String, dynamic> map) {
    return ChatMedia(
      image: map['image'],
      video: map['video'],
      gif: map['gif'],
      audio: map['audio'],
      file: map['file'],
      id: map['id'],
    );
  }
}
