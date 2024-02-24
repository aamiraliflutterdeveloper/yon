import 'package:app/presentation/automotive/view_model/automotive_view_model.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/filter_option_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AutomotiveByTransmission extends StatefulWidget {
  const AutomotiveByTransmission({Key? key}) : super(key: key);

  @override
  State<AutomotiveByTransmission> createState() => _AutomotiveByTransmissionState();
}

class _AutomotiveByTransmissionState extends State<AutomotiveByTransmission> {
  int selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    final AutomotiveViewModel autoViewModel = context.read<AutomotiveViewModel>();
    if(autoViewModel.automotiveFilterMap!.containsKey('Transmission')){
      for(int i=0; i<transmissionOptionValue.length; i++){
        if(autoViewModel.automotiveFilterMap!['Transmission'] == transmissionOptionValue[i]){
          selectedIndex = i;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    AutomotiveViewModel automotiveViewModel = context.watch<AutomotiveViewModel>();
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
                itemCount: transmissionOptionValue.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: FilterOptionWidget(
                      value: transmissionOptionValue[index],
                      selectedIndex: selectedIndex,
                      currentIndex: index,
                      onTab: () {
                        automotiveViewModel.automotiveFilterMap!.addEntries({MapEntry('Transmission', transmissionOptionValue[index])});
                        automotiveViewModel.changeAutoFilterMap(automotiveViewModel.automotiveFilterMap!);
                        automotiveViewModel.automotiveFilterData!.transmissionType = transmissionOptionValue[index];
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

  List<String> transmissionOptionValue = <String>['Automatic', 'Manual'];
}
