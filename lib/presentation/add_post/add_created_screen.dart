import 'package:app/presentation/home/home_screen.dart';
import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/youonline_button.dart';
import 'package:flutter/material.dart';

class CreatedSuccessfullyScreen extends StatefulWidget {
  const CreatedSuccessfullyScreen({Key? key}) : super(key: key);

  @override
  State<CreatedSuccessfullyScreen> createState() => _CreatedSuccessfullyScreenState();
}

class _CreatedSuccessfullyScreenState extends State<CreatedSuccessfullyScreen> {
  Future<bool> onWillPop() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
    return Future.value(true);
  }

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        backgroundColor: CustomAppTheme().backgroundColor,
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: med.height * 0.2,
              ),
              Center(
                child: Image.asset(
                  'assets/images/successful_Illustration.png',
                  height: med.height * 0.3,
                  width: med.width * 0.85,
                ),
                /*SvgPicture.asset(
                  'assets/svgs/successfullyCreated.svg',
                  height: med.height*0.3,
                  width: med.width*0.85,
                ),*/
              ),
              SizedBox(
                height: med.height * 0.08,
              ),
              Text(
                'Ad Created Successfully',
                style: CustomAppTheme().headingText,
              ),
              /*SizedBox(
                height: med.height * 0.015,
              ),
              Text(
                'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                textAlign: TextAlign.center,
                style: CustomAppTheme().normalGreyText.copyWith(fontSize: 12),
              ),*/
              const Spacer(),
              SizedBox(
                width: med.width,
                child: YouOnlineButton(
                    text: 'Back To Home',
                    onTap: () {
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (route) => false);
                    }),
              ),
              SizedBox(
                height: med.height * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
