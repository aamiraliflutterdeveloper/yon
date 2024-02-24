class ImageMedia {
  String? id;
  String? image;

  ImageMedia({id, image});

  ImageMedia.fromJson(Map<String, dynamic> json) {
    id = json['id']??"";
    image = json['image']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['image'] = image;
    return data;
  }
}

class VideoMedia {
  String? id;
  String? video;
  String? videoThumbnail;

  VideoMedia({id, video, videoThumbnail});

  VideoMedia.fromJson(Map<String, dynamic> json) {
    id = json['id']??"";
    video = json['video']??"";
    videoThumbnail = json['video_thumbnail']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['video'] = video;
    data['video_thumbnail'] = videoThumbnail;
    return data;
  }
}