import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'package:app/data/local_data_source/preference/i_pref_helper.dart';
import 'package:app/data/models/jobs_res_model/all_applicants_model.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shimmer/shimmer.dart';
import '../../../application/core/exceptions/exception.dart';
import '../../../application/network/error_handlers/error_handler.dart';
import '../../../common/logger/log.dart';
import 'package:http/http.dart' as http;
import 'package:open_file/open_file.dart';


class AllApplicantsView extends StatefulWidget {
  final String slug;
  const AllApplicantsView({Key? key, required this.slug}) : super(key: key);

  @override
  State<AllApplicantsView> createState() => _AllApplicantsViewState();
}

class _AllApplicantsViewState extends State<AllApplicantsView> {

  AllApplicantsModel? allApplicantsModel;
  List<Results> _foundApplicants = [];
  List<Results> _allApplicants = [];
  bool isLoading = false;
  String? path;

  Dio dio = Dio();
  IPrefHelper iPrefHelper = inject<IPrefHelper>();
  Future<AllApplicantsModel?> getAllApplicants() async {
    setState(() {
      isLoading = true;
    });

    try {
      Map<String, dynamic> map = {};
      map.addEntries({MapEntry('job', widget.slug)});
      String? token = iPrefHelper.retrieveToken();
      final responseData =
      await dio.get("https://services-dev.youonline.online/api/get_job_applied", queryParameters: map, options: Options(headers: {"Authorization": "token $token"}));
      d("this is response ${responseData.data['results']}");
      setState(() {
        allApplicantsModel = AllApplicantsModel.fromJson(responseData.data);
        _foundApplicants = allApplicantsModel!.results!;
        _allApplicants = allApplicantsModel!.results!;
        isLoading = false;
      });
      return allApplicantsModel;
    } on DioError catch (e) {
      d(e);
      final exception = getException(e);
      throw exception;
    } catch (e, t) {
      d(t);
      d(e);
      throw ResponseException(msg: e.toString());
    }
  }


  Future<void> updateResumeStatus(String jobId) async {
    try {
      Uri uri =
      Uri.parse('https://services-dev.youonline.online/api/mark_apply_job_as_view/');
      var request = http.MultipartRequest("PUT", uri);

      request.fields['job_apply_id'] = jobId;
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        d('Updated successfully');
        d(decodedResponse);
      } else {
        d('ERROR');
      }
    } catch (e) {
      d(e);
    }
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


  Future<void> initPlatformState() async {
    _setPath();
    if (!mounted) return;
  }

  void _setPath() async {
      final directory = await getExternalStorageDirectory();
      path = directory!.absolute.path;
  }

  late final TargetPlatform platform;

  final ReceivePort _port = ReceivePort();

  @override
  void initState() {
    super.initState();
    getAllApplicants();
    initPlatformState();

    IsolateNameServer.registerPortWithName(_port.sendPort, 'downloader_send_port');
    _port.listen((dynamic data) {
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];
      if(status == DownloadTaskStatus.complete) {
        print('download completed');
      } else if(status == DownloadTaskStatus.failed) {
        print(status.value);
        print("========================");
      }
      print(status.value);
      print("========================");
      setState((){ });
    });
    FlutterDownloader.registerCallback(downloadCallback);
    initPlatformState();
  }

  @override
  void dispose() {
    IsolateNameServer.removePortNameMapping('downloader_send_port');
    super.dispose();
  }

  @pragma('vm:entry-point')
  static void downloadCallback(String id, DownloadTaskStatus status, int progress) {
    final SendPort? send = IsolateNameServer.lookupPortByName('downloader_send_port');
    send?.send([id, status, progress]);
  }

  List<Results> searchApplicant(String enteredKeyword, List<Results> allApplicants) {
    List<Results> results = [];
    results = allApplicants
        .where((ad) =>
        ad.fullName!.toLowerCase().contains(enteredKeyword.toLowerCase()))
        .toList();
    return results;
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Job Applications', context: context, onTap: () {Navigator.of(context).pop();}),
      body: isLoading == true ? SizedBox(
        child: ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          padding: const EdgeInsets.only(right: 10),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(right: 10, top: 10, left: 10),
              child: SizedBox(
                height: med.height * 0.1,
                width: med.width * 0.26,
                child: Shimmer.fromColors(
                  baseColor: Colors.grey.shade200,
                  highlightColor: Colors.grey.shade50,
                  child: Container(
                    height: med.height * 0.1,
                    width: med.width * 0.26,
                    decoration: BoxDecoration(
                      color: const Color(0xfffff8d1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      )
          :
      Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 15, right: 15, left: 15),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8), topRight: Radius.circular(8)),
              border: Border(
                  left: BorderSide(color: CustomAppTheme().greyColor),
                  right: BorderSide(color: CustomAppTheme().greyColor),
                  bottom: BorderSide(color: CustomAppTheme().greyColor),
                  top: BorderSide(color: CustomAppTheme().greyColor))),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${allApplicantsModel!.count}",
                      style: CustomAppTheme().normalText.copyWith(
                          fontSize: 12,
                          color: CustomAppTheme().blackColor,
                          fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      width: 120,
                      child: TextFormField(
                        onChanged: (val) {
                         _foundApplicants = searchApplicant(val, _allApplicants);
                         setState(() {});
                        },
                        decoration: InputDecoration(
                          prefixIconConstraints: const BoxConstraints(
                              maxHeight: 20,
                              maxWidth: 30,
                              minWidth: 30,
                              minHeight: 20),
                          prefixIcon: const SizedBox(
                              height: 20, width: 20, child: Icon(Icons.search)),
                          errorBorder: OutlineInputBorder(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(6.0)),
                            borderSide:
                                BorderSide(color: CustomAppTheme().redColor),
                          ),
                          focusedErrorBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            borderSide: BorderSide(color: Color(0xffa3a8b6)),
                          ),
                          disabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            borderSide: BorderSide(color: Color(0xffa3a8b6)),
                          ),
                          isDense: true,
                          contentPadding:
                              const EdgeInsets.fromLTRB(10, 2, 10, 2),
                          hintText: "Search",
                          hintStyle:
                              const TextStyle(color: Colors.grey, fontSize: 14),
                          filled: true,
                          fillColor: Colors.white70,
                          enabledBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            borderSide: BorderSide(color: Color(0xffa3a8b6)),
                          ),
                          focusedBorder: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(6.0)),
                            borderSide: BorderSide(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Colors.black.withOpacity(.7), width: .5)),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: Get.width / 6.5,
                      child: Text(
                        "Full Name",
                        style: CustomAppTheme().normalText.copyWith(
                            fontSize: 09,
                            color: CustomAppTheme().blackColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: Get.width / 3.5,
                      child: Text(
                        "Email",
                        style: CustomAppTheme().normalText.copyWith(
                            fontSize: 09,
                            color: CustomAppTheme().blackColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: Get.width / 6,
                      child: Text(
                        "Cover Letter",
                        style: CustomAppTheme().normalText.copyWith(
                            fontSize: 09,
                            color: CustomAppTheme().blackColor,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    const SizedBox(
                      width: 9,
                    ),
                    SizedBox(
                      width: Get.width / 6,
                      child: Text(
                        "Resume",
                        style: CustomAppTheme().normalText.copyWith(
                            fontSize: 09,
                            color: CustomAppTheme().blackColor,
                            fontWeight: FontWeight.w700),
                      ),
                    )
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _foundApplicants.length,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      print("this is inside list view builder :: ${_foundApplicants.length}");
                      return _foundApplicants.isEmpty ? const Center(child: Text("No Applicants Found")) :Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 8),
                        child: Row(
                          // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: Get.width / 6.5,
                              child: Text(
                                _foundApplicants[index].fullName!,
                                style: CustomAppTheme().normalText.copyWith(
                                    fontSize: 09,
                                    color: CustomAppTheme().blackColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            SizedBox(
                              width: Get.width / 3.5,
                              child: Text(
                                _foundApplicants[index].email!,
                                style: CustomAppTheme().normalText.copyWith(
                                    fontSize: 09,
                                    color: CustomAppTheme().blackColor,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            GestureDetector(
                              onTap: () {
                                showLetter(context, _foundApplicants[index].coverLetter!);
                              },
                              child: SizedBox(
                                width: Get.width / 6,
                                child: Row(
                                  children: [
                                    Text(
                                      "Read Letter",
                                      style: CustomAppTheme().normalText.copyWith(
                                          fontSize: 09,
                                          color: const Color(0xffF48141),
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Icon(
                                      Icons.keyboard_arrow_down,
                                      color: Color(0xffF48141),
                                      size: 10,
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 9,
                            ),
                            GestureDetector(
                              onTap: () async {
                                updateResumeStatus(_foundApplicants[index].id!);
                                download(_foundApplicants[index].resume!.resumeFile!, _foundApplicants[index].resume!.resumeName!);
                              },
                              child: SizedBox(
                                width: Get.width / 6,
                                child: Text(
                                  _foundApplicants[index].resume!.resumeName!,
                                  style: CustomAppTheme().normalText.copyWith(
                                      fontSize: 09,
                                      color: const Color(0xff2070C0),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    }),
              ),
            ],
          )),
    );
  }


  void showLetter(BuildContext context, String message) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SizedBox(
            width: double.maxFinite,
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("Cover Letter",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(message,
                      style: const TextStyle(fontWeight: FontWeight.w400)),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.only(right: 10),
                    width: MediaQuery.of(context).size.width,
                    alignment: Alignment.centerRight,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text("Cancel"),
                    ),
                  )
                ]),
          ),
        );
      },
    );
  }

}
