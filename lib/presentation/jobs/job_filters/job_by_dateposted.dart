import 'package:app/common/logger/log.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobByDatePosted extends StatefulWidget {
  const JobByDatePosted({Key? key}) : super(key: key);

  @override
  State<JobByDatePosted> createState() => _JobByDatePostedState();
}

class _JobByDatePostedState extends State<JobByDatePosted> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final JobViewModel jobViewModel = context.read<JobViewModel>();
    if(jobViewModel.jobFilterMap!.containsKey('DatePosted')){
      for(int i=0; i<datePostedOptionValue.length; i++){
        if(datePostedOptionValue[i] == jobViewModel.jobFilterMap!['DatePosted']){
          selectedIndex = i;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final JobViewModel jobViewModel = context.watch<JobViewModel>();
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: med.height * 0.02,
              ),
              Text(
                'Choose from option below',
                style: CustomAppTheme().textFieldHeading,
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              ListView.builder(
                itemCount: datePostedOptionValue.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: datePostedOptionValue[index],
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      onTab: () {
                        jobViewModel.jobFilterMap!.addEntries({MapEntry('DatePosted', datePostedOptionValue[index])});
                        jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
                        if (index == 1) {
                          DateTime val = DateTime.now().subtract(const Duration(days: 1));
                          d('Val : ${val.year}-${val.month}-${val.day}');
                          jobViewModel.jobFilterData!.createdAt = '${val.year}-${val.month}-${val.day}';
                        } else if (index == 2) {
                          DateTime val = DateTime.now().subtract(const Duration(days: 3));
                          d('Val : ${val.year}-${val.month}-${val.day}');
                          jobViewModel.jobFilterData!.createdAt = '${val.year}-${val.month}-${val.day}';
                        } else if (index == 3) {
                          DateTime val = DateTime.now().subtract(const Duration(days: 14));
                          d('Val : ${val.year}-${val.month}-${val.day}');
                          jobViewModel.jobFilterData!.createdAt = '${val.year}-${val.month}-${val.day}';
                        }
                        setState(() {
                          selectedIndex = index;
                        });
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> datePostedOptionValue = <String>['All Jobs', 'Last 24 Hours', 'Last 3 days', 'Last 14 days'];
}
