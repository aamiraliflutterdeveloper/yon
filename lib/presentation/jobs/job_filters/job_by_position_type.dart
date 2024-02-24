import 'package:app/common/logger/log.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class JobByPositionType extends StatefulWidget {
  const JobByPositionType({Key? key}) : super(key: key);

  @override
  State<JobByPositionType> createState() => _JobByPositionTypeState();
}

class _JobByPositionTypeState extends State<JobByPositionType> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final JobViewModel jobViewModel = context.read<JobViewModel>();
    if(jobViewModel.jobFilterMap!.containsKey('PositionType')){
      for(int i=0; i<positionTypeList.length; i++){
        if(positionTypeList[i] == jobViewModel.jobFilterMap!['PositionType']){
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
                itemCount: positionTypeList.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: positionTypeList[index],
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      onTab: () {
                        jobViewModel.jobFilterData!.positionType = positionTypeList[index];
                        jobViewModel.jobFilterMap!.addEntries({MapEntry('PositionType', positionTypeList[index])});
                        jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
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

  List<String> positionTypeList = <String>['All', 'Full Time', 'Part Time', 'Contract', 'Temporary'];
}
