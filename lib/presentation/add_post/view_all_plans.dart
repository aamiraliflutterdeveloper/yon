import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:app/presentation/utils/widgets/paymentPlans_widget.dart';
import 'package:flutter/material.dart';

class ViewAllPlansScreen extends StatefulWidget {
  const ViewAllPlansScreen({Key? key}) : super(key: key);

  @override
  State<ViewAllPlansScreen> createState() => _ViewAllPlansScreenState();
}

class _ViewAllPlansScreenState extends State<ViewAllPlansScreen> {
  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Featured Ad', context: context, onTap: () {Navigator.of(context).pop();}),
      body: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        physics: const BouncingScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, index){
          return const Padding(
            padding: EdgeInsets.only(bottom: 20),
            child: PaymentPlanWidget(),
          );
        },
      ),
    );
  }
}
