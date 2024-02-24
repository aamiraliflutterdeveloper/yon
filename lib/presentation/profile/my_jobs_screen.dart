import 'package:app/common/logger/log.dart';
import 'package:app/data/models/jobs_res_model/job_ads_res_model.dart';
import 'package:app/presentation/add_post/upload_images_videos.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/profile/business_mode/create_business_profile.dart';
import 'package:app/presentation/profile/view_model/profile_view_model.dart';
import 'package:app/presentation/profile/widgets/applied_job_widget.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/shimmers/widget_card_shimmer.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:app/presentation/widgets_screens/product_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyJobScreen extends StatefulWidget {
  const MyJobScreen({Key? key}) : super(key: key);

  @override
  State<MyJobScreen> createState() => _MyJobScreenState();
}

class _MyJobScreenState extends State<MyJobScreen> {
  bool isActive = false;

  bool isDataFetching = false;

  List<JobProductModel> appliedJobs = [];

  getMyAppliedJobs() async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    setState(() {
      isDataFetching = true;
    });
    final result = await jobViewModel.getAppliedJobs();
    result.fold((l) {}, (r) {

      appliedJobs = r.jobAdsList!;
      d('MY APPLIED JOBS : ${r.jobAdsList!.length}');
      d("Applied Jobs Are :: $appliedJobs");
      jobViewModel.changeJobAllAds(r.jobAdsList!);
    });
    setState(() {
      isDataFetching = false;
    });
  }

  @override
  void initState() {
    super.initState();
    JobViewModel jobViewModel = context.read<JobViewModel>();
    if (appliedJobs.isEmpty) {
      getMyAppliedJobs();
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    ProfileViewModel profileViewModel = context.watch<ProfileViewModel>();
    JobViewModel jobViewModel = context.watch<JobViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'My Jobs', context: context, onTap: () {Navigator.of(context).pop();}),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: med.height * 0.02,
            ),
            Text(
              '${appliedJobs.length} job',
              style: CustomAppTheme()
                  .headingText
                  .copyWith(fontSize: 20, color: CustomAppTheme().blackColor),
            ),
            SizedBox(
              height: med.height * 0.02,
            ),
            Expanded(
              child: isDataFetching
                  ? ListView.builder(
                      itemCount: 5,
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return const WideCardShimmer();
                      },
                    )
                  // : jobViewModel.appliedJobs.isEmpty
                  : appliedJobs.isEmpty
                      ? SizedBox(
                          height: 450, child: Center(child: noDataFound()))
                      : ListView.builder(
                          // itemCount: jobViewModel.appliedJobs.length,
                          itemCount: appliedJobs.length,
                          shrinkWrap: true,
                          physics: const BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductDetailScreen(
                                      productType: 'Job',
                                      // jobProduct:
                                      //     jobViewModel.appliedJobs[index],
                                      jobProduct:
                                      appliedJobs[index],
                                      isJobAd: true,
                                    ),
                                  ),
                                );
                              },
                              child: AppliedJobWidget(
                                categoryType: 'Job',
                                // jobProduct: jobViewModel.appliedJobs[index],
                                jobProduct: appliedJobs[index],
                                isAdActive: isActive,
                                onToggle: (value) {},
                                onDeleteTap: () {},
                                onEditTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          UploadImagesVideosScreen(
                                        categoryIndex: 3,
                                        // jobEditModel:
                                        //     profileViewModel.myJobAds[index],
                                            jobEditModel:
                                            appliedJobs[index],
                                        isEdit: true,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showAlertDialog({required VoidCallback onDelete}) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Ad'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                  'Are you sure want to delete this Ad?',
                  style: CustomAppTheme().normalText,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
              child: YouOnlineButton(
                onTap: () {
                  Navigator.pop(context);
                },
                text: 'No',
                fontSize: 12,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.035,
              child: YouOnlineButton(
                onTap: onDelete,
                text: 'Delete',
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
