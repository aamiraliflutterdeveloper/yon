import 'dart:convert';
import 'dart:io';

import 'package:app/application/network/external_values/IExternalValues.dart';
import 'package:app/common/logger/log.dart';
import 'package:app/di/service_locator.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

class UploadDocumentsScreen extends StatefulWidget {
  final String? businessId;
  const UploadDocumentsScreen({Key? key, this.businessId}) : super(key: key);

  @override
  State<UploadDocumentsScreen> createState() => _UploadDocumentsScreenState();
}

class _UploadDocumentsScreenState extends State<UploadDocumentsScreen>
    with BaseMixin {
  File? nationalIdDoc;
  File? passportDoc;
  File? userPhoto;
  File? licenseFile;
  bool isUploading = false;

  void getDoc({required String docType}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'jpg',
        'png',
        'jpeg',
      ],
      allowMultiple: false,
    );
    if (result != null) {
      d('DOC PATH : ${result.files[0].path}');
      d('DOC NAME : ${result.files[0].name}');
      d('DOC EXTENSION : ${result.files[0].extension}');
      d('DOC IDENTIFIER : ${result.files[0].identifier}');
      d('DOC RUNTIME TYPE : ${result.files[0].runtimeType}');
      d('DOC SIZE : ${result.files[0].size}');
      if (docType == 'National') {
        setState(() {
          nationalIdDoc = File(result.files[0].path!);
        });
      } else if (docType == 'Passport') {
        setState(() {
          passportDoc = File(result.files[0].path!);
        });
      } else if (docType == 'User') {
        setState(() {
          userPhoto = File(result.files[0].path!);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Upload Documents', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Upload National ID*',
                style: CustomAppTheme()
                    .normalText
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              nationalIdDoc == null
                  ? uploadDocWidget(
                      onTab: () {
                        getDoc(docType: 'National');
                      },
                    )
                  : docWidget(docName: nationalIdDoc!.path, onDelete: () {}),
              SizedBox(
                height: med.height * 0.04,
              ),
              Text(
                'Upload Passport Image*',
                style: CustomAppTheme()
                    .normalText
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              passportDoc == null
                  ? uploadDocWidget(
                      onTab: () {
                        getDoc(docType: 'Passport');
                      },
                    )
                  : docWidget(docName: passportDoc!.path, onDelete: () {}),
              SizedBox(
                height: med.height * 0.04,
              ),
              Text(
                'Upload Your Recent Photo*',
                style: CustomAppTheme()
                    .normalText
                    .copyWith(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              userPhoto == null
                  ? uploadDocWidget(
                      onTab: () {
                        getDoc(docType: 'User');
                      },
                    )
                  : docWidget(docName: userPhoto!.path, onDelete: () {}),
              widget.businessId != null
                  ? Column(
                      children: <Widget>[
                        SizedBox(
                          height: med.height * 0.04,
                        ),
                        Text(
                          'Upload Your Company License*',
                          style: CustomAppTheme().normalText.copyWith(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        userPhoto == null
                            ? uploadDocWidget(
                                onTab: () {
                                  getDoc(docType: 'User');
                                },
                              )
                            : docWidget(
                                docName: userPhoto!.path, onDelete: () {}),
                      ],
                    )
                  : const SizedBox(),
              SizedBox(
                height: med.height * 0.04,
              ),
            ],
          ),
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
                if (nationalIdDoc != null &&
                    passportDoc != null &&
                    userPhoto != null &&
                    licenseFile != null) {
                  createAutomotiveAd();
                } else {
                  helper.showToast('Fill all the fields properly');
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
                    'Send for approval',
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

  Widget uploadDocWidget({required VoidCallback onTab}) {
    Size med = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: onTab,
      child: DottedBorder(
        borderType: BorderType.RRect,
        radius: const Radius.circular(6),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: SizedBox(
            height: med.height * 0.08,
            width: med.width * 0.2,
            child: const Center(
              child: Icon(Icons.add_circle_outline, size: 30),
            ),
          ),
        ),
      ),
    );
  }

  Widget docWidget({required VoidCallback onDelete, required docName}) {
    Size med = MediaQuery.of(context).size;
    return Container(
      height: med.height * 0.08,
      width: med.width,
      decoration: BoxDecoration(
        color: const Color(0xfffdf4f1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Row(
          children: <Widget>[
            SvgPicture.asset(
              'assets/svgs/pdfIcon.svg',
              height: med.height * 0.05,
              width: med.width * 0.15,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15),
              child: SizedBox(
                height: med.height * 0.04,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SizedBox(
                      width: med.width * 0.6,
                      child: Text(
                        docName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: CustomAppTheme().normalText.copyWith(
                            fontSize: 12, fontWeight: FontWeight.w600),
                      ),
                    ),
                    Text(
                      '805 KB',
                      style: CustomAppTheme()
                          .normalText
                          .copyWith(fontSize: 10, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SvgPicture.asset(
              'assets/svgs/deleteIcon2.svg',
              height: med.height * 0.02,
              width: med.width * 0.6,
            ),
          ],
        ),
      ),
    );
  }

  Future createAutomotiveAd() async {
    setState(() {
      isUploading = true;
    });
    IExternalValues iExternalValues = inject<IExternalValues>();
    try {
      Uri uri = Uri.parse(
          '${iExternalValues.getBaseUrl()}api/create_business_media/');
      d('create_business_media : $uri');
      var request = http.MultipartRequest("POST", uri);
      request.files.add(await http.MultipartFile.fromPath(
          'national_id', nationalIdDoc!.path));
      request.files.add(
          await http.MultipartFile.fromPath('passport', nationalIdDoc!.path));
      request.files.add(await http.MultipartFile.fromPath(
          'recent_image', nationalIdDoc!.path));
      request.headers
          .addAll({"Authorization": "Token ${iPrefHelper.retrieveToken()}"});
      http.StreamedResponse? response;
      response = await request.send();
      d('This is status code : ' + response.statusCode.toString());
      var res = await http.Response.fromStream(response);
      var decodedResponse = json.decode(res.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        helper.showToast('Request submitted');
        Navigator.pop(context);
      } else {
        d('ERROR : ' + decodedResponse['response']['message']);
        helper.showToast('Something went wrong');
        Navigator.pop(context);
      }
    } catch (e) {
      d(e);
    }
    setState(() {
      isUploading = false;
    });
  }
}
