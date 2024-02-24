import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_range_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PropertiesByArea extends StatefulWidget {
  const PropertiesByArea({Key? key}) : super(key: key);

  @override
  State<PropertiesByArea> createState() => _PropertiesByAreaState();
}

class _PropertiesByAreaState extends State<PropertiesByArea> {
  int selectedIndex = -1;
  TextEditingController minAreaController = TextEditingController();
  TextEditingController maxAreaController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel propertiesViewModel =
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
                'Select Range',
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
                        suffixText: 'min',
                        hintText: '0',
                        controller: minAreaController,
                        onChanged: (value) {
                          propertiesViewModel.propertyFilterData!.minArea =
                              int.parse(value);
                        }),
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
                        suffixText: 'max',
                        hintText: '10000000+',
                        controller: maxAreaController,
                        onChanged: (value) {
                          propertiesViewModel.propertyFilterData!.maxArea =
                              int.parse(value);
                        }),
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
              //                     (index) => Container(
              //                   width: med.width / 15,
              //                   height: heightValues[index],
              //                   color: Colors.grey.shade300,
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
}
