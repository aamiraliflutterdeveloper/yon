import 'package:app/presentation/Base/base_mixin.dart';
import 'package:app/presentation/add_post/view_model/create_ad_post_view_model.dart';
import 'package:app/presentation/categories/categories_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AdTypeScreen extends StatefulWidget {
  // final int categoryIndex;

  const AdTypeScreen({
    Key? key,
    //  required this.categoryIndex
  }) : super(key: key);

  @override
  State<AdTypeScreen> createState() => _AdTypeScreenState();
}

int businessIndex = 0;

class _AdTypeScreenState extends State<AdTypeScreen> with BaseMixin {
  bool isBusinessProfile = false;

  @override
  void initState() {
    super.initState();
    // if (widget.categoryIndex == 0) {
    //   if (iPrefHelper.retrieveClassifiedProfile() != null &&
    //       iPrefHelper.retrieveClassifiedProfile()!.id!.isNotEmpty) {
    //     isBusinessProfile = true;
    //   }
    // } else if (widget.categoryIndex == 2) {
    //   if (iPrefHelper.retrieveAutomotiveProfile() != null &&
    //       iPrefHelper.retrieveAutomotiveProfile()!.id!.isNotEmpty) {
    //     isBusinessProfile = true;
    //   }
    // } else if (widget.categoryIndex == 1) {
    //   if (iPrefHelper.retrievePropertyProfile() != null &&
    //       iPrefHelper.retrievePropertyProfile()!.id!.isNotEmpty) {
    //     isBusinessProfile = true;
    //   }
    // } else if (widget.categoryIndex == 3) {
    //   if (iPrefHelper.retrieveJobProfile() != null &&
    //       iPrefHelper.retrieveJobProfile()!.id!.isNotEmpty) {
    //     isBusinessProfile = true;
    //   }
    // }
  }

  @override
  Widget build(BuildContext context) {
    final CreateAdPostViewModel createAdPostViewModel =
        context.watch<CreateAdPostViewModel>();
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Ad Type', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: med.height * 0.035,
            ),
            Text(
              'What are you offering?',
              style: CustomAppTheme().headingText,
            ),
            /* SizedBox(
              height: med.height * 0.015,
            ),
            Text(
              'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
              textAlign: TextAlign.start,
              style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
            ),*/
            SizedBox(
              height: med.height * 0.04,
            ),
            GridView.builder(
              itemCount: 2,
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 1.05,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap:
                      //  isBusinessProfile == false && index == 1
                      //     ? () {
                      //         helper.showToast(
                      //             'You don\'t have business account, please go to profile and create it.');
                      //       }
                      //     :
                      () {
                    setState(() {
                      businessIndex = index;
                    });
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CategoriesScreen(isAddPost: true)));
                    // if (widget.categoryIndex == 0) {
                    //   ClassifiedObject classifiedData =
                    //       createAdPostViewModel.classifiedAdData!;
                    //   classifiedData.adType =
                    //       index == 0 ? 'Individual' : 'Company';
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               UploadImagesVideosScreen(
                    //                 categoryIndex: widget.categoryIndex,
                    //               )));
                    // } else if (widget.categoryIndex == 1) {
                    //   PropertiesObject propertyObject =
                    //       createAdPostViewModel.propertyAdData!;
                    //   propertyObject.adType =
                    //       index == 0 ? 'Individual' : 'Company';
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               UploadImagesVideosScreen(
                    //                 categoryIndex: widget.categoryIndex,
                    //               )));
                    // } else if (widget.categoryIndex == 2) {
                    //   AutomotiveObject automotiveObject =
                    //       createAdPostViewModel.automotiveAdData!;
                    //   automotiveObject.adType =
                    //       index == 0 ? 'Individual' : 'Company';
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               UploadImagesVideosScreen(
                    //                 categoryIndex: widget.categoryIndex,
                    //               )));
                    // } else if (widget.categoryIndex == 3) {
                    //   JobObject jobObject =
                    //       createAdPostViewModel.jobAdData!;
                    //   jobObject.adType =
                    //       index == 0 ? 'Individual' : 'Company';
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) =>
                    //               UploadImagesVideosScreen(
                    //                 categoryIndex: widget.categoryIndex,
                    //               )));
                    // }
                  },
                  child: Card(
                    elevation: isBusinessProfile == false && index == 1 ? 1 : 2,
                    color: isBusinessProfile == false && index == 1
                        ? CustomAppTheme().lightGreyColor
                        : CustomAppTheme().backgroundColor,
                    shadowColor: CustomAppTheme().lightGreyColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Center(
                          child: SvgPicture.asset(
                            index == 0
                                ? 'assets/svgs/userProfileIcon.svg'
                                : 'assets/svgs/propertyIcon.svg',
                            height: med.height * 0.08,
                            width: med.width * 0.2,
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: AutoSizeText(
                            index == 0 ? 'Individual' : 'Company',
                            maxLines: 1,
                            minFontSize: 18,
                            overflow: TextOverflow.ellipsis,
                            style: CustomAppTheme()
                                .boldNormalText
                                .copyWith(fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: med.height * 0.02,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
