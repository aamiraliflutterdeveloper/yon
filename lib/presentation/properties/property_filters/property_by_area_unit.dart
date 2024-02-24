import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PropertyByAreaUnit extends StatefulWidget {
  const PropertyByAreaUnit({Key? key}) : super(key: key);

  @override
  State<PropertyByAreaUnit> createState() => _PropertyByAreaUnitState();
}

class _PropertyByAreaUnitState extends State<PropertyByAreaUnit> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    PropertiesViewModel propertiesViewModel = context.read<PropertiesViewModel>();
    if(propertiesViewModel.propertyFilterMap!.containsKey('AreaUnit')){
      for(int i=0; i<areaUnitOptionValue.length; i++){
        if(areaUnitOptionValue[i] == propertiesViewModel.propertyFilterMap!['AreaUnit']){
          selectedIndex = i;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    PropertiesViewModel propertiesViewModel = context.watch<PropertiesViewModel>();
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
                itemCount: areaUnitOptionValue.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: areaUnitOptionValue[index],
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      onTab: () {
                        propertiesViewModel.propertyFilterMap!.addEntries({MapEntry('AreaUnit', areaUnitOptionValue[index])});
                        propertiesViewModel.changePropertyFilterMap(propertiesViewModel.propertyFilterMap!);
                        setState(() {
                          propertiesViewModel.propertyFilterData!.areaUnit = areaUnitOptionValue[index].replaceAll(' ', '');
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

  List<String> areaUnitOptionValue = <String>['All', 'Kanal', 'Marla', 'Square Feet', 'Square Meter', 'Square Yard'];
}