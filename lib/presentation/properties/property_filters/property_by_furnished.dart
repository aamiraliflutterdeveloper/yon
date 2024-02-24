import 'package:app/presentation/properties/view_model/properties_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_range_textfield.dart';
import 'package:app/presentation/utils/widgets/youonline_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class PropertyByFurnished extends StatefulWidget {
  const PropertyByFurnished({Key? key}) : super(key: key);

  @override
  State<PropertyByFurnished> createState() => _PropertyByFurnishedState();
}

class _PropertyByFurnishedState extends State<PropertyByFurnished> {

  FURNISHSTATUS _status = FURNISHSTATUS.Furnished;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    PropertiesViewModel propertiesViewModel =
    context.watch<PropertiesViewModel>();
    propertiesViewModel.propertyFilterData!.furnished = _status.name;
    print(propertiesViewModel.propertyFilterData!.furnished);
    print("hahhahahahahha");
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
                'Select Furnished',
                style: CustomAppTheme().textFieldHeading,
              ),
              SizedBox(
                height: med.height * 0.02,
              ),

              Column(
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Furnished'),
                    leading: Radio(
                      value: FURNISHSTATUS.Furnished,
                      groupValue: _status,
                      onChanged: (FURNISHSTATUS? value) {
                        setState(() {
                          _status = value!;
                          propertiesViewModel.propertyFilterData!.furnished = _status.name;
                        });
                      },
                    ),
                  ),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('UnFurnished'),
                    leading: Radio(
                      value: FURNISHSTATUS.Unfurnished,
                      groupValue: _status,
                      onChanged: (FURNISHSTATUS? value) {
                        setState(() {
                          _status = value!;
                          propertiesViewModel.propertyFilterData!.furnished = _status.name;
                        });
                      },
                    ),
                  ),
                ],
              ),

              // SizedBox(
              //     height: 55,
              //     child: YouOnlineNumberField(
              //         onChanged: (val) {
              //           setState(() {
              //             propertiesViewModel.propertyFilterData!.bedrooms = int.parse(val);
              //           });
              //         },
              //         keyboardType: TextInputType.number,
              //         hasHeading: false,
              //         validator: (val) {
              //           if (val!.isEmpty) {
              //             return '';
              //           } else {
              //             return null;
              //           }
              //         },
              //         headingText: '',
              //         hintText: 'Enter Number',
              //         controller: bedroomController)),
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

enum FURNISHSTATUS { Unfurnished, Furnished }



