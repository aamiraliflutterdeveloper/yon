import 'dart:convert';
import 'dart:io';

import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/profile/widgets/resume_widget.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class SavedResumeScreen extends StatefulWidget {
  const SavedResumeScreen({Key? key}) : super(key: key);

  @override
  State<SavedResumeScreen> createState() => _SavedResumeScreenState();
}

class _SavedResumeScreenState extends State<SavedResumeScreen> with BaseMixin {
  bool isDataFetching = false;

  getMyResume() async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await profileViewModel.getMyResumes();
    result.fold((l) {}, (r) {
      profileViewModel.changeMyResumeList(r.resumeList!);
    });
    setState(() {
      isDataFetching = false;
    });
  }

  deleteMyResume({String? resumeId}) async {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    try {
      var response = await http.delete(
          Uri.parse("https://services-dev.youonline.online/api/delete_resume/"),
          body: {"id": resumeId},
          headers: {"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      d('Resume Response : ' + response.body.toString());
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print("Api Response: $jsonData");
      } else {
        throw Exception();
      }
    } catch (e) {}
    setState(() {});
  }

  String? path;
  bool isUploading = false;

  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
    final directory = await getExternalStorageDirectory();
    // return directory.absolute.path;
    path = directory!.absolute.path;
    // Directory _path = await getApplicationDocumentsDirectory();
    // String _localPath = _path.path + Platform.pathSeparator + 'Download';
    // final savedDir = Directory(_localPath);
    // bool hasExisted = await savedDir.exists();
    // if (!hasExisted) {
    //   savedDir.create();
    // }
    // path = _localPath;
    // d('PATH ::: $path');
  }

  late final TargetPlatform platform;

  @override
  void initState() {
    ProfileViewModel profileViewModel = context.read<ProfileViewModel>();
    super.initState();
    if (profileViewModel.myResumeList.isEmpty) {
      getMyResume();
    }

    initPlatformState();
  }

  // New Code Written
  Future download(String url, String name) async {
    const permission = Permission.storage;
    var status = await permission.status;
    if(status != PermissionStatus.granted) {
      await permission.request();
      File file = File("$path$name");
      // print(file);
      // print("hahahahahaha dekltede");
      // _deleteCacheDir();
      // if(await file.exists()) {
      //   // _deleteCacheDir();
      //   OpenFile.open(file.path);
      //   // } else {
      // } else {
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        savedDir: path!,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
        fileName: "$name${DateTime.now().millisecond.toString().replaceAll(" ", "")}",
      );
      // }
      // if(taskId != null) {
      //   FlutterDownloader.open(taskId: taskId);
      // }
    } else {
      // print("yahoooooooooooooooooooooooo");
      // File file = File("$path$name");
      // print(file);
      // if(file != null) {
      //   // OpenFile.open("/sdcard/example.txt");
      // }
      // print("yahoooooooooooooooooooooooo");
      final taskId = await FlutterDownloader.enqueue(
        url: url,
        headers: {},
        savedDir: path!,
        showNotification: true,
        openFileFromNotification: true,
        saveInPublicStorage: true,
        fileName: "$name${DateTime.now().millisecond.toString().replaceAll(" ", "")}",
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Saved Resume', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: med.height * 0.02,
            ),
            Expanded(
              child: isDataFetching
                  ? ListView.builder(
                      itemCount: 4,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Shimmer.fromColors(
                            baseColor: CustomAppTheme().lightGreyColor,
                            highlightColor: CustomAppTheme().backgroundColor,
                            child: Container(
                              height: med.height * 0.08,
                              width: med.width,
                              decoration: BoxDecoration(
                                color: CustomAppTheme().lightGreyColor,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : profileViewModel.myResumeList.isEmpty
                      ? SizedBox(
                          height: 450, child: Center(child: noDataFound()))
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${profileViewModel.myResumeList.length} Saved Resume',
                              style: CustomAppTheme().headingText.copyWith(
                                  fontSize: 20,
                                  color: CustomAppTheme().blackColor),
                            ),
                            SizedBox(
                              height: med.height * 0.02,
                            ),
                            ListView.builder(
                              itemCount: profileViewModel.myResumeList.length,
                              shrinkWrap: true,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: GestureDetector(
                                    onTap: () async {
                                      download(profileViewModel.myResumeList[index].resumeFile!, profileViewModel.myResumeList[index].resumeName!);
                                  },
                                    child: ResumeWidget(
                                      docTitle: profileViewModel
                                          .myResumeList[index].resumeName
                                          .toString(),
                                      onDelete: () {
                                        deleteMyResume(
                                            resumeId: profileViewModel
                                                .myResumeList[index].id
                                                .toString());
                                        profileViewModel.myResumeList
                                            .removeAt(index);
                                        setState(() {});
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isUploading
          ? SizedBox(
              height: med.height * 0.05,
              width: med.width * 0.44,
              child: Center(
                child: CircularProgressIndicator(
                    color: CustomAppTheme().primaryColor),
              ),
            )
          : GestureDetector(
              onTap: () async {
                FilePickerResult? result = await FilePicker.platform.pickFiles(
                  type: FileType.custom,
                  allowedExtensions: ['pdf', 'doc'],
                  allowMultiple: false,
                );
                if (result != null) {
                  d('RESUME PATH : ${result.files[0].path}');
                  d('RESUME NAME : ${result.files[0].name}');
                  d('RESUME EXTENSION : ${result.files[0].extension}');
                  d('RESUME IDENTIFIER : ${result.files[0].identifier}');
                  d('RESUME RUNTIME TYPE : ${result.files[0].runtimeType}');
                  d('RESUME SIZE : ${result.files[0].size}');
                  setState(() {
                    isUploading = true;
                  });
                  await profileViewModel.uploadResume(
                    resumePath: result.files[0].path!,
                    resumeName: result.files[0].name,
                    extension: result.files[0].extension!,
                  );
                  setState(() {
                    isUploading = false;
                  });
                }
              },
              child: Container(
                height: med.height * 0.055,
                width: med.width * 0.85,
                decoration: BoxDecoration(
                  color: CustomAppTheme().primaryColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    'Upload New Resume',
                    style: CustomAppTheme().normalText.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: CustomAppTheme().backgroundColor),
                  ),
                ),
              ),
            ),
    );
  }
}
