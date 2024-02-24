import 'package:app/common/logger/log.dart';
import 'package:app/data/models/general_res_models/all_currencies_res_model.dart';
import 'package:app/presentation/add_post/view_model/general_view_model.dart';
import 'package:app/presentation/add_post/widgets/custom_ad_post_widgets.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:app/presentation/utils/widgets/filter_range_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PropertiesByBudget extends StatefulWidget {
  const PropertiesByBudget({Key? key}) : super(key: key);

  @override
  State<PropertiesByBudget> createState() => _PropertiesByBudgetState();
}

class _PropertiesByBudgetState extends State<PropertiesByBudget> {
  int selectedIndex = -1;
  List<AllCurrenciesModel> currenciesList = [];
  String? currencyId;
  String? currencyDropDownValue;

  void getAllCurrencies() async {
    PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    final result = await context.read<GeneralViewModel>().getAllCurrencies();
    result.fold((l) {}, (r) {
      d('CURRENCIES ***********************************');
      currenciesList = r.response!;
      d(currenciesList.toString());
      context.read<GeneralViewModel>().changeCurrencies(r.response!);
      currencyDropDownValue =
          context.read<GeneralViewModel>().currenciesList[0];
      currencyId = r.response![0].id;
      propertiesViewModel.propertyFilterMap!
          .addEntries({MapEntry('Currency', r.response![0].code!)});
      propertiesViewModel
          .changePropertyFilterMap(propertiesViewModel.propertyFilterMap!);
      propertiesViewModel.propertyFilterData!.currency = currencyId;
      getBudgetLimits(currencyId!);
      setState(() {});
    });
  }

  void getBudgetLimits(String currencyId) async {
    PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    final result = await propertiesViewModel.getPropertiesFilterLimits(
        currencyId: currencyId);
    result.fold((l) {}, (r) {
      propertiesViewModel.changePropertiesFilterLimits(r.response!);
      d('PROPERTIES LIMITS **************************');
      d(propertiesViewModel.propertiesFilteredLimits.toString());
    });
  }

  @override
  void initState() {
    super.initState();
    PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    final generalViewModel = context.read<GeneralViewModel>();
    if (generalViewModel.allCurrenciesList.isEmpty) {
      getAllCurrencies();
    } else {
      if (propertiesViewModel.propertyFilterMap!.containsKey('Currency')) {
        currencyDropDownValue =
            propertiesViewModel.propertyFilterMap!['Currency'];
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

      if (propertiesViewModel.propertyFilterMap!.containsKey('Budget')) {
        for (int i = 0;
            i < propertiesViewModel.propertiesFilteredLimits!.length;
            i++) {
          if (propertiesViewModel.propertyFilterMap!['Budget']!.contains(
              propertiesViewModel.propertiesFilteredLimits![i].secondValue
                  .toString())) {
            selectedIndex = i;
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final GeneralViewModel generalViewModel = context.watch<GeneralViewModel>();
    final PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
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
                        currencyDropDownValue = value;
                        for (int i = 0;
                            i < generalViewModel.allCurrenciesList.length;
                            i++) {
                          if (generalViewModel.allCurrenciesList[i].code ==
                              value) {
                            currencyId =
                                generalViewModel.allCurrenciesList[i].id;
                            propertiesViewModel.propertyFilterData!.currency =
                                currencyId;
                            propertiesViewModel.propertyFilterMap!.addEntries({
                              MapEntry('Currency',
                                  generalViewModel.allCurrenciesList[i].code!)
                            });
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
                itemCount: propertiesViewModel.propertiesFilteredLimits!.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  String value1 = '';
                  String value2 = '';
                  value1 = propertiesViewModel
                              .propertiesFilteredLimits![index].firstValue ==
                          null
                      ? 'Above '
                      : propertiesViewModel
                              .propertiesFilteredLimits![index].firstValue
                              .toString() +
                          ' - ';
                  value2 = propertiesViewModel
                              .propertiesFilteredLimits![index].secondValue ==
                          null
                      ? ''
                      : propertiesViewModel
                          .propertiesFilteredLimits![index].secondValue
                          .toString();
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: value1 + value2,
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      totalCount: propertiesViewModel
                          .propertiesFilteredLimits![index].totalCount,
                      onTab: () {
                        setState(() {
                          if (propertiesViewModel
                                  .propertyFilterData!.currency ==
                              null) {
                            propertiesViewModel.propertyFilterData!.currency =
                                "d7cad087-e7d7-4108-aa18-e07abde98ede";
                          }
                          selectedIndex = index;
                          propertiesViewModel.propertyFilterMap!.addEntries(
                              {MapEntry('Budget', value1 + value2)});
                          propertiesViewModel.changePropertyFilterMap(
                              propertiesViewModel.propertyFilterMap!);
                          if (selectedIndex == 4) {
                            propertiesViewModel.propertyFilterData!.minPrice =
                                propertiesViewModel
                                    .propertiesFilteredLimits![index]
                                    .secondValue;
                            propertiesViewModel.propertyFilterData!.maxPrice =
                                null;
                          } else {
                            propertiesViewModel.propertyFilterData!.minPrice =
                                propertiesViewModel
                                    .propertiesFilteredLimits![index]
                                    .firstValue;
                            propertiesViewModel.propertyFilterData!.maxPrice =
                                propertiesViewModel
                                    .propertiesFilteredLimits![index]
                                    .secondValue;
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
              Row(
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
                      suffixText: 'min',
                      hintText: '0',
                      onChanged: (val) {
                        propertiesViewModel.propertyFilterData!.minPrice =
                            int.parse(val);
                      },
                    ),
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
                      suffixText: 'max',
                      hintText: '10000000+',
                      onChanged: (val) {
                        propertiesViewModel.propertyFilterData!.maxPrice =
                            int.parse(val);
                      },
                    ),
                  ),
                ],
              ),

              SizedBox(
                height: med.height * 0.02,
              ),

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
