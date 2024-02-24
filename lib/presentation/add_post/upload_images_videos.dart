import 'dart:io';
import 'dart:math';

import 'package:app/common/logger/log.dart';
import 'package:app/data/models/automotive_models/automotive_ads_res_model.dart';
import 'package:app/data/models/classified_res_models/classified_ads_res_model.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/data/models/properties_res_models/property_ads_res_model.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/automotive_include_details.dart';
import 'package:app/presentation/add_post/classified_include_detail_screen.dart';
import 'package:app/presentation/add_post/job_include_detail_screen.dart';
import 'package:app/presentation/add_post/properties_include_some_details.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/on_boarding/widgets/custom_page_route.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:chewie/chewie.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class UploadImagesVideosScreen extends StatefulWidget {
  final int categoryIndex;
  final ClassifiedProductModel? classifiedEditProduct;
  final AutomotiveProductModel? automotiveEditProduct;
  final PropertyProductModel? propertyEditProduct;
  final JobProductModel? jobEditModel;
  final bool? isEdit;

  const UploadImagesVideosScreen(
      {Key? key,
      required this.categoryIndex,
      this.isEdit = false,
      this.classifiedEditProduct,
      this.automotiveEditProduct,
      this.propertyEditProduct,
      this.jobEditModel})
      : super(key: key);

  @override
  State<UploadImagesVideosScreen> createState() =>
      _UploadImagesVideosScreenState();
}

class _UploadImagesVideosScreenState extends State<UploadImagesVideosScreen>
    with BaseMixin {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? listOfImages = [];
  List<String>? editImages = [];
  List<String>? removedImageID = [];

  String videoThumbnail = '';
  bool isVideo = false;

  editClassifiedMedia() {
    if (widget.classifiedEditProduct!.imageMedia!.isEmpty) {
      editImages!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0;
          i < widget.classifiedEditProduct!.imageMedia!.length;
          i++) {
        editImages!.add(widget.classifiedEditProduct!.imageMedia![i].image!);
      }
    }
    if (widget.classifiedEditProduct!.videoMedia!.isNotEmpty) {
      initializeVideo(
          widget.classifiedEditProduct!.videoMedia![0].video.toString());
      videoThumbnail =
          widget.classifiedEditProduct!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
  }

  editAutomotiveMedia() {
    if (widget.automotiveEditProduct!.imageMedia!.isEmpty) {
      editImages!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0;
          i < widget.automotiveEditProduct!.imageMedia!.length;
          i++) {
        editImages!.add(widget.automotiveEditProduct!.imageMedia![i].image!);
      }
    }
    if (widget.automotiveEditProduct!.videoMedia!.isNotEmpty) {
      initializeVideo(
          widget.automotiveEditProduct!.videoMedia![0].video.toString());
      videoThumbnail =
          widget.automotiveEditProduct!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
  }

  editPropertyMedia() {
    if (widget.propertyEditProduct!.imageMedia!.isEmpty) {
      editImages!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0; i < widget.propertyEditProduct!.imageMedia!.length; i++) {
        editImages!.add(widget.propertyEditProduct!.imageMedia![i].image!);
      }
    }
    if (widget.propertyEditProduct!.videoMedia!.isNotEmpty) {
      initializeVideo(
          widget.propertyEditProduct!.videoMedia![0].video.toString());
      videoThumbnail =
          widget.propertyEditProduct!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
  }

  editJobMedia() {
    if (widget.jobEditModel!.imageMedia!.isEmpty) {
      editImages!.add(
          'https://t3.ftcdn.net/jpg/04/62/93/66/360_F_462936689_BpEEcxfgMuYPfTaIAOC1tCDurmsno7Sp.jpg');
    } else {
      for (int i = 0; i < widget.jobEditModel!.imageMedia!.length; i++) {
        editImages!.add(widget.jobEditModel!.imageMedia![i].image!);
      }
    }
    if (widget.jobEditModel!.videoMedia!.isNotEmpty) {
      initializeVideo(widget.jobEditModel!.videoMedia![0].video.toString());
      videoThumbnail = widget.jobEditModel!.videoMedia![0].videoThumbnail!;
      isVideo = true;
    }
  }

  bool validateImage(String data) {
    bool returnData = false;

    return returnData;
  }

  void selectImages() async {
    List<XFile>? images = await imagePicker.pickMultiImage();

    if ((images.length + listOfImages!.length) > 20) {
      helper.showToast('can\'t upload more than 20 images');
    } else {
      for (int i = 0; i < images.length; i++) {
        File file = File(images[i].path);
        int sizeInBytes = file.lengthSync();
        double sizeInMb = sizeInBytes / (1024 * 1024);
        print('IMAGE SIZE : $sizeInMb');
        if (sizeInMb > 3) {
          print('$i size is $sizeInMb');
          helper.showLongToast('${images[i].name} is more than 3 MB');

          images.removeAt(i);
        } else {
          if (widget.categoryIndex == 3) {
            listOfImages = [images[0]];
          } else {
            listOfImages!.insert(0, images[i]);
          }
        }
        // if ((validateImage(
        //     getFileSizeString(bytes: File(images[i].path).lengthSync())))) {
        //   listOfImages!.insert(0, images[i]);
        // } else {
        //   d('IMAGES ::: ' + images.toString());
        //   helper.showLongToast('can\'t upload more than 3 MB image');
        // }
      }
      d('LIST OF IMAGES : ' + listOfImages.toString());
      setState(() {});
    }
  }

  void selectEditImages() async {
    List<XFile>? images = await imagePicker.pickMultiImage();
    d('IMAGES ::: ' + images.toString());
    for (int i = 0; i < images.length; i++) {
      listOfImages!.insert(0, images[i]);
      editImages!.insert(0, images[i].path);
    }
    d('LIST OF IMAGES : ' + editImages.toString());
    setState(() {});
  }

  /// Video picker
  bool isVideoUploading = false;
  File? videoFile;
  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    if (widget.isEdit == true) {
      if (widget.categoryIndex == 0) {
        editClassifiedMedia();
      } else if (widget.categoryIndex == 1) {
        editPropertyMedia();
      } else if (widget.categoryIndex == 2) {
        editAutomotiveMedia();
      } else if (widget.categoryIndex == 3) {
        editJobMedia();
      }
    }
  }

  @override
  void dispose() {
    chewieController?.dispose();
    videoPlayerController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Step 1 of 4', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: widget.isEdit == false
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleWithText(
                      title: widget.categoryIndex == 3
                          ? "Upload Company Logo*"
                          : 'Upload Images*',
                      text: widget.categoryIndex == 3
                          ? "Upload Company Logo image"
                          : 'Upload maximum 20 images'),
                  SizedBox(
                    height: med.height * 0.03,
                  ),
                  listOfImages == null || listOfImages!.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            selectImages();
                          },
                          child: dotedBorderWidget(
                              context: context,
                              svgUrl: 'assets/svgs/images.svg',
                              buttonText: 'Upload Photos',
                              centerText: widget.categoryIndex == 3
                                  ? "Upload Company Logo"
                                  : 'Upload maximum 20 images'),
                        )
                      : Container(
                          constraints: BoxConstraints(
                              maxHeight: med.height * 0.25,
                              minHeight: med.height * 0.12),
                          child: GridView.builder(
                            itemCount: widget.categoryIndex == 3
                                ? 1
                                : listOfImages!.length + 1,
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 97,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return index == listOfImages!.length
                                  ? GestureDetector(
                                      onTap: () {
                                        selectImages();
                                      },
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(6),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: SizedBox(
                                            height: med.height * 0.12,
                                            width: med.width * 0.25,
                                            child: const Center(
                                              child: Icon(
                                                  Icons.add_circle_outline,
                                                  size: 30),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: med.height * 0.12,
                                      width: med.width * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: CustomAppTheme().greyColor,
                                        image: DecorationImage(
                                            image: FileImage(File(
                                                listOfImages![index].path)),
                                            fit: BoxFit.cover),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                listOfImages!.removeAt(index);
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/svgs/deleteIcon2.svg',
                                              height: med.height * 0.02,
                                              width: med.width * 0.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                        ),
                  // SizedBox(
                  //   height: med.height * 0.06,
                  // ),
                  // titleOptionWithText(
                  //     title: 'Upload Video',
                  //     text: 'Upload maximum 25 MB video'),
                  // SizedBox(
                  //   height: med.height * 0.03,
                  // ),
                  // videoFile != null
                  //     ? Stack(
                  //         children: <Widget>[
                  //           chewieController != null
                  //               ? Container(
                  //                   height: med.height * 0.12,
                  //                   width: med.width * 0.25,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     color: CustomAppTheme().blackColor,
                  //                   ),
                  //                   child: ClipRRect(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     child: AspectRatio(
                  //                       aspectRatio: videoPlayerController!
                  //                           .value.aspectRatio,
                  //                       child: Chewie(
                  //                         controller: chewieController!,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 )
                  //               : Container(
                  //                   height: med.height * 0.12,
                  //                   width: med.width * 0.25,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     color: CustomAppTheme().blackColor,
                  //                   ),
                  //                   child: Center(
                  //                     child: CircularProgressIndicator(
                  //                         color:
                  //                             CustomAppTheme().secondaryColor),
                  //                   ),
                  //                 ),
                  //         ],
                  //       )
                  //     : GestureDetector(
                  //         onTap: () async {
                  //           FilePickerResult result;
                  //           try {
                  //             result = (await FilePicker.platform.pickFiles(
                  //               allowCompression: true,
                  //               allowMultiple: false,
                  //               type: FileType.video,
                  //             ))!;
                  //           } catch (e) {
                  //             rethrow;
                  //           }
                  //           if (result.files.isNotEmpty) {
                  //             File file = File(result.files[0].path!);
                  //             int sizeInBytes = file.lengthSync();
                  //             double sizeInMb = sizeInBytes / (1024 * 1024);
                  //             d('VIDEO SIZE : $sizeInMb');
                  //             if (sizeInMb > 25) {
                  //               helper.showToast(
                  //                   'Selected video size is more than 25 MB');
                  //             } else {
                  //               setState(() {
                  //                 isVideoUploading = true;
                  //               });
                  //               try {
                  //                 videoFile = File(result.files[0].path!);
                  //                 d('VIDEO PATH : ' + videoFile.toString());
                  //                 final uint8list =
                  //                     await VideoThumbnail.thumbnailData(
                  //                   video: result.files[0].path!,
                  //                   imageFormat: ImageFormat.JPEG,
                  //                   maxWidth:
                  //                       128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                  //                   quality: 25,
                  //                 );
                  //                 var thumbnail = File('image.jpg')
                  //                     .writeAsBytes(uint8list!);
                  //                 videoPlayerController = VideoPlayerController
                  //                     .file(videoFile!)
                  //                   ..initialize().then(
                  //                     (value) {
                  //                       setState(
                  //                         () {
                  //                           chewieController = ChewieController(
                  //                             videoPlayerController:
                  //                                 videoPlayerController!,
                  //                             autoInitialize: true,
                  //                             autoPlay: true,
                  //                             looping: false,
                  //                             showOptions: true,
                  //                             materialProgressColors:
                  //                                 ChewieProgressColors(
                  //                                     backgroundColor:
                  //                                         CustomAppTheme()
                  //                                             .primaryColor,
                  //                                     playedColor:
                  //                                         CustomAppTheme()
                  //                                             .primaryColor
                  //                                             .withOpacity(1.0),
                  //                                     handleColor:
                  //                                         CustomAppTheme()
                  //                                             .primaryColor),
                  //                             showControls: true,
                  //                             allowMuting: true,
                  //                             allowFullScreen: false,
                  //                             useRootNavigator: false,
                  //                             fullScreenByDefault: false,
                  //                             showControlsOnInitialize: false,
                  //                             zoomAndPan: false,
                  //                             errorBuilder: (
                  //                               context,
                  //                               errorMessage,
                  //                             ) {
                  //                               return Center(
                  //                                 child: Text(
                  //                                   errorMessage,
                  //                                 ),
                  //                               );
                  //                             },
                  //                           );
                  //                         },
                  //                       );
                  //                     },
                  //                   ).then((value) {
                  //                     setState(() {
                  //                       isVideoUploading = false;
                  //                     });
                  //                   });
                  //               } catch (e) {
                  //                 rethrow;
                  //               }
                  //             }
                  //           }
                  //         },
                  //         child: dotedBorderWidget(
                  //             context: context,
                  //             svgUrl: 'assets/svgs/videoIcon.svg',
                  //             buttonText: 'Upload Video',
                  //             centerText: 'Upload maximum 25 MB video'),
                  //       ),

                  const Spacer(),
                  SizedBox(
                    width: med.width,
                    child: YouOnlineButton(
                        text: 'Next',
                        onTap: () {
                          if (listOfImages!.isNotEmpty) {
                            if (widget.categoryIndex == 0) {
                              ClassifiedObject classifiedData =
                                  createAdPostViewModel.classifiedAdData!;
                              classifiedData.images = listOfImages;
                              if (videoFile != null) {
                                classifiedData.video = videoFile!;
                              }
                              createAdPostViewModel
                                  .changeClassifiedAdData(classifiedData);
                              chewieController?.pause();
                              videoPlayerController?.pause();
                              d('CLASSIFIED AD DATA : ' +
                                  createAdPostViewModel
                                      .classifiedAdData!.categoryId
                                      .toString());
                              d('CLASSIFIED IMAGES : ' +
                                  createAdPostViewModel.classifiedAdData!.images
                                      .toString());
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: ClassifiedIncludeDetailScreen(
                                          categoryIndex: widget.categoryIndex),
                                      direction: AxisDirection.left));
                            } else if (widget.categoryIndex == 1) {
                              PropertiesObject propertyData =
                                  createAdPostViewModel.propertyAdData!;
                              propertyData.images = listOfImages;
                              if (videoFile != null) {
                                propertyData.video = videoFile!;
                              }
                              createAdPostViewModel
                                  .changePropertyAdData(propertyData);
                              d('PROPERTIES AD DATA : ' +
                                  createAdPostViewModel
                                      .propertyAdData!.categoryId
                                      .toString());
                              d('PROPERTIES IMAGES : ' +
                                  createAdPostViewModel.propertyAdData!.images
                                      .toString());
                              chewieController?.pause();
                              videoPlayerController?.pause();
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: PropertiesIncludeDetail(
                                          categoryIndex: widget.categoryIndex),
                                      direction: AxisDirection.left));
                            } else if (widget.categoryIndex == 2) {
                              AutomotiveObject automotiveData =
                                  createAdPostViewModel.automotiveAdData!;
                              automotiveData.images = listOfImages;
                              if (videoFile != null) {
                                automotiveData.video = videoFile!;
                              }
                              createAdPostViewModel
                                  .changeAutomotiveAdData(automotiveData);
                              d('AUTOMOTIVE AD DATA : ' +
                                  createAdPostViewModel
                                      .automotiveAdData!.categoryId
                                      .toString());
                              d('AUTOMOTIVE IMAGES : ' +
                                  createAdPostViewModel.automotiveAdData!.images
                                      .toString());
                              chewieController?.pause();
                              videoPlayerController?.pause();
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: AutomotiveIncludeDetails(
                                          categoryIndex: widget.categoryIndex),
                                      direction: AxisDirection.left));
                            } else if (widget.categoryIndex == 3) {
                              JobObject jobData =
                                  createAdPostViewModel.jobAdData!;
                              jobData.images = listOfImages;
                              if (videoFile != null) {
                                jobData.video = videoFile!;
                              }
                              createAdPostViewModel.changeJobAdData(jobData);
                              d('JOB AD DATA : ' +
                                  createAdPostViewModel.jobAdData!.categoryId
                                      .toString());
                              d('JOB IMAGES : ' +
                                  createAdPostViewModel.jobAdData!.images
                                      .toString());
                              chewieController?.pause();
                              videoPlayerController?.pause();
                              Navigator.push(
                                  context,
                                  CustomPageRoute(
                                      child: JobIncludeDetail(
                                          categoryIndex: widget.categoryIndex),
                                      direction: AxisDirection.left));
                            }
                          } else {
                            helper
                                .showToast('Please upload at least one image!');
                          }
                        }),
                  ),
                  SizedBox(
                    height: med.height * 0.05,
                  ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  titleWithText(
                      title: widget.categoryIndex == 3
                          ? "Upload Company Logo*"
                          : 'Upload Images*',
                      text: widget.categoryIndex == 3
                          ? "Upload Company Logo image"
                          : 'Upload maximum 20 images'),
                  SizedBox(
                    height: med.height * 0.03,
                  ),
                  editImages == null || editImages!.isEmpty
                      ? GestureDetector(
                          onTap: () {
                            selectImages();
                          },
                          child: dotedBorderWidget(
                              context: context,
                              svgUrl: 'assets/svgs/images.svg',
                              buttonText: 'Upload Photos',
                              centerText: widget.categoryIndex == 3
                                  ? "Upload Company Logo"
                                  : 'Upload maximum 20 images'),
                        )
                      : Container(
                          constraints: BoxConstraints(
                              maxHeight: med.height * 0.25,
                              minHeight: med.height * 0.12),
                          child: GridView.builder(
                            itemCount: widget.categoryIndex == 3
                                ? 1
                                : editImages!.length + 1,
                            padding: const EdgeInsets.symmetric(vertical: 5),
                            shrinkWrap: true,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 97,
                              childAspectRatio: 1.0,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 20,
                            ),
                            itemBuilder: (context, index) {
                              return index == editImages!.length
                                  ? GestureDetector(
                                      onTap: () {
                                        selectEditImages();
                                      },
                                      child: DottedBorder(
                                        borderType: BorderType.RRect,
                                        radius: const Radius.circular(6),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          child: SizedBox(
                                            height: med.height * 0.12,
                                            width: med.width * 0.25,
                                            child: const Center(
                                              child: Icon(
                                                  Icons.add_circle_outline,
                                                  size: 30),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  : Container(
                                      height: med.height * 0.12,
                                      width: med.width * 0.25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        color: CustomAppTheme().greyColor,
                                        image: editImages![index]
                                                .contains('https')
                                            ? DecorationImage(
                                                image: NetworkImage(
                                                    editImages![index]),
                                                fit: BoxFit.cover,
                                              )
                                            : DecorationImage(
                                                image: FileImage(
                                                    File(editImages![index])),
                                                fit: BoxFit.cover,
                                              ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                removedImageID?.add(widget
                                                            .automotiveEditProduct !=
                                                        null
                                                    ? widget
                                                        .automotiveEditProduct!
                                                        .imageMedia![index]
                                                        .id!
                                                    : widget.classifiedEditProduct !=
                                                            null
                                                        ? widget
                                                            .classifiedEditProduct!
                                                            .imageMedia![index]
                                                            .id!
                                                        : widget.propertyEditProduct !=
                                                                null
                                                            ? widget
                                                                .propertyEditProduct!
                                                                .imageMedia![
                                                                    index]
                                                                .id!
                                                            : widget
                                                                .jobEditModel!
                                                                .imageMedia![
                                                                    index]
                                                                .id!);
                                                editImages!.removeAt(index);
                                              });
                                            },
                                            child: SvgPicture.asset(
                                              'assets/svgs/deleteIcon2.svg',
                                              height: med.height * 0.02,
                                              width: med.width * 0.6,
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                            },
                          ),
                        ),
                  // SizedBox(
                  //   height: med.height * 0.06,
                  // ),
                  // titleOptionWithText(
                  //     title: 'Upload Video',
                  //     text: 'Upload maximum 25 MB video'),
                  // SizedBox(
                  //   height: med.height * 0.03,
                  // ),
                  // isVideo == true
                  //     ? Stack(
                  //         children: <Widget>[
                  //           chewieController != null
                  //               ? Container(
                  //                   height: med.height * 0.12,
                  //                   width: med.width * 0.25,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     color: CustomAppTheme().blackColor,
                  //                   ),
                  //                   child: ClipRRect(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     child: AspectRatio(
                  //                       aspectRatio: videoPlayerController!.value.aspectRatio,
                  //                       child: Chewie(
                  //                         controller: chewieController!,
                  //                       ),
                  //                     ),
                  //                   ),
                  //                 )
                  //               : Container(
                  //                   height: med.height * 0.12,
                  //                   width: med.width * 0.25,
                  //                   decoration: BoxDecoration(
                  //                     borderRadius: BorderRadius.circular(6),
                  //                     color: CustomAppTheme().blackColor,
                  //                   ),
                  //                   child: Center(
                  //                     child: CircularProgressIndicator(color: CustomAppTheme().secondaryColor),
                  //                   ),
                  //                 ),
                  //         ],
                  //       )
                  //     : GestureDetector(
                  //         onTap: () async {
                  //           FilePickerResult result;
                  //           try {
                  //             result = (await FilePicker.platform.pickFiles(
                  //               allowCompression: true,
                  //               allowMultiple: false,
                  //               type: FileType.video,
                  //             ))!;
                  //           } catch (e) {
                  //             rethrow;
                  //           }
                  //           if (result.files.isNotEmpty) {
                  //             File file = File(result.files[0].path!);
                  //             int sizeInBytes = file.lengthSync();
                  //             double sizeInMb = sizeInBytes / (1024 * 1024);
                  //             d('VIDEO SIZE : $sizeInMb');
                  //             if (sizeInMb > 25) {
                  //               helper.showToast('Selected video size is more than 25 MB');
                  //             } else {
                  //               setState(() {
                  //                 isVideoUploading = true;
                  //               });
                  //               try {
                  //                 videoFile = File(result.files[0].path!);
                  //                 d('VIDEO PATH : ' + videoFile.toString());
                  //                 /*final Uint8List? uint8list = await VideoThumbnail.thumbnailData(
                  //                 video: result.files[0].path!,
                  //                 imageFormat: ImageFormat.JPEG,
                  //                 maxWidth: 128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
                  //                 quality: 25,
                  //               );
                  //               var val = File.fromRawPath(uint8list!);
                  //               d('VAL PATH : ${val.path}');
                  //               Future<File> thumbnail = File('image.jpg').writeAsBytes(uint8list);
                  //               String path = '';
                  //               d('THUMNAIL : $thumbnail');
                  //               final file = await thumbnail;
                  //               path = file.path;
                  //               d('THUMNAIL PATH : $file');*/
                  //                 videoPlayerController = VideoPlayerController.file(videoFile!)
                  //                   ..initialize().then(
                  //                     (value) {
                  //                       setState(
                  //                         () {
                  //                           chewieController = ChewieController(
                  //                             videoPlayerController: videoPlayerController!,
                  //                             autoInitialize: true,
                  //                             autoPlay: true,
                  //                             looping: false,
                  //                             showOptions: true,
                  //                             materialProgressColors: ChewieProgressColors(
                  //                                 backgroundColor: CustomAppTheme().primaryColor,
                  //                                 playedColor: CustomAppTheme().primaryColor.withOpacity(1.0),
                  //                                 handleColor: CustomAppTheme().primaryColor),
                  //                             showControls: true,
                  //                             allowMuting: true,
                  //                             allowFullScreen: false,
                  //                             useRootNavigator: false,
                  //                             fullScreenByDefault: false,
                  //                             showControlsOnInitialize: false,
                  //                             zoomAndPan: false,
                  //                             errorBuilder: (
                  //                               context,
                  //                               errorMessage,
                  //                             ) {
                  //                               return Center(
                  //                                 child: Text(
                  //                                   errorMessage,
                  //                                 ),
                  //                               );
                  //                             },
                  //                           );
                  //                         },
                  //                       );
                  //                     },
                  //                   ).then((value) {
                  //                     setState(() {
                  //                       isVideoUploading = false;
                  //                       isVideo = true;
                  //                     });
                  //                   });
                  //               } catch (e) {
                  //                 rethrow;
                  //               }
                  //             }
                  //           }
                  //         },
                  //         child: dotedBorderWidget(
                  //             context: context,
                  //             svgUrl: 'assets/svgs/videoIcon.svg',
                  //             buttonText: 'Upload Video',
                  //             centerText: 'Upload maximum 25 MB video'),
                  //       ),

                  const Spacer(),
                  SizedBox(
                    width: med.width,
                    child: YouOnlineButton(
                        text: 'Next',
                        onTap: () {
                          if (widget.categoryIndex == 0) {
                            d('This is the widget.classifiedEditProduct!.businessType.toString() : : ${widget.classifiedEditProduct!.businessType.toString()}');
                            createAdPostViewModel.classifiedAdData!.id =
                                widget.classifiedEditProduct!.id;
                            createAdPostViewModel.classifiedAdData!.images =
                                listOfImages;
                            createAdPostViewModel.classifiedAdData!.adType =
                                widget.classifiedEditProduct!.businessType
                                    .toString();
                            createAdPostViewModel.classifiedAdData!.imagesPath =
                                editImages;
                            createAdPostViewModel.classifiedAdData!.categoryId =
                                widget.classifiedEditProduct!.category!.id;
                            createAdPostViewModel
                                    .classifiedAdData!.subCategoryId =
                                widget.classifiedEditProduct!.subCategory!.id;
                            createAdPostViewModel.classifiedAdData!.brandId =
                                widget.classifiedEditProduct!.brand != null
                                    ? widget.classifiedEditProduct!.brand!.id
                                    : null;
                            createAdPostViewModel.classifiedAdData!.brandName =
                                widget.classifiedEditProduct!.brand != null
                                    ? widget.classifiedEditProduct!.brand!.title
                                    : null;
                            createAdPostViewModel.classifiedAdData!.title =
                                widget.classifiedEditProduct!.name;
                            createAdPostViewModel
                                    .classifiedAdData!.conditionType =
                                widget.classifiedEditProduct!.type;
                            createAdPostViewModel.classifiedAdData!.price =
                                double.parse(widget.classifiedEditProduct!.price
                                    .toString());
                            createAdPostViewModel.classifiedAdData!.dialCode =
                                widget.classifiedEditProduct!.dialCode;
                            createAdPostViewModel
                                    .classifiedAdData!.conditionType =
                                widget.classifiedEditProduct!.type;
                            createAdPostViewModel
                                    .classifiedAdData!.description =
                                widget.classifiedEditProduct!.description;
                            createAdPostViewModel.classifiedAdData!.currencyId =
                                widget.classifiedEditProduct!.currency!.id;
                            createAdPostViewModel
                                    .classifiedAdData!.currencyCode =
                                widget.classifiedEditProduct!.currency!.code;
                            createAdPostViewModel
                                    .classifiedAdData!.phoneNumber =
                                widget.classifiedEditProduct!.phoneNumber;
                            createAdPostViewModel
                                    .classifiedAdData!.streetAddress =
                                widget.classifiedEditProduct!.streetAdress;
                            createAdPostViewModel.classifiedAdData!.latitude =
                                widget.classifiedEditProduct!.latitude;
                            createAdPostViewModel.classifiedAdData!.longitude =
                                widget.classifiedEditProduct!.longitude;
                            createAdPostViewModel.classifiedAdData
                                ?.removeMediaIds = removedImageID;

                            createAdPostViewModel.classifiedAdData?.brandName =
                                widget.classifiedEditProduct!.brand?.title;
                            print(
                                "object ${widget.classifiedEditProduct!.brand}");

                            if (videoFile != null) {
                              createAdPostViewModel.classifiedAdData!.video =
                                  videoFile;
                            } else if (widget.classifiedEditProduct!.videoMedia!
                                .isNotEmpty) {
                              createAdPostViewModel
                                      .classifiedAdData!.videoPath =
                                  widget.classifiedEditProduct!.videoMedia![0]
                                      .video;
                            }

                            chewieController?.pause();
                            videoPlayerController?.pause();
                            Navigator.push(
                                context,
                                CustomPageRoute(
                                    child: ClassifiedIncludeDetailScreen(
                                        categoryIndex: widget.categoryIndex,
                                        isEdit: true),
                                    direction: AxisDirection.left));
                          }
                          if (widget.categoryIndex == 1) {
                            createAdPostViewModel.propertyAdData!.id =
                                widget.propertyEditProduct!.id;
                            createAdPostViewModel.propertyAdData!.images =
                                listOfImages;
                            createAdPostViewModel.propertyAdData!.imagesPath =
                                editImages;
                            createAdPostViewModel.propertyAdData!.categoryId =
                                widget.propertyEditProduct!.category!.id;
                            createAdPostViewModel.propertyAdData!.adType =
                                widget.propertyEditProduct!.businessType;
                            createAdPostViewModel
                                    .propertyAdData!.subCategoryId =
                                widget.propertyEditProduct!.subCategory!.id;
                            createAdPostViewModel.propertyAdData!.title =
                                widget.propertyEditProduct!.name;
                            createAdPostViewModel.propertyAdData!.price =
                                double.parse(widget.propertyEditProduct!.price
                                    .toString());
                            createAdPostViewModel.propertyAdData!.description =
                                widget.propertyEditProduct!.description;
                            createAdPostViewModel.propertyAdData!.currencyId =
                                widget.propertyEditProduct!.currency!.id;
                            createAdPostViewModel.propertyAdData!.phoneNumber =
                                widget.propertyEditProduct!.mobile;
                            createAdPostViewModel
                                    .propertyAdData!.streetAddress =
                                widget.propertyEditProduct!.streetAddress;
                            createAdPostViewModel.propertyAdData!.latitude =
                                widget.propertyEditProduct!.latitude;
                            createAdPostViewModel.propertyAdData!.longitude =
                                widget.propertyEditProduct!.longitude;
                            createAdPostViewModel.propertyAdData!.furnished =
                                widget.propertyEditProduct!.furnished;
                            createAdPostViewModel.propertyAdData!.bedrooms =
                                widget.propertyEditProduct!.bedrooms;
                            createAdPostViewModel.propertyAdData!.bathrooms =
                                widget.propertyEditProduct!.baths;
                            createAdPostViewModel.propertyAdData!.areaUnit =
                                widget.propertyEditProduct!.areaUnit;
                            createAdPostViewModel.propertyAdData!.area =
                                widget.propertyEditProduct!.area;
                            createAdPostViewModel.propertyAdData!.mobileNumber =
                                widget.propertyEditProduct!.mobile;
                            createAdPostViewModel.propertyAdData
                                ?.removeMediaIds = removedImageID;
                            createAdPostViewModel.propertyAdData?.cityId =
                                widget.propertyEditProduct!.cityId;
                            createAdPostViewModel.propertyAdData?.cityId =
                                widget.propertyEditProduct!.located?.city;
                            print(
                                "object:: City ID: ${widget.propertyEditProduct!.located?.city}");
                            print(
                                "object:: Located ID: ${widget.propertyEditProduct!.located?.id}");
                            print(
                                "object:: Located Name: ${widget.propertyEditProduct!.located?.name}");

                            createAdPostViewModel.propertyAdData?.locatedName =
                                widget.propertyEditProduct!.located?.name;
                            createAdPostViewModel.propertyAdData?.locatedId =
                                widget.propertyEditProduct!.located?.id;

                            if (videoFile != null) {
                              createAdPostViewModel.propertyAdData!.video =
                                  videoFile;
                            } else if (widget
                                .propertyEditProduct!.videoMedia!.isNotEmpty) {
                              createAdPostViewModel.propertyAdData!.videoPath =
                                  widget.propertyEditProduct!.videoMedia![0]
                                      .video;
                            }
                            chewieController?.pause();
                            videoPlayerController?.pause();
                            Navigator.push(
                                context,
                                CustomPageRoute(
                                    child: PropertiesIncludeDetail(
                                        categoryIndex: widget.categoryIndex,
                                        isEdit: true),
                                    direction: AxisDirection.left));
                          }
                          if (widget.categoryIndex == 2) {
                            createAdPostViewModel.automotiveAdData!.id =
                                widget.automotiveEditProduct!.id;
                            createAdPostViewModel.automotiveAdData!.images =
                                listOfImages;
                            createAdPostViewModel.automotiveAdData!.imagesPath =
                                editImages;
                            createAdPostViewModel.automotiveAdData!.categoryId =
                                widget.automotiveEditProduct!.category!.id;
                            createAdPostViewModel
                                    .automotiveAdData!.subCategoryId =
                                widget.automotiveEditProduct!.subCategory!.id;
                            createAdPostViewModel.automotiveAdData!.title =
                                widget.automotiveEditProduct!.name;
                            createAdPostViewModel.automotiveAdData!.adType =
                                widget.automotiveEditProduct!.businessType;
                            createAdPostViewModel.automotiveAdData!.price =
                                double.parse(widget.automotiveEditProduct!.price
                                    .toString());
                            createAdPostViewModel
                                    .automotiveAdData!.conditionType =
                                widget.automotiveEditProduct!.carType;
                            createAdPostViewModel
                                    .automotiveAdData!.description =
                                widget.automotiveEditProduct!.description;
                            createAdPostViewModel.automotiveAdData!.currencyId =
                                widget.automotiveEditProduct!.currency!.id;
                            createAdPostViewModel
                                    .automotiveAdData!.phoneNumber =
                                widget.automotiveEditProduct!.mobile;
                            createAdPostViewModel
                                    .automotiveAdData!.streetAddress =
                                widget.automotiveEditProduct!.streetAddress;
                            createAdPostViewModel.automotiveAdData!.latitude =
                                widget.automotiveEditProduct!.latitude;
                            createAdPostViewModel.automotiveAdData!.year =
                                widget.automotiveEditProduct!.automotiveYear;
                            createAdPostViewModel.automotiveAdData!.mileage =
                                widget.automotiveEditProduct!.kilometers
                                    .toString();
                            createAdPostViewModel.automotiveAdData!.fuelType =
                                widget.automotiveEditProduct!.fuelType;
                            createAdPostViewModel
                                    .automotiveAdData!.transmissionType =
                                widget.automotiveEditProduct!.transmissionType;
                            createAdPostViewModel.automotiveAdData!.longitude =
                                widget.automotiveEditProduct!.longitude;
                            createAdPostViewModel.automotiveAdData!.makeName =
                                widget.automotiveEditProduct!.make!.title;
                            createAdPostViewModel.automotiveAdData!.makeId =
                                widget.automotiveEditProduct!.make!.id;
                            createAdPostViewModel.automotiveAdData!.modelName =
                                widget.automotiveEditProduct!.automotiveModel!
                                    .title;
                            createAdPostViewModel.automotiveAdData!.modelId =
                                widget
                                    .automotiveEditProduct!.automotiveModel!.id;
                            createAdPostViewModel.automotiveAdData
                                ?.removeMediaIds = removedImageID;
                            createAdPostViewModel.automotiveAdData!.color =
                                widget.automotiveEditProduct!.color;
                            createAdPostViewModel
                                    .automotiveAdData!.automaticType =
                                widget.automotiveEditProduct!.automotiveType;

                            createAdPostViewModel.automotiveAdData!.rentHours =
                                widget.automotiveEditProduct!.rentalHours;

                            print(
                                "******** ${widget.automotiveEditProduct!.rentalHours}");

                            if (videoFile != null) {
                              createAdPostViewModel.automotiveAdData!.video =
                                  videoFile;
                            } else if (widget.automotiveEditProduct!.videoMedia!
                                .isNotEmpty) {
                              createAdPostViewModel
                                      .automotiveAdData!.videoPath =
                                  widget.automotiveEditProduct!.videoMedia![0]
                                      .video;
                            }
                            chewieController?.pause();
                            videoPlayerController?.pause();
                            Navigator.push(
                                context,
                                CustomPageRoute(
                                    child: AutomotiveIncludeDetails(
                                        categoryIndex: widget.categoryIndex,
                                        isEdit: true),
                                    direction: AxisDirection.left));
                          }
                          if (widget.categoryIndex == 3) {
                            createAdPostViewModel.jobAdData!.id =
                                widget.jobEditModel!.id;
                            createAdPostViewModel.jobAdData!.images =
                                listOfImages;
                            createAdPostViewModel.jobAdData!.imagesPath =
                                editImages;
                            createAdPostViewModel.jobAdData!.dialCode =
                                widget.jobEditModel!.dialCode;
                            createAdPostViewModel.jobAdData!.categoryId =
                                widget.jobEditModel!.category!.id;
                            createAdPostViewModel.jobAdData!.title =
                                widget.jobEditModel!.title;
                            createAdPostViewModel.jobAdData!.adType =
                                widget.jobEditModel!.businessType;
                            createAdPostViewModel.jobAdData!.description =
                                widget.jobEditModel!.description;
                            createAdPostViewModel.jobAdData!.currencyId =
                                widget.jobEditModel!.salaryCurrency!.id;
                            createAdPostViewModel.jobAdData!.currencyCode =
                                widget.jobEditModel!.salaryCurrency!.code;
                            createAdPostViewModel.jobAdData!.salaryFrom =
                                widget.jobEditModel!.salaryStart;
                            createAdPostViewModel.jobAdData!.salaryTo =
                                widget.jobEditModel!.salaryEnd;
                            createAdPostViewModel.jobAdData!.phoneNumber =
                                widget.jobEditModel!.mobile;
                            createAdPostViewModel.jobAdData!.salaryPeriod =
                                widget.jobEditModel!.salaryPeriod;
                            createAdPostViewModel.jobAdData!.jobType =
                                widget.jobEditModel!.jobType;
                            createAdPostViewModel.jobAdData!.positionType =
                                widget.jobEditModel!.positionType;
                            createAdPostViewModel.jobAdData!.streetAddress =
                                widget.jobEditModel!.location;
                            createAdPostViewModel.jobAdData!.latitude =
                                widget.jobEditModel!.latitude;
                            createAdPostViewModel.jobAdData!.longitude =
                                widget.jobEditModel!.longitude;
                            createAdPostViewModel.jobAdData?.removeMediaIds =
                                removedImageID;
                            if (videoFile != null) {
                              createAdPostViewModel.jobAdData!.video =
                                  videoFile;
                            } else if (widget
                                .jobEditModel!.videoMedia!.isNotEmpty) {
                              createAdPostViewModel.jobAdData!.videoPath =
                                  widget.jobEditModel!.videoMedia![0].video;
                            }
                            chewieController?.pause();
                            videoPlayerController?.pause();
                            Navigator.push(
                                context,
                                CustomPageRoute(
                                    child: JobIncludeDetail(
                                        categoryIndex: widget.categoryIndex,
                                        isEdit: true),
                                    direction: AxisDirection.left));
                          }
                        }),
                  ),
                  SizedBox(
                    height: med.height * 0.05,
                  ),
                ],
              ),
      ),
    );
  }

  initializeVideo(String videoUrl) {
    videoPlayerController = VideoPlayerController.network(videoUrl)
      ..initialize().then(
        (value) {
          setState(
            () {
              chewieController = ChewieController(
                videoPlayerController: videoPlayerController!,
                autoInitialize: true,
                autoPlay: true,
                looping: false,
                showOptions: true,
                materialProgressColors: ChewieProgressColors(
                    backgroundColor: CustomAppTheme().primaryColor,
                    playedColor: CustomAppTheme().primaryColor.withOpacity(1.0),
                    handleColor: CustomAppTheme().primaryColor),
                showControls: true,
                allowMuting: true,
                allowFullScreen: false,
                useRootNavigator: false,
                fullScreenByDefault: false,
                showControlsOnInitialize: false,
                zoomAndPan: false,
                errorBuilder: (
                  context,
                  errorMessage,
                ) {
                  return Center(
                    child: Text(
                      errorMessage,
                    ),
                  );
                },
              );
            },
          );
        },
      );
  }
}

getFileSize(String filepath, int decimals) async {
  var file = File(filepath);
  int bytes = await file.length();
  if (bytes <= 0) return "0 B";
  const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];
  var i = (log(bytes) / log(1024)).floor();
  return ((bytes / pow(1024, i)).toStringAsFixed(decimals)) + ' ' + suffixes[i];
}

Widget titleWithText(
    {required final String title, required final String text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        title,
        style: CustomAppTheme().headingText.copyWith(fontSize: 20),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
        ),
      ),
    ],
  );
}

Widget titleOptionWithText(
    {required final String title, required final String text}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Row(
        children: <Widget>[
          Text(
            title,
            style: CustomAppTheme().headingText.copyWith(fontSize: 20),
          ),
          Text(
            ' (Optional)',
            style: CustomAppTheme().normalGreyText.copyWith(fontSize: 16),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.only(top: 10),
        child: Text(
          text,
          style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
        ),
      ),
    ],
  );
}

Widget dotedBorderWidget(
    {required final BuildContext context,
    required final String buttonText,
    required final String centerText,
    required final String svgUrl}) {
  return DottedBorder(
    borderType: BorderType.RRect,
    radius: const Radius.circular(12),
    padding: const EdgeInsets.all(6),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(color: CustomAppTheme().backgroundColor),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: Center(
                child: SvgPicture.asset(
                  svgUrl,
                  height: MediaQuery.of(context).size.height * 0.04,
                  width: MediaQuery.of(context).size.width * 0.12,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Text(
                centerText,
                style: CustomAppTheme()
                    .normalGreyText
                    .copyWith(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15, bottom: 15),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  color: CustomAppTheme().primaryColor,
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Text(
                    buttonText,
                    style: CustomAppTheme().normalText.copyWith(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: CustomAppTheme().backgroundColor),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
