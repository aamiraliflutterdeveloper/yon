import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/jobs/view_model/jobs_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class JobsByBudget extends StatefulWidget {
  const JobsByBudget({Key? key}) : super(key: key);

  @override
  State<JobsByBudget> createState() => _JobsByBudgetState();
}

class _JobsByBudgetState extends State<JobsByBudget> {
  int selectedIndex = -1;
  List<AllCurrenciesModel> currenciesList = [];
  String? currencyId;
  String? currencyDropDownValue;

  void getAllCurrencies() async {
    final JobViewModel jobViewModel = context.read<JobViewModel>();
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      currencyDropDownValue =
          context.read<GeneralViewModel>().currenciesList[0];
      jobViewModel.jobFilterMap!
          .addEntries({MapEntry('Currency', currencyDropDownValue!)});
      jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
      currencyId = r.response![0].id;
      jobViewModel.jobFilterData!.currency = currencyId;
      getBudgetLimits(currencyId!);
      setState(() {});
    });
  }

  void getBudgetLimits(String currencyId) async {
    JobViewModel jobViewModel = context.read<JobViewModel>();
    final result =
        await jobViewModel.getJobFilterLimits(currencyId: currencyId);
    result.fold((l) {}, (r) {
      jobViewModel.changeJobFilterLimits(r.response!);
      d('AUTO LIMITS **************************');
      d(jobViewModel.jobFilteredLimits.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    final JobViewModel jobViewModel = context.read<JobViewModel>();
    final generalViewModel = context.read<GeneralViewModel>();
    if (generalViewModel.allCurrenciesList.isEmpty) {
      getAllCurrencies();
    } else {
      // currenciesList = generalViewModel.allCurrenciesList;
      // currencyDropDownValue = context.read<GeneralViewModel>().currenciesList[0];
      // getBudgetLimits(generalViewModel.allCurrenciesList[0].id!);
      // jobViewModel.jobFilterMap!.addEntries({MapEntry('Currency', currencyDropDownValue!)});
      // jobViewModel.changeJobFilterMap(jobViewModel.jobFilterMap!);
      // jobViewModel.jobFilterData!.currency = generalViewModel.allCurrenciesList[0].id;
      if (jobViewModel.jobFilterMap!.containsKey('Currency')) {
        currencyDropDownValue = jobViewModel.jobFilterMap!['Currency'];
        for (int i = 0; i < generalViewModel.allCurrenciesList.length; i++) {
          if (currencyDropDownValue ==
              generalViewModel.allCurrenciesList[i].code) {
            getBudgetLimits(generalViewModel.allCurrenciesList[i].id!);
          }
        }
      } else {
        currencyDropDownValue = generalViewModel.currenciesList[0];
        for (int i = 0; i < generalViewModel.allCurrenciesList.length; i++) {
          if (currencyDropDownValue ==
              generalViewModel.allCurrenciesList[i].code) {
            getBudgetLimits(generalViewModel.allCurrenciesList[i].id!);
          }
        }
      }

      if (jobViewModel.jobFilterMap!.containsKey('Budget')) {
        for (int i = 0; i < jobViewModel.jobFilteredLimits!.length; i++) {
          if (jobViewModel.jobFilterMap!['Budget']!.contains(
              jobViewModel.jobFilteredLimits![i].secondValue.toString())) {
            selectedIndex = i;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    final GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
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

              SizedBox(
                width: med.width,
                height: med.height * 0.047,
                child: currencyDropDown(
                  context: context,
                  currencyDropDownValue: currencyDropDownValue,
                  onChange: (value) async {
                    setState(
                      () {
                        currencyDropDownValue = value;
                        for (int i = 0;
                            i < generalViewModel.allCurrenciesList.length;
                            i++) {
                          if (generalViewModel.allCurrenciesList[i].code ==
                              value) {
                            currencyId =
                                generalViewModel.allCurrenciesList[i].id;
                            jobViewModel.jobFilterData!.currency = currencyId;
                            jobViewModel.jobFilterMap!.addEntries(
                                {MapEntry('Currency', currencyDropDownValue!)});
                            jobViewModel
                                .changeJobFilterMap(jobViewModel.jobFilterMap!);
                            getBudgetLimits(currencyId!);
                          }
                        }
                      },
                    );
                  },
                ),
              ),
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
                itemCount: jobViewModel.jobFilteredLimits!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String value1 = '';
                  String value2 = '';
                  value1 =
                      jobViewModel.jobFilteredLimits![index].firstValue == null
                          ? 'Above '
                          : jobViewModel.jobFilteredLimits![index].firstValue
                                  .toString() +
                              ' - ';
                  value2 =
                      jobViewModel.jobFilteredLimits![index].secondValue == null
                          ? ''
                          : jobViewModel.jobFilteredLimits![index].secondValue
                              .toString();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: value1 + value2,
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      totalCount:
                          jobViewModel.jobFilteredLimits![index].totalCount,
                      onTab: () {
                        jobViewModel.jobFilterMap!
                            .addEntries({MapEntry('Budget', value1 + value2)});
                        jobViewModel
                            .changeJobFilterMap(jobViewModel.jobFilterMap!);
                        setState(() {
                          if (jobViewModel.jobFilterData!.currency == null) {
                            jobViewModel.jobFilterData!.currency =
                                "d7cad087-e7d7-4108-aa18-e07abde98ede";
                          }
                          selectedIndex = index;
                          if (selectedIndex == 4) {
                            jobViewModel.jobFilterData!.startingSalary =
                                jobViewModel
                                    .jobFilteredLimits![index].secondValue;
                          } else {
                            jobViewModel.jobFilterData!.startingSalary =
                                jobViewModel
                                    .jobFilteredLimits![index].firstValue;
                            jobViewModel.jobFilterData!.endingSalary =
                                jobViewModel
                                    .jobFilteredLimits![index].secondValue;
                          }
                        });
                      },
                    ),
                  );
                },
              ),

              SizedBox(
                height: med.height * 0.01,
              ),

              // //Divider
              // Row(
              //   children: <Widget>[
              //     Expanded(
              //       child: Container(
              //         margin: const EdgeInsets.only(right: 10.0),
              //         child: const Divider(
              //           color: Colors.black,
              //           height: 36,
              //         ),
              //       ),
              //     ),
              //     Text(
              //       "or",
              //       style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w500),
              //     ),
              //     Expanded(
              //       child: Container(
              //         margin: const EdgeInsets.only(left: 10.0),
              //         child: const Divider(
              //           color: Colors.black,
              //           height: 36,
              //         ),
              //       ),
              //     ),
              //   ],
              // ),

              // SizedBox(
              //   height: med.height * 0.01,
              // ),

              // Text(
              //   'Choose from option below',
              //   style: CustomAppTheme().textFieldHeading,
              // ),

              // SizedBox(
              //   height: med.height * 0.02,
              // ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: <Widget>[
              //     SizedBox(
              //       width: med.width * 0.4,
              //       child: const FilterRangeTextField(suffixText: 'min', hintText: '0'),
              //     ),
              //     Text(
              //       'to',
              //       style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w500),
              //     ),
              //     SizedBox(
              //       width: med.width * 0.4,
              //       child: const FilterRangeTextField(suffixText: 'max', hintText: '10000000+'),
              //     ),
              //   ],
              // ),

              // SizedBox(
              //   height: med.height * 0.02,
              // ),

              // SizedBox(
              //   height: med.height * 0.1,
              //   child: Stack(
              //     children: <Widget>[
              //       Align(
              //         alignment: Alignment.bottomCenter,
              //         child: Padding(
              //           padding: const EdgeInsets.only(bottom: 15),
              //           child: SizedBox(
              //             width: med.width,
              //             child: Row(
              //               crossAxisAlignment: CrossAxisAlignment.end,
              //               mainAxisSize: MainAxisSize.max,
              //               mainAxisAlignment: MainAxisAlignment.center,
              //               children: List.generate(
              //                 heightValues.length,
              //                 (index) => Container(
              //                   width: med.width / 15,
              //                   height: heightValues[index],
              //                   color: CustomAppTheme().greyColor,
              //                 ),
              //               ),
              //             ),
              //           ),
              //         ),
              //       ),
              //       Align(
              //         alignment: Alignment.bottomCenter,
              //         child: SizedBox(
              //           height: med.height * 0.03,
              //           // color: Colors.green,
              //           child: SfRangeSlider(
              //             min: 0,
              //             activeColor: CustomAppTheme().primaryColor,
              //             inactiveColor: CustomAppTheme().lightGreyColor,
              //             shouldAlwaysShowTooltip: false,
              //             max: 100,
              //             values: _values,
              //             interval: 20,
              //             stepSize: 1,
              //             showTicks: false,
              //             showLabels: false,
              //             enableTooltip: true,
              //             onChanged: (SfRangeValues values) {
              //               setState(() {
              //                 _values = values;
              //               });
              //             },
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),

              // SizedBox(
              //   height: med.height * 0.2,
              // ),
            ],
          ),
        ),
      ),
    );
  }

  final int minValue = 0;
  final int maxValue = 100000000;

  List<double> heightValues = [10, 1, 14, 8, 22, 34, 13, 3, 29, 15, 9];

  final SfRangeValues _values = const SfRangeValues(40.0, 80.0);

  List<String> optionValue = <String>[
    'All Salaries',
    '15000 - 30000',
    '30000 - 60000',
    '60000 - 100000',
    'Above 1 lac'
  ];
}
