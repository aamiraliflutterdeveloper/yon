import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:app/presentation/utils/widgets/filter_range_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PropertiesByKMDriven extends StatefulWidget {
  const PropertiesByKMDriven({Key? key}) : super(key: key);

  @override
  State<PropertiesByKMDriven> createState() => _PropertiesByKMDrivenState();
}

class _PropertiesByKMDrivenState extends State<PropertiesByKMDriven> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final AutomotiveViewModel autoViewModel =
        context.read<AutomotiveViewModel>();
    if (autoViewModel.automotiveFilterMap!.containsKey('Driven')) {
      for (int i = 0; i < optionValue.length; i++) {
        if (autoViewModel.automotiveFilterMap!['Driven'] == optionValue[i]) {
          selectedIndex = i;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AutomotiveViewModel automotiveViewModel =
        context.watch<AutomotiveViewModel>();
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
              ListView.builder(
                itemCount: 5,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: optionValue[index],
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      onTab: () {
                        setState(() {
                          selectedIndex = index;
                          automotiveViewModel.automotiveFilterMap!.addEntries(
                              {MapEntry('Driven', optionValue[index])});
                          automotiveViewModel.changeAutoFilterMap(
                              automotiveViewModel.automotiveFilterMap!);
                          if (index == 0) {
                            automotiveViewModel.automotiveFilterData!.maxKm =
                                25000;
                          } else if (index == 1) {
                            automotiveViewModel.automotiveFilterData!.minKm =
                                25000;
                            automotiveViewModel.automotiveFilterData!.maxKm =
                                50000;
                          } else if (index == 2) {
                            automotiveViewModel.automotiveFilterData!.minKm =
                                50000;
                            automotiveViewModel.automotiveFilterData!.maxKm =
                                75000;
                          } else if (index == 3) {
                            automotiveViewModel.automotiveFilterData!.minKm =
                                75000;
                            automotiveViewModel.automotiveFilterData!.maxKm =
                                100000;
                          } else if (index == 4) {
                            automotiveViewModel.automotiveFilterData!.minKm =
                                100000;
                            automotiveViewModel.automotiveFilterData!.maxKm =
                                null;
                          }
                        });
                      },
                    ),
                  );
                },
              ),

              // SizedBox(
              //   height: med.height * 0.01,
              // ),

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
              //                     (index) => Container(
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

  List<double> heightValues = [2, 14, 2, 18, 12, 30, 13, 32, 6, 15, 9];

  final SfRangeValues _values = const SfRangeValues(40.0, 80.0);

  List<String> optionValue = <String>[
    'Below 25000 KM',
    '25000 -50000 KM',
    '50000 - 75000 KM',
    '75000 - 100000 KM',
    'Above 100000 KM'
  ];
}
