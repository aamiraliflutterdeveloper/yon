import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:app/presentation/utils/widgets/filter_range_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class AutomotiveByBudget extends StatefulWidget {
  const AutomotiveByBudget({Key? key}) : super(key: key);

  @override
  State<AutomotiveByBudget> createState() => _AutomotiveByBudgetState();
}

class _AutomotiveByBudgetState extends State<AutomotiveByBudget> {
  int selectedIndex = -1;
  List<AllCurrenciesModel> currenciesList = [];
  String? currencyId;
  String? currencyDropDownValue;

  void getAllCurrencies() async {
    final AutomotiveViewModel autoViewModel =
        context.read<AutomotiveViewModel>();
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      currencyDropDownValue =
          context.read<GeneralViewModel>().currenciesList[0];
      currencyId = r.response![0].id;
      autoViewModel.automotiveFilterMap!
          .addEntries({MapEntry('Currency', r.response![0].code!)});
      autoViewModel.changeAutoFilterMap(autoViewModel.automotiveFilterMap!);
      autoViewModel.automotiveFilterData!.currency = currencyId;
      getBudgetLimits(currencyId!);
      setState(() {});
    });
  }

  void getBudgetLimits(String currencyId) async {
    AutomotiveViewModel classifiedViewModel =
        context.read<AutomotiveViewModel>();
    final result =
        await classifiedViewModel.getAutoFilterLimits(currencyId: currencyId);
    result.fold((l) {}, (r) {
      classifiedViewModel.changeAutoFilterLimits(r.response!);
      d('AUTO LIMITS **************************');
      d(classifiedViewModel.autoFilteredLimits.toString());
    });
  }

  @override
  void initState() {
    super.initState();

    final AutomotiveViewModel autoViewModel =
        context.read<AutomotiveViewModel>();
    final generalViewModel = context.read<GeneralViewModel>();
    if (generalViewModel.allCurrenciesList.isEmpty) {
      getAllCurrencies();
    } else {
      // currencyDropDownValue = context.read<GeneralViewModel>().currenciesList[0];
      // currencyId = context.read<GeneralViewModel>().allCurrenciesList[0].id;
      // autoViewModel.automotiveFilterData!.currency = currencyId;
      // getBudgetLimits(currencyId!);
      if (autoViewModel.automotiveFilterMap!.containsKey('Currency')) {
        currencyDropDownValue = autoViewModel.automotiveFilterMap!['Currency'];
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

      if (autoViewModel.automotiveFilterMap!.containsKey('Budget')) {
        for (int i = 0; i < autoViewModel.autoFilteredLimits!.length; i++) {
          if (autoViewModel.automotiveFilterMap!['Budget']!.contains(
              autoViewModel.autoFilteredLimits![i].secondValue.toString())) {
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
    final AutomotiveViewModel autoViewModel =
        context.watch<AutomotiveViewModel>();
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
                            autoViewModel.automotiveFilterData!.currency =
                                currencyId;
                            autoViewModel.automotiveFilterMap!.addEntries(
                                {MapEntry('Currency', currencyDropDownValue!)});
                            autoViewModel.automotiveFilterMap!
                                .removeWhere((key, value) => key == 'Budget');
                            autoViewModel.changeAutoFilterMap(
                                autoViewModel.automotiveFilterMap!);
                            getBudgetLimits(currencyId!);
                            selectedIndex = -1;
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
                itemCount: autoViewModel.autoFilteredLimits!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String value1 = '';
                  String value2 = '';
                  value1 =
                      autoViewModel.autoFilteredLimits![index].firstValue ==
                              null
                          ? 'Above '
                          : autoViewModel.autoFilteredLimits![index].firstValue
                                  .toString() +
                              ' -';
                  value2 =
                      autoViewModel.autoFilteredLimits![index].secondValue ==
                              null
                          ? ''
                          : autoViewModel.autoFilteredLimits![index].secondValue
                              .toString();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: value1 + value2,
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      totalCount:
                          autoViewModel.autoFilteredLimits![index].totalCount,
                      onTab: () {
                        setState(() {
                          if (autoViewModel.automotiveFilterData!.currency ==
                              null) {
                            autoViewModel.automotiveFilterData!.currency =
                                "d7cad087-e7d7-4108-aa18-e07abde98ede";
                          }
                          selectedIndex = index;
                          autoViewModel.automotiveFilterMap!.addEntries(
                              {MapEntry('Budget', value1 + value2)});
                          autoViewModel.changeAutoFilterMap(
                              autoViewModel.automotiveFilterMap!);
                          if (selectedIndex == 4) {
                            autoViewModel.automotiveFilterData!.minPrice =
                                autoViewModel
                                    .autoFilteredLimits![index].secondValue;
                          } else {
                            autoViewModel.automotiveFilterData!.minPrice =
                                autoViewModel
                                    .autoFilteredLimits![index].firstValue;
                            autoViewModel.automotiveFilterData!.maxPrice =
                                autoViewModel
                                    .autoFilteredLimits![index].secondValue;
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

              //Divider
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
    'Below 2 Lac',
    '2 Lacs - 5 Lacs',
    '5 Lacs - 20 Lacs',
    '20 Lacs - 50 Lacs',
    'Above 50 Lacs'
  ];
}
