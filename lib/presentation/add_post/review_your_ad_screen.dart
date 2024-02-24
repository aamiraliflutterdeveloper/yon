import 'dart:io';

import 'package:app/common/logger/log.dart';
import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/job_include_detail_screen.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/notification/notifications_services.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/product_location_map_widget.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class ReviewYourAd extends StatefulWidget {
  final int categoryIndex;

  const ReviewYourAd({Key? key, required this.categoryIndex}) : super(key: key);

  @override
  State<ReviewYourAd> createState() => _ReviewYourAdState();
}

class _ReviewYourAdState extends State<ReviewYourAd> with BaseMixin {
  int totalImagesCount = 0;
  int currentImageIndex = 0;
  int imageIndex = 1;
  double latitude = 0.0;
  double longitude = 0.0;
  double price = 0.0;
  double salaryFrom = 0.0;
  double salaryTo = 0.0;
  String currencyCode = '';
  String title = '';
  String description = '';
  String streetAddress = '';
  bool isVideo = false;
  List<String> imageList = [];
  List<DetailListModel> classifiedDetailList = [];
  List<DetailListModel> automotiveDetailList = [];
  List<DetailListModel> propertiesDetailList = [];
  List<DetailListModel> jobDetailList = [];
  List<DetailListModel> detailList = [];

  bool isPublishing = false;

  updateImageIndex(int updatedIndex) {
    setState(() {
      imageIndex = updatedIndex + 1;
    });
  }

  VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  NotificationService showNotification = NotificationService();

  initializeVideo({File? videoFile, String? videoUrl}) {
    videoPlayerController = videoFile != null
        ? VideoPlayerController.file(videoFile)
        : VideoPlayerController.network(videoUrl!)
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

  SwiperController swiperController = SwiperController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    chewieController?.pause();
    videoPlayerController?.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    if (widget.categoryIndex == 0) {
      price = createAdPostViewModel.classifiedAdData!.price!.toDouble();
      title = createAdPostViewModel.classifiedAdData!.title.toString();
      currencyCode =
          createAdPostViewModel.classifiedAdData!.currencyCode ?? "AUD";
      description =
          createAdPostViewModel.classifiedAdData!.description.toString();
      streetAddress =
          createAdPostViewModel.classifiedAdData!.streetAddress.toString();
      totalImagesCount = createAdPostViewModel.classifiedAdData!.images!.length;
      if (createAdPostViewModel.classifiedAdData!.imagesPath != null) {
        totalImagesCount =
            createAdPostViewModel.classifiedAdData!.imagesPath!.length;
      }
      latitude = double.parse(
          createAdPostViewModel.classifiedAdData!.latitude.toString());
      longitude = double.parse(
          createAdPostViewModel.classifiedAdData!.longitude.toString());
      if (createAdPostViewModel.classifiedAdData!.video != null) {
        initializeVideo(
            videoFile: createAdPostViewModel.classifiedAdData!.video);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      if (createAdPostViewModel.classifiedAdData!.videoPath != null) {
        initializeVideo(
            videoUrl: createAdPostViewModel.classifiedAdData!.videoPath);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      classifiedDetailList = [
        DetailListModel(
            imageSvg: 'assets/svgs/priceTagIcon.svg',
            title: 'Price',
            value: createAdPostViewModel.classifiedAdData!.price.toString()),
        // DetailListModel(imageSvg: 'assets/svgs/typeIcon.svg', title: 'Type', value: createAdPostViewModel.classifiedAdData!.conditionType.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/conditionIcon.svg',
            title: 'Condition',
            value: createAdPostViewModel.classifiedAdData!.conditionType
                .toString()),
      ];
      if (createAdPostViewModel.classifiedAdData!.brandName != null &&
          createAdPostViewModel.classifiedAdData!.brandName!.isNotEmpty) {
        classifiedDetailList.add(
          DetailListModel(
              imageSvg: 'assets/svgs/brandIcon.svg',
              title: 'Brand',
              value:
                  createAdPostViewModel.classifiedAdData!.brandName ?? 'other'),
        );
      }
      detailList = classifiedDetailList;
    } else if (widget.categoryIndex == 1) {
      price = createAdPostViewModel.propertyAdData!.price!.toDouble();
      title = createAdPostViewModel.propertyAdData!.title.toString();
      description =
          createAdPostViewModel.propertyAdData!.description.toString();
      streetAddress =
          createAdPostViewModel.propertyAdData!.streetAddress.toString();
      totalImagesCount = createAdPostViewModel.propertyAdData!.images!.length;
      if (createAdPostViewModel.propertyAdData!.imagesPath != null) {
        totalImagesCount =
            createAdPostViewModel.propertyAdData!.imagesPath!.length;
      }
      latitude = double.parse(
          createAdPostViewModel.propertyAdData!.latitude.toString());
      longitude = double.parse(
          createAdPostViewModel.propertyAdData!.longitude.toString());
      if (createAdPostViewModel.propertyAdData!.video != null) {
        initializeVideo(videoFile: createAdPostViewModel.propertyAdData!.video);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      if (createAdPostViewModel.propertyAdData!.videoPath != null) {
        initializeVideo(
            videoUrl: createAdPostViewModel.propertyAdData!.videoPath);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      propertiesDetailList = [
        DetailListModel(
            imageSvg: 'assets/svgs/priceTagIcon.svg',
            title: 'Price',
            value: createAdPostViewModel.propertyAdData!.price.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/typeIcon.svg',
            title: 'Type',
            value: 'For ' +
                createAdPostViewModel.propertyAdData!.propertyType.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/bedIcon1.svg',
            title: 'Bedroom',
            value: createAdPostViewModel.propertyAdData!.bedrooms.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/bathroomIcon1.svg',
            title: 'Bathroom',
            value: createAdPostViewModel.propertyAdData!.bathrooms.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/rulerIcon.svg',
            title: 'Area Unit',
            value: createAdPostViewModel.propertyAdData!.areaUnit.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/areaChartIcon.svg',
            title: 'Area',
            value: createAdPostViewModel.propertyAdData!.area.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/cabinetIcon.svg',
            title: 'Furnished',
            value:
                createAdPostViewModel.propertyAdData!.furnished == 'Furnished'
                    ? 'Yes'
                    : 'No'),
      ];
      detailList = propertiesDetailList;
    } else if (widget.categoryIndex == 2) {
      price = createAdPostViewModel.automotiveAdData!.price!.toDouble();
      title = createAdPostViewModel.automotiveAdData!.title.toString();
      description =
          createAdPostViewModel.automotiveAdData!.description.toString();
      streetAddress =
          createAdPostViewModel.automotiveAdData!.streetAddress.toString();
      totalImagesCount = createAdPostViewModel.automotiveAdData!.images!.length;
      if (createAdPostViewModel.automotiveAdData!.imagesPath != null) {
        totalImagesCount =
            createAdPostViewModel.automotiveAdData!.imagesPath!.length;
      }
      latitude = double.parse(
          createAdPostViewModel.automotiveAdData!.latitude.toString());
      longitude = double.parse(
          createAdPostViewModel.automotiveAdData!.longitude.toString());
      if (createAdPostViewModel.automotiveAdData!.video != null) {
        initializeVideo(
            videoFile: createAdPostViewModel.automotiveAdData!.video);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      if (createAdPostViewModel.automotiveAdData!.videoPath != null) {
        initializeVideo(
            videoUrl: createAdPostViewModel.automotiveAdData!.videoPath);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      detailList = <DetailListModel>[
        DetailListModel(
            imageSvg: 'assets/svgs/priceTagIcon.svg',
            title: 'Price',
            value: createAdPostViewModel.automotiveAdData!.price.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/typeIcon.svg',
            title: 'Type',
            value: createAdPostViewModel.automotiveAdData!.title.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/brandIcon.svg',
            title: 'Make',
            value: createAdPostViewModel.automotiveAdData!.makeName.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/carIcon.svg',
            title: 'Model',
            value: createAdPostViewModel.automotiveAdData!.makeName.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/milage.svg',
            title: 'Mileage',
            value: createAdPostViewModel.automotiveAdData!.mileage.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/calanderIcon.svg',
            title: 'Year',
            value: createAdPostViewModel.automotiveAdData!.year.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/transmission.svg',
            title: 'Transmission',
            value: createAdPostViewModel.automotiveAdData!.transmissionType
                .toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/conditionIcon.svg',
            title: 'Condition',
            value: createAdPostViewModel.automotiveAdData!.conditionType
                .toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/engine.svg',
            title: 'Fuel',
            value: createAdPostViewModel.automotiveAdData!.fuelType.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/color.svg',
            title: 'Color',
            value: createAdPostViewModel.automotiveAdData!.color.toString()),
      ];
    } else if (widget.categoryIndex == 3) {
      salaryFrom = double.parse(createAdPostViewModel.jobAdData!.salaryFrom!);
      salaryTo = double.parse(createAdPostViewModel.jobAdData!.salaryTo!);
      title = createAdPostViewModel.jobAdData!.title.toString();
      description = createAdPostViewModel.jobAdData!.description.toString();
      streetAddress = createAdPostViewModel.jobAdData!.streetAddress.toString();
      totalImagesCount = createAdPostViewModel.jobAdData!.images!.length;
      if (createAdPostViewModel.jobAdData!.imagesPath != null) {
        totalImagesCount = createAdPostViewModel.jobAdData!.imagesPath!.length;
      }
      latitude =
          double.parse(createAdPostViewModel.jobAdData!.latitude.toString());
      longitude =
          double.parse(createAdPostViewModel.jobAdData!.longitude.toString());
      if (createAdPostViewModel.jobAdData!.video != null) {
        initializeVideo(videoFile: createAdPostViewModel.jobAdData!.video);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      if (createAdPostViewModel.jobAdData!.videoPath != null) {
        initializeVideo(videoUrl: createAdPostViewModel.jobAdData!.videoPath);
        totalImagesCount = totalImagesCount;
        isVideo = true;
      }
      jobDetailList = [
        DetailListModel(
            imageSvg: 'assets/svgs/priceTagIcon.svg',
            title: 'Salary From',
            value: createAdPostViewModel.jobAdData!.salaryFrom.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/priceTagIcon.svg',
            title: 'Salary End',
            value: createAdPostViewModel.jobAdData!.salaryTo.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/clockIcon.svg',
            title: 'Period',
            value: createAdPostViewModel.jobAdData!.salaryPeriod.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/jobPositionIcon.svg',
            title: 'Position',
            value: createAdPostViewModel.jobAdData!.positionType.toString()),
        DetailListModel(
            imageSvg: 'assets/svgs/typeIcon.svg',
            title: 'Type',
            value: createAdPostViewModel.jobAdData!.jobType.toString()),
      ];
      detailList = jobDetailList;
    }

    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Step 4 of 4', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 15, right: 15, bottom: 15, top: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              titleWithText(
                  title: 'Review Your Ad',
                  text: 'This is how your ad will look like.'),
              SizedBox(
                height: med.height * 0.03,
              ),
              Container(
                height: med.height * 0.25,
                width: med.width,
                decoration: BoxDecoration(
                  color: CustomAppTheme().greyColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Stack(
                  children: <Widget>[
                    Swiper(
                      controller: swiperController,
                      itemCount:
                          isVideo ? totalImagesCount + 1 : totalImagesCount,
                      itemWidth: med.width,
                      itemHeight: med.height * 0.25,
                      layout: SwiperLayout.DEFAULT,
                      autoplay: false,
                      onIndexChanged: (index) {
                        setState(() {
                          currentImageIndex = index;
                          d('CURRENT IMAGE INDEX : $currentImageIndex');
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        String imagePath = '';
                        if (widget.categoryIndex == 0) {
                          if (isVideo && index == 0) {
                            imagePath = '';
                          } else {
                            if (isVideo) {
                              if (createAdPostViewModel.classifiedAdData!.id !=
                                  null) {
                                imagePath = createAdPostViewModel
                                    .classifiedAdData!.imagesPath![index - 1];
                              } else {
                                imagePath = createAdPostViewModel
                                    .classifiedAdData!.images![index - 1].path;
                              }
                            } else {
                              if (createAdPostViewModel.classifiedAdData!.id !=
                                  null) {
                                imagePath = createAdPostViewModel
                                    .classifiedAdData!.imagesPath![index];
                              } else {
                                imagePath = createAdPostViewModel
                                    .classifiedAdData!.images![index].path;
                              }
                            }
                          }
                        } else if (widget.categoryIndex == 1) {
                          if (isVideo && index == 0) {
                            imagePath = '';
                          } else {
                            if (isVideo) {
                              if (createAdPostViewModel.propertyAdData!.id !=
                                  null) {
                                imagePath = createAdPostViewModel
                                    .propertyAdData!.imagesPath![index - 1];
                              } else {
                                imagePath = createAdPostViewModel
                                    .propertyAdData!.images![index - 1].path;
                              }
                            } else {
                              if (createAdPostViewModel.propertyAdData!.id !=
                                  null) {
                                imagePath = createAdPostViewModel
                                    .propertyAdData!.imagesPath![index];
                              } else {
                                imagePath = createAdPostViewModel
                                    .propertyAdData!.images![index].path;
                              }
                            }
                          }
                        } else if (widget.categoryIndex == 2) {
                          if (isVideo && index == 0) {
                            imagePath = '';
                          } else {
                            if (isVideo) {
                              if (createAdPostViewModel.automotiveAdData!.id !=
                                  null) {
                                imagePath = createAdPostViewModel
                                    .automotiveAdData!.imagesPath![index - 1];
                              } else {
                                imagePath = createAdPostViewModel
                                    .automotiveAdData!.images![index - 1].path;
                              }
                            } else {
                              if (createAdPostViewModel.automotiveAdData!.id !=
                                  null) {
                                imagePath = createAdPostViewModel
                                    .automotiveAdData!.imagesPath![index];
                              } else {
                                imagePath = createAdPostViewModel
                                    .automotiveAdData!.images![index].path;
                              }
                            }
                          }
                        } else if (widget.categoryIndex == 3) {
                          if (isVideo && index == 0) {
                            imagePath = '';
                          } else {
                            if (isVideo) {
                              if (createAdPostViewModel.jobAdData!.id != null) {
                                imagePath = createAdPostViewModel
                                    .jobAdData!.imagesPath![index - 1];
                              } else {
                                imagePath = createAdPostViewModel
                                    .jobAdData!.images![index - 1].path;
                              }
                            } else {
                              if (createAdPostViewModel.jobAdData!.id != null) {
                                imagePath = createAdPostViewModel
                                    .jobAdData!.imagesPath![index];
                              } else {
                                imagePath = createAdPostViewModel
                                    .jobAdData!.images![index].path;
                              }
                            }
                          }
                        }
                        return index == 0 && isVideo
                            ? Stack(
                                children: <Widget>[
                                  chewieController == null
                                      ? Container(
                                          height: med.height * 0.25,
                                          width: med.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomAppTheme().blackColor,
                                          ),
                                          child: Center(
                                              child: CircularProgressIndicator(
                                            color:
                                                CustomAppTheme().primaryColor,
                                          )),
                                        )
                                      : Container(
                                          height: med.height * 0.25,
                                          width: med.width,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: CustomAppTheme().blackColor,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            child: AspectRatio(
                                              aspectRatio:
                                                  videoPlayerController!
                                                      .value.aspectRatio,
                                              child: Chewie(
                                                controller: chewieController!,
                                              ),
                                            ),
                                          ),
                                        ),
                                ],
                              )
                            : Container(
                                height: med.height * 0.25,
                                width: med.width,
                                decoration: BoxDecoration(
                                  color: CustomAppTheme().greyColor,
                                  borderRadius: BorderRadius.circular(10),
                                  image: imagePath.contains('https')
                                      ? DecorationImage(
                                          image: NetworkImage(imagePath),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: FileImage(File(imagePath)),
                                          fit: BoxFit.cover),
                                ),
                              );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: Container(
                          height: med.height * 0.03,
                          width: med.width * 0.18,
                          decoration: BoxDecoration(
                            color: Colors.black26,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 5),
                            child: Center(
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  SvgPicture.asset(
                                    'assets/svgs/imagesIcon.svg',
                                    height: MediaQuery.of(context).size.height *
                                        0.012,
                                    fit: BoxFit.cover,
                                  ),
                                  Text(
                                    '${currentImageIndex + 1}/${isVideo ? totalImagesCount + 1 : totalImagesCount}',
                                    style: CustomAppTheme().normalText.copyWith(
                                        fontSize: 11,
                                        color:
                                            CustomAppTheme().backgroundColor),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: med.height * 0.015,
              ),
              SizedBox(
                height: med.height * 0.09,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: isVideo ? totalImagesCount + 1 : totalImagesCount,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    String imagePath = '';
                    if (widget.categoryIndex == 0) {
                      if (isVideo && index == 0) {
                        imagePath = '';
                      } else {
                        if (isVideo) {
                          if (createAdPostViewModel.classifiedAdData!.id !=
                              null) {
                            imagePath = createAdPostViewModel
                                .classifiedAdData!.imagesPath![index - 1];
                          } else {
                            imagePath = createAdPostViewModel
                                .classifiedAdData!.images![index - 1].path;
                          }
                        } else {
                          if (createAdPostViewModel.classifiedAdData!.id !=
                              null) {
                            imagePath = createAdPostViewModel
                                .classifiedAdData!.imagesPath![index];
                          } else {
                            imagePath = createAdPostViewModel
                                .classifiedAdData!.images![index].path;
                          }
                        }
                      }
                    } else if (widget.categoryIndex == 1) {
                      if (isVideo && index == 0) {
                        imagePath = '';
                      } else {
                        if (isVideo) {
                          if (createAdPostViewModel.propertyAdData!.id !=
                              null) {
                            imagePath = createAdPostViewModel
                                .propertyAdData!.imagesPath![index - 1];
                          } else {
                            imagePath = createAdPostViewModel
                                .propertyAdData!.images![index - 1].path;
                          }
                        } else {
                          if (createAdPostViewModel.propertyAdData!.id !=
                              null) {
                            imagePath = createAdPostViewModel
                                .propertyAdData!.imagesPath![index];
                          } else {
                            imagePath = createAdPostViewModel
                                .propertyAdData!.images![index].path;
                          }
                        }
                      }
                    } else if (widget.categoryIndex == 2) {
                      if (isVideo && index == 0) {
                        imagePath = '';
                      } else {
                        if (isVideo) {
                          if (createAdPostViewModel.automotiveAdData!.id !=
                              null) {
                            imagePath = createAdPostViewModel
                                .automotiveAdData!.imagesPath![index - 1];
                          } else {
                            imagePath = createAdPostViewModel
                                .automotiveAdData!.images![index - 1].path;
                          }
                        } else {
                          if (createAdPostViewModel.automotiveAdData!.id !=
                              null) {
                            imagePath = createAdPostViewModel
                                .automotiveAdData!.imagesPath![index];
                          } else {
                            imagePath = createAdPostViewModel
                                .automotiveAdData!.images![index].path;
                          }
                        }
                      }
                    } else if (widget.categoryIndex == 3) {
                      if (isVideo && index == 0) {
                        imagePath = '';
                      } else {
                        if (isVideo) {
                          if (createAdPostViewModel.jobAdData!.id != null) {
                            imagePath = createAdPostViewModel
                                .jobAdData!.imagesPath![index - 1];
                          } else {
                            imagePath = createAdPostViewModel
                                .jobAdData!.images![index - 1].path;
                          }
                        } else {
                          if (createAdPostViewModel.jobAdData!.id != null) {
                            imagePath = createAdPostViewModel
                                .jobAdData!.imagesPath![index];
                          } else {
                            imagePath = createAdPostViewModel
                                .jobAdData!.images![index].path;
                          }
                        }
                      }
                    }
                    return index == 0 && isVideo
                        ? Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Stack(
                              children: <Widget>[
                                chewieController == null
                                    ? Container(
                                        width: med.width * 0.2,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          color: CustomAppTheme().greyColor,
                                        ),
                                        child: Center(
                                          child: CircularProgressIndicator(
                                              color: CustomAppTheme()
                                                  .primaryColor),
                                        ),
                                      )
                                    : GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            swiperController.index = index;
                                            currentImageIndex = index;
                                            swiperController.move(index);
                                          });
                                        },
                                        child: Container(
                                          width: med.width * 0.2,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            color: CustomAppTheme().greyColor,
                                          ),
                                          child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: AspectRatio(
                                              aspectRatio:
                                                  videoPlayerController!
                                                      .value.aspectRatio,
                                              child: Chewie(
                                                controller: chewieController!,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                              ],
                            ),
                          )
                        : Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  swiperController.index = index;
                                  currentImageIndex = index;
                                  swiperController.move(index);
                                });
                              },
                              child: Container(
                                width: med.width * 0.2,
                                decoration: BoxDecoration(
                                  color: CustomAppTheme().greyColor,
                                  borderRadius: BorderRadius.circular(8),
                                  image: imagePath.contains('https')
                                      ? DecorationImage(
                                          image: NetworkImage(imagePath),
                                          fit: BoxFit.cover)
                                      : DecorationImage(
                                          image: FileImage(File(imagePath)),
                                          fit: BoxFit.cover),
                                ),
                              ),
                            ),
                          );
                    /*String imagePath = '';
                    if (widget.categoryIndex == 0) {
                      imagePath = createAdPostViewModel.classifiedAdData!.images![index].path;
                    } else if (widget.categoryIndex == 1) {
                      imagePath = createAdPostViewModel.propertyAdData!.images![index].path;
                    } else if (widget.categoryIndex == 2) {
                      imagePath = createAdPostViewModel.automotiveAdData!.images![index].path;
                    } else if (widget.categoryIndex == 3) {
                      imagePath = createAdPostViewModel.jobAdData!.images![index].path;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Container(
                        width: med.width * 0.2,
                        decoration: BoxDecoration(
                          color: CustomAppTheme().greyColor,
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(image: FileImage(File(imagePath)), fit: BoxFit.cover),
                        ),
                      ),
                    );*/
                  },
                ),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              Row(
                children: <Widget>[
                  Text(
                    currencyCode,
                    style: CustomAppTheme().normalText.copyWith(
                        color: CustomAppTheme().primaryColor,
                        fontWeight: FontWeight.w600),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: Text(
                      "${widget.categoryIndex == 3 ? '${salaryFrom.toStringAsFixed(0)} - ${salaryTo.toStringAsFixed(0)}' : price.toStringAsFixed(0)} ${currencyCode == "" ? selectedCurrency == "Australian Dollar" ? "AUD" : selectedCurrency : ""} ${widget.categoryIndex == 2 ? createAdPostViewModel.automotiveAdData!.rentHours != null ? "/ ${createAdPostViewModel.automotiveAdData!.rentHours}" : "" : ""}", //
                      style: CustomAppTheme().normalText.copyWith(
                          color: CustomAppTheme().primaryColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ),
                  const Spacer(),
                ],
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              Text(
                title,
                style: CustomAppTheme().headingText.copyWith(fontSize: 16),
              ),
              /*SizedBox(
                height: med.height * 0.01,
              ),
              Wrap(
                spacing: 10.0,
                runSpacing: 8.0,
                children: <Widget>[
                  for (int index = 0; index < 3; index++)
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: CustomAppTheme().primaryColor),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            SvgPicture.asset(
                              'assets/svgs/bedIcon.svg',
                              height: MediaQuery.of(context).size.height * 0.01,
                              fit: BoxFit.cover,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 3),
                              child: Text(
                                featuresList[index],
                                style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().darkGreyColor, fontSize: 8, fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),*/
              SizedBox(
                height: med.height * 0.02,
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              Row(
                children: <Widget>[
                  iPrefHelper.retrieveUser()!.profilePicture != null
                      ? CircleAvatar(
                          radius: med.height * 0.025,
                          backgroundColor: CustomAppTheme().primaryColor,
                          backgroundImage: NetworkImage(
                            iPrefHelper
                                .retrieveUser()!
                                .profilePicture
                                .toString(),
                          ),
                        )
                      : CircleAvatar(
                          radius: med.height * 0.025,
                          backgroundColor: CustomAppTheme().primaryColor,
                        ),
                  // Container(
                  //   height: med.height * 0.05,
                  //   width: med.width * 0.12,
                  //   decoration: BoxDecoration(
                  //     color: CustomAppTheme().primaryColor,
                  //     shape: BoxShape.circle,
                  //   ),
                  //   child: ,
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: SizedBox(
                      height: med.height * 0.05,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            iPrefHelper.retrieveUser()!.firstName.toString(),
                            style: CustomAppTheme().normalText.copyWith(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            "${iPrefHelper.userCurrentCity().toString()}, ${iPrefHelper.userCurrentCountry().toString()}",
                            style: CustomAppTheme()
                                .normalGreyText
                                .copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Spacer(),
                  /*Container(
                    height: med.height * 0.042,
                    decoration: BoxDecoration(
                      color: CustomAppTheme().primaryColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          'View Profile',
                          style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w600, color: Colors.white),
                        ),
                      ),
                    ),
                  ),*/
                ],
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              productDetailHeading(title: 'Description'),
              SizedBox(
                height: med.height * 0.01,
              ),
              Text(
                description,
                // 'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industrys standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.',
                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              productDetailHeading(title: 'Product Detail'),
              SizedBox(
                height: med.height * 0.02,
              ),
              GridView.builder(
                itemCount: detailList.length,
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 150,
                  childAspectRatio: 2.0,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 0,
                ),
                itemBuilder: (context, index) {
                  return productDetailWidget(
                      svgUrl: detailList[index].imageSvg!,
                      title: detailList[index].title!,
                      value: detailList[index].value!);
                },
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              Divider(
                color: CustomAppTheme().greyColor.withOpacity(0.3),
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              productDetailHeading(title: 'Location'),
              SizedBox(
                height: med.height * 0.01,
              ),
              Row(
                children: <Widget>[
                  Icon(Icons.location_on_rounded,
                      color: CustomAppTheme().darkGreyColor, size: 14),
                  Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: med.width * 0.8,
                      child: Text(
                        streetAddress,
                        style: CustomAppTheme().normalGreyText.copyWith(
                            fontSize: 12,
                            color: CustomAppTheme().darkGreyColor),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              ProductLocationMapWidget(
                  latitude: latitude, longitude: longitude),
              SizedBox(
                height: med.height * 0.05,
              ),
              SizedBox(
                width: med.width,
                child: isPublishing
                    ? Center(
                        child: CircularProgressIndicator(
                            color: CustomAppTheme().primaryColor),
                      )
                    : YouOnlineButton(
                        text: 'Publish',
                        onTap: () async {
                          showNotification.showPostUploadingInfo(id: 1, title: 'YouOnline', body: 'You ad is posting, you will get a notification when it will be posted');
                          if (widget.categoryIndex == 0) {
                            if (createAdPostViewModel.classifiedAdData!.id !=
                                null) {
                              setState(() {
                                isPublishing = true;
                              });
                              await createAdPostViewModel.updateClassifiedAd(
                                  context: context);

                              setState(() {
                                isPublishing = false;
                              });
                            } else {
                              setState(() {
                                isPublishing = true;
                              });
                              await createAdPostViewModel.createClassifiedAd(
                                  context: context);
                              setState(() {
                                isPublishing = false;
                              });
                            }
                            chewieController?.dispose();
                            videoPlayerController?.dispose();
                          } else if (widget.categoryIndex == 1) {
                            if (createAdPostViewModel.propertyAdData!.id !=
                                null) {
                              setState(() {
                                isPublishing = true;
                              });
                              await createAdPostViewModel.updatePropertyAd(
                                  context: context);
                              setState(() {
                                isPublishing = false;
                              });
                            } else {
                              setState(() {
                                isPublishing = true;
                              });
                              await createAdPostViewModel.createPropertyAd(
                                  context: context);
                              setState(() {
                                isPublishing = false;
                              });
                            }
                            chewieController?.dispose();
                            videoPlayerController?.dispose();
                          } else if (widget.categoryIndex == 2) {
                            if (createAdPostViewModel.automotiveAdData!.id !=
                                null) {
                              setState(() {
                                isPublishing = true;
                              });
                              await createAdPostViewModel.updateAutomotiveAd(
                                  context: context);
                              setState(() {
                                isPublishing = false;
                              });
                            } else {
                              setState(() {
                                isPublishing = true;
                              });
                              await createAdPostViewModel.createAutomotiveAd(
                                  context: context);
                              setState(() {
                                isPublishing = false;
                              });
                            }
                            chewieController?.dispose();
                            videoPlayerController?.dispose();
                          } else if (widget.categoryIndex == 3) {
                            if (createAdPostViewModel.jobAdData!.id != null) {
                              setState(() {
                                isPublishing = true;
                              });
                              await createAdPostViewModel.updateJobAd(
                                  context: context);
                              setState(() {
                                isPublishing = false;
                              });
                            } else {
                              setState(() {
                                isPublishing = true;
                              });
                              print("hahahahahhahahaahhahhahahahhahahahahahahhah");
                              await createAdPostViewModel.createJobAd(
                                  context: context);
                              setState(() {
                                isPublishing = false;
                              });
                            }
                            chewieController?.dispose();
                            videoPlayerController?.dispose();
                          }

                        },
                      ),
              ),
              SizedBox(
                height: med.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget productDetailHeading({required final String title}) {
    return Text(
      title,
      style: CustomAppTheme()
          .normalText
          .copyWith(fontSize: 15, fontWeight: FontWeight.w600),
    );
  }

  Widget productDetailWidget(
      {required final String svgUrl,
      required final String title,
      required final String value}) {
    return Row(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.04,
          width: MediaQuery.of(context).size.width * 0.1,
          decoration: BoxDecoration(
            color: CustomAppTheme().backgroundColor,
            shape: BoxShape.circle,
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 0.2,
                blurRadius: 1,
                offset: const Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(6.0),
            child: SvgPicture.asset(
              svgUrl,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: CustomAppTheme()
                        .normalText
                        .copyWith(fontSize: 10, fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.16,
                  child: Text(
                    value,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: CustomAppTheme().normalGreyText.copyWith(
                        fontSize: 9, color: CustomAppTheme().darkGreyColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  List<String> featuresList = [
    'ABS',
    'Airbags',
    'Air Conditioning',
    'Alloy Rims',
    'CD Player',
    'Cassette Player',
    'Climate Control',
    'Front Speakers',
    'Immobilizer',
    'Power Locks',
    'Power Steering'
  ];
}

class DetailListModel {
  String? imageSvg;
  String? title;
  String? value;

  DetailListModel({
    this.imageSvg,
    this.title,
    this.value,
  });
}
