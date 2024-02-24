import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:flutter/material.dart';

class PaymentPlanWidget extends StatelessWidget {
  const PaymentPlanWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Container(
        alignment: Alignment.center,
        width: med.width * 0.9,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              spreadRadius: 4,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Standard Plan',
                    style: CustomAppTheme().headingText.copyWith(fontSize: 18),
                  ),

                  SizedBox(
                    height: med.height*0.02,
                  ),

                  Text('\u2022 5 featured ads per week',
                    style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text('\u2022 20 Ads per week',
                      style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: Text('\u2022 Customer Support',
                      style: CustomAppTheme().normalText.copyWith(fontSize: 12),
                    ),
                  ),

                  SizedBox(
                    height: med.height*0.02,
                  ),

                  Container(
                    decoration: BoxDecoration(
                      color: CustomAppTheme().primaryColor,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
                      child: Text('Buy Now',
                        style: CustomAppTheme().normalText.copyWith(color: CustomAppTheme().backgroundColor, fontWeight: FontWeight.w600, fontSize: 10),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('AED',
                    style: CustomAppTheme().normalText.copyWith(fontSize: 15, fontWeight: FontWeight.w600, color: CustomAppTheme().primaryColor),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Row(
                      children: <Widget>[
                        Text('325',
                          style: CustomAppTheme().headingText.copyWith(fontSize: 30),
                        ),
                        Text(' / Mon',
                          style: CustomAppTheme().normalText.copyWith(fontSize: 14, fontWeight: FontWeight.w500),
                        )
                      ],
                    ),
                  )
                ],
              ),

            ],
          ),
        )
    );
  }
}
