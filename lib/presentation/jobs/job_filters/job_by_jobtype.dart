import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobByJobType extends StatefulWidget {
  const JobByJobType({Key? key}) : super(key: key);

  @override
  State<JobByJobType> createState() => _JobByJobTypeState();
}

class _JobByJobTypeState extends State<JobByJobType> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final JobViewModel jobViewModel = context.read<JobViewModel>();
    if(jobViewModel.jobFilterMap!.containsKey('JobType')){
      for(int i=0; i<jobTypeOptionValue.length; i++){
        if(jobTypeOptionValue[i] == jobViewModel.jobFilterMap!['JobType']){
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
                itemCount: jobTypeOptionValue.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: jobTypeOptionValue[index],
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      onTab: () {
                        jobViewModel.jobFilterMap!.addEntries({MapEntry('JobType', jobTypeOptionValue[index])});
                        jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
                        jobViewModel.jobFilterData!.jobType = jobTypeOptionValue[index];
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

  List<String> jobTypeOptionValue = <String>['All', 'In-Office', 'Remote', 'Hybrid'];
}
