import 'package:app/common/logger/log.dart';
import 'package:app/presentation/jobs/job_filters/job_by_dateposted.dart';
import 'package:app/presentation/jobs/job_filters/job_by_jobtype.dart';
import 'package:app/presentation/jobs/job_filters/job_by_position_type.dart';
import 'package:app/presentation/jobs/job_filters/jobs_by_budget.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/searchs/searchScreen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filtered_chip_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobFiltersScreen extends StatefulWidget {
  const JobFiltersScreen({Key? key}) : super(key: key);

  @override
  State<JobFiltersScreen> createState() => _JobFiltersScreenState();
}

class _JobFiltersScreenState extends State<JobFiltersScreen> with SingleTickerProviderStateMixin {
  final List<Tab> myTabs = <Tab>[const Tab(text: 'Date Posted'), const Tab(text: 'By Budget'), const Tab(text: 'By Job Type'), const Tab(text: 'By Position Type')];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
    refreshList();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  refreshList() {
    // JobViewModel jobViewModel = context.read<JobViewModel>();
    // jobViewModel.jobFilterData = JobFilterModel();
    // jobViewModel.jobFilterMap = {};
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final JobViewModel jobViewModel = context.watch<JobViewModel>();
    List<dynamic> list = jobViewModel.jobFilterMap!.values.toList();
    print(list.length);
    print(list.map((e) => e));
    print("this is what i need");
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: CustomAppTheme().backgroundColor,
        elevation: 0.0,
        title: Text(
          'Filters',
          style: CustomAppTheme().headingText.copyWith(fontSize: 20, color: CustomAppTheme().blackColor),
        ),
        leading: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: CustomAppTheme().backgroundColor,
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0.3,
                    blurRadius: 2,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.arrow_back_ios_rounded, size: 15, color: CustomAppTheme().blackColor),
            ),
          ),
        ),
        bottom: PreferredSize(
          child: SizedBox(
            height: med.height * 0.12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                list.isEmpty
                    ?  Container()
                    // const Text('No selected filter', style: TextStyle(color: Colors.black))
                    : SizedBox(
                        height: med.height * 0.05,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: ListView.builder(
                            itemCount: list.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 5),
                                child: FilterChipWidget(
                                  onDeleteTap: () {
                                    if (list[index] == jobViewModel.jobFilterMap!['DatePosted']) {
                                      d('DatePosted : ${list[index]} == ${jobViewModel.jobFilterMap!['DatePosted']}');
                                      jobViewModel.jobFilterData!.createdAt = null;
                                    }else if (list[index] == jobViewModel.jobFilterMap!['Currency']) {
                                      d('Currency : ${list[index]} == ${jobViewModel.jobFilterMap!['Currency']}');
                                      jobViewModel.jobFilterData!.currency = null;
                                    }else if (list[index] == jobViewModel.jobFilterMap!['Budget']) {
                                      d('Budget : ${list[index]} == ${jobViewModel.jobFilterMap!['Budget']}');
                                      jobViewModel.jobFilterData!.startingSalary = null;
                                      jobViewModel.jobFilterData!.endingSalary = null;
                                    }else if (list[index] == jobViewModel.jobFilterMap!['JobType']) {
                                      d('JobType : ${list[index]} == ${jobViewModel.jobFilterMap!['JobType']}');
                                      jobViewModel.jobFilterData!.jobType = null;
                                    }else if (list[index] == jobViewModel.jobFilterMap!['PositionType']) {
                                      d('PositionType : ${list[index]} == ${jobViewModel.jobFilterMap!['PositionType']}');
                                      jobViewModel.jobFilterData!.positionType = null;
                                    }

                                    jobViewModel.jobFilterMap!.removeWhere((key, value) => value == list[index]);
                                    jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
                                  },
                                  filteredText: list[index],
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                TabBar(
                  controller: _tabController,
                  tabs: myTabs,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicatorWeight: 2,
                  isScrollable: true,
                  indicatorColor: CustomAppTheme().primaryColor,
                  labelColor: CustomAppTheme().blackColor,
                  unselectedLabelColor: CustomAppTheme().greyColor,
                  labelStyle: CustomAppTheme().normalText.copyWith(fontSize: 14, fontWeight: FontWeight.w600),
                  automaticIndicatorColorAdjustment: true,
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(med.height * 0.1),
        ),
      ),
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: const <Widget>[
          JobByDatePosted(),
          JobsByBudget(),
          JobByJobType(),
          JobByPositionType(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: med.height * 0.07,
        width: med.width,
        decoration: BoxDecoration(
          color: CustomAppTheme().backgroundColor,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 0.5,
              blurRadius: 3,
              offset: const Offset(3, 0), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            GestureDetector(
              onTap: () {
                jobViewModel.jobFilterData = JobFilterModel();
                jobViewModel.jobFilterMap = {};
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Job',
                    ),
                  ),
                );
              },
              child: Container(
                height: med.height * 0.045,
                width: med.width * 0.4,
                decoration: BoxDecoration(
                  color: CustomAppTheme().backgroundColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: CustomAppTheme().primaryColor, width: 1.5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      'Clear Filters',
                      style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().primaryColor, fontSize: 14, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                // jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
                // jobViewModel.jobFilterMap!.addEntries({const MapEntry('page', '1')});
                // jobViewModel.jobFilterData!.addEntries(
                //     {const MapEntry('page', 1)});
                // print(jobViewModel.jobFilterData!.endingSalary);
                jobViewModel.jobFilterData!.page = 1;
                print(jobViewModel.jobFilterMap);
                print("=================== :: ======================");
                // jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
                // print(jobViewModel.jobFilterMap);
                // d("============== :: ============");
                // jobViewModel.jobFilterMap!.addEntries({MapEntry('DatePosted', datePostedOptionValue[index])});
                // jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
                setState(() { });
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchScreen(
                      isFilter: true,
                      module: 'Job',
                    ),
                  ),
                );
              },
              child: Container(
                height: med.height * 0.045,
                width: med.width * 0.4,
                decoration: BoxDecoration(
                  color: CustomAppTheme().primaryColor,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: CustomAppTheme().primaryColor, width: 1.5),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 0),
                    child: Text(
                      'Apply Filters',
                      style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor, fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
