import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_range_textfield.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PropertyByBedroom extends StatefulWidget {
  const PropertyByBedroom({Key? key}) : super(key: key);

  @override
  State<PropertyByBedroom> createState() => _PropertyByBedroomState();
}

class _PropertyByBedroomState extends State<PropertyByBedroom> {

  TextEditingController bedroomController = TextEditingController();

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
                'Enter number of Bedrooms',
                style: CustomAppTheme().textFieldHeading,
              ),
              SizedBox(
                height: med.height * 0.02,
              ),
              SizedBox(
                height: 55,
                child: YouOnlineNumberField(
                  onChanged: (val) {
                    setState(() {
                      propertiesViewModel.propertyFilterData!.bedrooms = int.parse(val);
                    });
                  },
                    keyboardType: TextInputType.number,
                    hasHeading: false,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return '';
                      } else {
                        return null;
                      }
                    },
                    headingText: '',
                    hintText: 'Enter Number',
                    controller: bedroomController)),
              SizedBox(
                height: med.height * 0.02,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
