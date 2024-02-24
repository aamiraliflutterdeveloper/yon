import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertyByType extends StatefulWidget {
  const PropertyByType({Key? key}) : super(key: key);

  @override
  State<PropertyByType> createState() => _PropertyByTypeState();
}

class _PropertyByTypeState extends State<PropertyByType> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final PropertiesViewModel propertiesViewModel =
        context.read<PropertiesViewModel>();
    if (propertiesViewModel.propertyFilterMap!.containsKey('Type')) {
      for (int i = 0; i < typeOptionValue.length; i++) {
        if (typeOptionValue[i] ==
            propertiesViewModel.propertyFilterMap!['Type']) {
          selectedIndex = i;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    PropertiesViewModel propertiesViewModel =
        context.watch<PropertiesViewModel>();
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
                itemCount: typeOptionValue.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: typeOptionValue[index],
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      onTab: () {
                        propertiesViewModel.propertyFilterMap!.addEntries(
                            {MapEntry('Type', typeOptionValue[index])});
                        propertiesViewModel.changePropertyFilterMap(
                            propertiesViewModel.propertyFilterMap!);
                        propertiesViewModel.propertyFilterData!.type =
                            typeOptionValue[index];
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

  List<String> typeOptionValue = <String>[
    'Residential',
    'Agricultural',
    'Commercial',
    'Industrial Property'
  ];
}
