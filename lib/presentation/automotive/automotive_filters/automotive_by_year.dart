import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertiesByYear extends StatefulWidget {
  const PropertiesByYear({Key? key}) : super(key: key);

  @override
  State<PropertiesByYear> createState() => _PropertiesByYearState();
}

class _PropertiesByYearState extends State<PropertiesByYear> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final AutomotiveViewModel autoViewModel =
        context.read<AutomotiveViewModel>();
    if (autoViewModel.automotiveFilterMap!.containsKey('Year')) {
      for (int i = 0; i < optionValue.length; i++) {
        if (autoViewModel.automotiveFilterMap!['Year'] == optionValue[i]) {
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
                              {MapEntry('Year', optionValue[index])});
                          automotiveViewModel.changeAutoFilterMap(
                              automotiveViewModel.automotiveFilterMap!);
                          if (index == 0) {
                            automotiveViewModel.automotiveFilterData!.minYear =
                                DateTime.now().year - 3;
                            automotiveViewModel.automotiveFilterData!.maxYear =
                                null;
                          } else if (index == 1) {
                            automotiveViewModel.automotiveFilterData!.minYear =
                                DateTime.now().year - 5;
                            automotiveViewModel.automotiveFilterData!.maxYear =
                                null;
                          } else if (index == 2) {
                            automotiveViewModel.automotiveFilterData!.minYear =
                                DateTime.now().year - 7;
                            automotiveViewModel.automotiveFilterData!.maxYear =
                                null;
                          } else if (index == 3) {
                            automotiveViewModel.automotiveFilterData!.minYear =
                                DateTime.now().year - 10;
                            automotiveViewModel.automotiveFilterData!.maxYear =
                                null;
                          } else if (index == 4) {
                            automotiveViewModel.automotiveFilterData!.maxYear =
                                DateTime.now().year - 10;
                            automotiveViewModel.automotiveFilterData!.minYear =
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

  List<String> optionValue = <String>[
    'Under 3 Years',
    'Under 5 Years',
    'Under 7 Years',
    'Under 10 Years',
    '10 Years and above'
  ];
}
