import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/classified/view_model/classified_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:app/presentation/utils/widgets/filter_range_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ClassifiedByBudget extends StatefulWidget {
  const ClassifiedByBudget({Key? key}) : super(key: key);

  @override
  State<ClassifiedByBudget> createState() => _ClassifiedByBudgetState();
}

class _ClassifiedByBudgetState extends State<ClassifiedByBudget> {
  int selectedIndex = -1;
  String? currencyDropDownValue;
  List<AllCurrenciesModel> currenciesList = [];
  String? currencyId;

  void getAllCurrencies() async {
    final ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      currencyDropDownValue =
          context.read<GeneralViewModel>().currenciesList[0];
      currencyId = r.response![0].id;
      context
          .read<ClassifiedViewModel>()
          .classifiedFilterMap!
          .addEntries({MapEntry('Currency', r.response![0].code!)});
      getBudgetLimits(currencyId!);
      classifiedViewModel.classifiedFilterData!.currency = currencyId;
      setState(() {});
    });
  }

  void getBudgetLimits(String currencyId) async {
    ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final result = await classifiedViewModel.getClassifiedFilterLimits(
        currencyId: currencyId);
    result.fold((l) {}, (r) {
      classifiedViewModel.changeClassifiedFilterLimits(r.response!);
      d('CLASSIFIED LIMITS **************************');
      d(classifiedViewModel.classifiedFilteredLimits.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    final ClassifiedViewModel classifiedViewModel =
        context.read<ClassifiedViewModel>();
    final generalViewModel = context.read<GeneralViewModel>();
    if (generalViewModel.allCurrenciesList.isEmpty) {
      getAllCurrencies();
    } else {
      if (classifiedViewModel.classifiedFilterMap!.containsKey('Currency')) {
        currencyDropDownValue =
            classifiedViewModel.classifiedFilterMap!['Currency'];
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

      if (classifiedViewModel.classifiedFilterMap!.containsKey('Budget')) {
        for (int i = 0;
            i < classifiedViewModel.classifiedFilteredLimits!.length;
            i++) {
          if (classifiedViewModel.classifiedFilterMap!['Budget']!.contains(
              classifiedViewModel.classifiedFilteredLimits![i].secondValue
                  .toString())) {
            selectedIndex = i;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final ClassifiedViewModel classifiedViewModel =
        context.watch<ClassifiedViewModel>();
    final GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
    Size med = MediaQuery.of(context).size;
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
                        classifiedViewModel.classifiedFilterMap!
                            .addEntries({MapEntry('Currency', value!)});
                        classifiedViewModel.classifiedFilterMap!
                            .removeWhere((key, value) => key == 'Budget');
                        classifiedViewModel.classifiedFilterData!.minPrice =
                            null;
                        classifiedViewModel.classifiedFilterData!.maxPrice =
                            null;
                        selectedIndex = -1;
                        currencyDropDownValue = value;
                        for (int i = 0;
                            i < generalViewModel.allCurrenciesList.length;
                            i++) {
                          if (generalViewModel.allCurrenciesList[i].code ==
                              value) {
                            currencyId =
                                generalViewModel.allCurrenciesList[i].id;
                            classifiedViewModel.classifiedFilterData!.currency =
                                currencyId;
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

              classifiedViewModel.classifiedFilteredLimits!.isEmpty
                  ? Container()
                  : Text(
                      'Choose from option below',
                      style: CustomAppTheme().textFieldHeading,
                    ),
              classifiedViewModel.classifiedFilteredLimits!.isEmpty
                  ? Container()
                  : SizedBox(
                      height: med.height * 0.02,
                    ),

              classifiedViewModel.classifiedFilteredLimits!.isEmpty
                  ? Container()
                  : ListView.builder(
                      itemCount:
                          classifiedViewModel.classifiedFilteredLimits!.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        String value1 = '';
                        String value2 = '';
                        value1 = classifiedViewModel
                                    .classifiedFilteredLimits![index]
                                    .firstValue ==
                                null
                            ? 'Above '
                            : classifiedViewModel
                                    .classifiedFilteredLimits![index].firstValue
                                    .toString() +
                                ' - ';
                        value2 = classifiedViewModel
                                    .classifiedFilteredLimits![index]
                                    .secondValue ==
                                null
                            ? ''
                            : classifiedViewModel
                                .classifiedFilteredLimits![index].secondValue
                                .toString();
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 5),
                          child: FilterOptionWidget(
                            value: value1 + value2,
                            selectedIndex: selectedIndex,
                            currentIndex: index,
                            totalCount: classifiedViewModel
                                .classifiedFilteredLimits![index].totalCount,
                            onTab: () {
                              classifiedViewModel.classifiedFilterMap!
                                  .addEntries(
                                      {MapEntry('Budget', value1 + value2)});
                              classifiedViewModel.changeClassifiedFilterMap(
                                  classifiedViewModel.classifiedFilterMap!);
                              setState(() {
                                selectedIndex = index;
                                if (selectedIndex == 4) {
                                  classifiedViewModel
                                          .classifiedFilterData!.minPrice =
                                      classifiedViewModel
                                          .classifiedFilteredLimits![index]
                                          .secondValue;
                                } else {
                                  classifiedViewModel
                                          .classifiedFilterData!.minPrice =
                                      classifiedViewModel
                                          .classifiedFilteredLimits![index]
                                          .firstValue;
                                  classifiedViewModel
                                          .classifiedFilterData!.maxPrice =
                                      classifiedViewModel
                                          .classifiedFilteredLimits![index]
                                          .secondValue;
                                }
                              });
                            },
                          ),
                        );
                      },
                    ),

              classifiedViewModel.classifiedFilteredLimits!.isEmpty
                  ? Container()
                  : SizedBox(
                      height: med.height * 0.01,
                    ),

              //Divider
              classifiedViewModel.classifiedFilteredLimits!.isEmpty
                  ? Container()
                  : Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(right: 10.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 36,
                            ),
                          ),
                        ),
                        Text(
                          "or",
                          style: CustomAppTheme()
                              .normalText
                              .copyWith(fontWeight: FontWeight.w500),
                        ),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 10.0),
                            child: const Divider(
                              color: Colors.black,
                              height: 36,
                            ),
                          ),
                        ),
                      ],
                    ),

              SizedBox(
                height: med.height * 0.01,
              ),

              Text(
                'Choose from option below',
                style: CustomAppTheme().textFieldHeading,
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  SizedBox(
                    width: med.width * 0.4,
                    child: FilterRangeTextField(
                        textInputType: TextInputType.number,
                        onChanged: (val) {
                          classifiedViewModel.classifiedFilterData!.minPrice =
                              int.parse(val);
                          setState(() {});
                        },
                        suffixText: 'min',
                        hintText: '0'),
                  ),
                  Text(
                    'to',
                    style: CustomAppTheme()
                        .normalText
                        .copyWith(fontWeight: FontWeight.w500),
                  ),
                  SizedBox(
                    width: med.width * 0.4,
                    child: FilterRangeTextField(
                        textInputType: TextInputType.number,
                        onChanged: (val) {
                          classifiedViewModel.classifiedFilterData!.maxPrice =
                              int.parse(val);
                          setState(() {});
                        },
                        suffixText: 'max',
                        hintText: '10000000+'),
                  ),
                ],
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: SizedBox(
              //     height: med.height * 0.03,
              //     // color: Colors.green,
              //     child: SfRangeSlider(
              //       min: 0,
              //       activeColor: CustomAppTheme().primaryColor,
              //       inactiveColor: CustomAppTheme().lightGreenColor,
              //       shouldAlwaysShowTooltip: false,
              //       max: 1000,
              //       values: _values,
              //       interval: 1,
              //       stepSize: 1.0,
              //       showTicks: false,
              //       showLabels: false,
              //       enableTooltip: true,
              //       onChanged: (SfRangeValues values) {
              //         setState(() {
              //           _values = values;
              //         });
              //       },
              //     ),
              //   ),
              // ),

              SizedBox(
                height: med.height * 0.2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  final int minValue = 0;
  final int maxValue = 10000;

  List<double> heightValues = [10, 1, 14, 8, 22, 34, 13, 3, 29, 15, 9];

  final SfRangeValues _values = const SfRangeValues(0.0, 90.0);

  List<String> optionValue = <String>[
    'Below 15000',
    '15000 - 30000',
    '30000 - 60000',
    '60000 - 100000',
    'Above 1 lac'
  ];
}
