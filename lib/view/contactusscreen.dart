import 'package:flutter/material.dart';
import 'package:trackerapp/res/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  _launchURLBrowser(String link) async {
    var url = Uri.parse(link);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: DecoratedBox(
        decoration: AppColors.appScreenBackgroundImage,
        child: Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            title: Text(
              'Contact Us',
              style: AppColors.appTitleTextStyle,
            ),
            elevation: 0,
            backgroundColor: Colors.transparent,
            centerTitle: false,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Padding(
                      padding: EdgeInsets.all(50.0),
                      child: Image(
                        width: 180,
                        image: AssetImage(AppColors.logoPath),
                      ),
                    ),
                  ],
                ),
                // Container(
                //   //height: 30,
                //   width: MediaQuery.of(context).size.width,
                //   color: AppColors.buttonColor,
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.center,
                //     crossAxisAlignment: CrossAxisAlignment.start,
                //     children: [
                //       Padding(
                //         padding: const EdgeInsets.all(5.0),
                //         child: Row(
                //           children: const [
                //             Icon(Icons.contact_phone),
                //             VerticalDivider(),
                //             Text(
                //               'Contact Us',
                //               style: TextStyle(
                //                   fontWeight: FontWeight.bold, fontSize: 14),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(
                  height: 0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => _launchURLBrowser('tel:+922137224295'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        child: const Image(
                          image: AssetImage('assets/images/Phone_96px.png'),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _launchURLBrowser('mailto:mail@autotel.pk'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        child: const Image(
                          image:
                              AssetImage('assets/images/Send Email_96px.png'),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _launchURLBrowser('https://autotel.pk'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        child: const Image(
                          image: AssetImage('assets/images/Globe_96px.png'),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () => _launchURLBrowser(
                          'https://wa.me/923111100353?text=I need information on tracker services'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        child: const Image(
                          image: AssetImage('assets/images/WhatsApp_96px.png'),
                          width: 48,
                          height: 48,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _launchURLBrowser(
                          'https://www.facebook.com/Autotelematics?mibextid=LQQJ4d'),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        child: const Image(
                          image: AssetImage('assets/images/facebook.png'),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () => _launchURLBrowser(
                          'https://instagram.com/autotelematics?igshid=YmMyMTA2M2Y='),
                      child: CircleAvatar(
                        radius: 30,
                        backgroundColor: Colors.grey[100],
                        child: const Image(
                          image: AssetImage('assets/images/Instagram_96px.png'),
                          width: 40,
                          height: 40,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 15,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            _launchURLBrowser('https://autotel.pk/news/'),
                        child: Card(
                          shape: AppColors.cardBorderShape,
                          child: const ListTile(
                            title: Text(
                              'Terms and Conditions',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 15,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () => _launchURLBrowser(
                            'https://autotel.pk/privacy-and-policy/'),
                        child: Card(
                          shape: AppColors.cardBorderShape,
                          child: const ListTile(
                            title: Text(
                              'Privacy Policy',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 15,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () =>
                            _launchURLBrowser('https://autotel.pk/news/'),
                        child: Card(
                          shape: AppColors.cardBorderShape,
                          child: const ListTile(
                            title: Text(
                              'Company News',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  'Office Address',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                const Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Text(
                    textAlign: TextAlign.center,
                    'A-512, 5th Floor, Saima Trade Towers,\n I.I Chundrigar Road, Karachi, Pakistan',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black54),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
