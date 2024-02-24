class MyResumeResModel {
  bool? success;
  List<ResumeModel>? resumeList;

  MyResumeResModel({success, response});

  MyResumeResModel.fromJson(Map<String, dynamic> json) {
    success = json['success'];
    if (json['response'] != null) {
      resumeList = <ResumeModel>[];
      json['response'].forEach((v) {
        resumeList!.add(ResumeModel.fromJson(v));
      });
    }else{
      resumeList = <ResumeModel>[];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['success'] = success;
    if (resumeList != null) {
      data['response'] = resumeList!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResumeModel {
  String? id;
  String? resumeFile;
  String? resumeName;
  String? resumeExtension;

  ResumeModel({id, resumeFile, resumeName, resumeExtension});

  ResumeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    resumeFile = json['resume_file'];
    resumeName = json['resume_name'];
    resumeExtension = json['resume_extension'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id ?? "";
    data['resume_file'] = resumeFile ?? "";
    data['resume_name'] = resumeName ?? "";
    data['resume_extension'] = resumeExtension ?? "";
    return data;
  }
}
