import 'package:app/presentation/utils/customAppTheme.dart';
import 'package:app/presentation/utils/widgets/customAppBar.dart';
import 'package:flutter/material.dart';


class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size med = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: CustomAppTheme().backgroundColor,
      appBar: customAppBar(title: 'Terms and Conditions', context: context, onTap: () {Navigator.of(context).pop();}),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              SizedBox(
                height: med.height*0.02,
              ),
              const TermsAndConditionWidget(
                headerText: '1- Who can use our Services:',
                bodyText:
                    'You can use our services if you will agree to the following terms and conditions:\n'
                    'Your age must be 13 years old.\n'
                    'If you are using our services on account of an organization, or any other legal authority, you must show a warrant that you have proper direction and permission to do so.',
              ),
              const TermsAndConditionWidget(
                headerText: '2- Content Sharing:',
                bodyText:
                    'It is your responsibility to provide content and use our services that make you feel comfortable including laws and regulations. Any content that you will publish or share through our service will be your responsibility. We do not guarantee and support the reliability of any communication or content published through our services. We cannot monitor any content being posted by any person whether it is false or misleading.',
              ),
              const TermsAndConditionWidget(
                headerText: '3- Our Privacy Policy:',
                bodyText:
                    'It is described under our privacy policy that how we handle the information that you share with us while using our services. It is also mentioned that we may store and process your information to improve our services.',
              ),
              const TermsAndConditionWidget(
                headerText: '4- Our Services:',
                bodyText:
                    'Our services are constantly changing. We can temporarily or permanently stop providing our services to you. We have the right to put a limit on your use or storage of our services. We have the authority to limit or refuse distribution, suspend, and retrieve usernames without your liability. For our certain services, we might charge you a fee. You cannot misuse our services.',
              ),
              const TermsAndConditionWidget(
                headerText: '5- Grant of Rights:',
                bodyText:
                    'You preserve the rights to any content or post that you submit through our services. You owe your post and content. When you submit it through our platform, then you allow users across the globe to use your content unconditionally. You must have a warrant that shows consent and permission for the information you have submitted.',
              ),
              const TermsAndConditionWidget(
                headerText: '6- General:',
                bodyText:
                    'We can revise our terms and conditions with time. Whenever a change will take place, we will notify you and after agreeing on those terms and conditions you can use our services.',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TermsAndConditionWidget extends StatelessWidget {
  const TermsAndConditionWidget({
    Key? key,
    required this.headerText,
    required this.bodyText,
  }) : super(key: key);

  final String headerText, bodyText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          headerText,
          style: CustomAppTheme().normalText.copyWith(fontWeight: FontWeight.w600),
          textScaleFactor: 1,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height*0.02,
        ),
        Text(
          bodyText,
          style: CustomAppTheme().normalText,
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height*0.02,
        ),
      ],
    );
  }
}
