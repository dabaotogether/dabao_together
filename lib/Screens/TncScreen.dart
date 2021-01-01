import 'package:flutter/material.dart';

class TncScreen extends StatelessWidget {
  static const String id = 'tnc_screen';
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          floatingActionButtonLocation: FloatingActionButtonLocation.miniEndTop,
          floatingActionButton: FloatingActionButton(
              heroTag: "floatingbuttonTnC",
              backgroundColor: Colors.white,
              child: Icon(
                Icons.cancel_rounded,
                color: Colors.black,
                size: 50,
              ),
              elevation: 20,
              onPressed: () {
                Navigator.pop(context);
              }),
          body: ListView(
            children: <Widget>[
              SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Terms & Conditions',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text:
                        'By downloading, browsing, accessing or using this Dabao Together Mobile Application, you agree to be bound by these Terms and Conditions of Use. We reserve the right to amend these terms and conditions at any time. If you disagree with any of these Terms and Conditions of Use, you must immediately discontinue your access to the Dabao Together Mobile Application and your use of the services offered on the Dabao Together Mobile Application. Continued use of the Dabao Together Mobile Application will constitute acceptance of these Terms and Conditions of Use, as may be amended from time to time. ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Terms of Use',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• The developer is committed to ensuring that the app is as useful and efficient as possible. For that reason, we reserve the right to make changes to the app or to charge for its services, at any time and for any reason. We will never charge you for the app or its services without making it very clear to you exactly what you’re paying for. ',
              ),
              buildText(
                '• The Dabao Together Mobile Application stores and processes personal data that you have provided to us, in order to provide my Service. It’s your responsibility to keep your phone and access to the app secure. We therefore recommend that you do not jailbreak or root your phone, which is the process of removing software restrictions and limitations imposed by the official operating system of your device. It could make your phone vulnerable to malware/viruses/malicious programs, compromise your phone’s security features and it could mean that the Dabao Together Mobile Application won’t work properly or at all. ',
              ),
              buildText(
                '• The developer cannot always take responsibility for the way you use the app i.e. You need to make sure that your device stays charged – if it runs out of battery and you can’t turn it on to avail the Service, the developer cannot accept responsibility. ',
              ),
              buildText(
                '• At some point, we may wish to update the app. The app is available for both Android & iOS– the requirements for system (and for any additional systems we decide to extend the availability of the app to) may change, and you’ll need to download the updates if you want to keep using the app. The developer does not promise that it will always update the app so that it is relevant to you and/or works with the Android/iOS version that you have installed on your device. However, you promise to always accept updates to the application when offered to you, we may also wish to stop providing the app, and may terminate use of it at any time without giving notice of termination to you.  ',
              ),
              buildText(
                '• We strongly recommend that you only download the Dabao Together Mobile Application from Google Play Store and App Store. Doing so will ensure that your apps are legitimate and safe from malicious software.',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Disclaimer and Exclusion of Liability',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• The Dabao Together Mobile Application, the Services, the information on the Dabao Together Mobile Application and use of all related facilities are provided on an \"as is, as available\" basis without any warranties whether express or implied. ',
              ),
              buildText(
                '• To the fullest extent permitted by applicable law, we disclaim all representations and warranties relating to the Dabao Together Mobile Application and its contents, including in relation to any inaccuracies or omissions in the Dabao Together Mobile Application, warranties of merchantability, quality, fitness for a particular purpose, accuracy, availability, non-infringement or implied warranties from course of dealing or usage of trade.  ',
              ),
              buildText(
                '• We do not warrant that the Dabao Together Mobile Application will always be accessible, uninterrupted, timely, secure, error free or free from computer virus or other invasive or damaging code or that the Dabao Together Mobile Application will not be affected by any acts of God or other force majeure events, including inability to obtain or shortage of necessary materials, equipment facilities, power or telecommunications, lack of telecommunications equipment or facilities and failure of information technology or telecommunications equipment or facilities.   ',
              ),
              buildText(
                '• While we may use reasonable efforts to include accurate and up-to-date information on the Dabao Together Mobile Application, we make no warranties or representations as to its accuracy, timeliness or completeness.    ',
              ),

              buildText(
                '• We shall not be liable for any acts or omissions of any third parties howsoever caused, and for any direct, indirect, incidental, special, consequential or punitive damages, howsoever caused, resulting from or in connection with the Dabao Together Mobile Application and the services offered in the Dabao Together Mobile Application, your access to, use of or inability to use the Dabao Together Mobile Application or the services offered in the Dabao Together Mobile Application, reliance on or downloading from the Dabao Together Mobile Application and/or services, or any delays, inaccuracies in the information or in its transmission including but not limited to damages for loss of business or profits, use, data or other intangible, even if we have been advised of the possibility of such damages.    ',
              ),
              buildText(
                '• We shall not be liable in contract, tort (including negligence or breach of statutory duty) or otherwise howsoever and whatever the cause thereof, for any indirect, consequential, collateral, special or incidental loss or damage suffered or incurred by you in connection with the Dabao Together Mobile Application and these Terms and Conditions of Use. For the purposes of these Terms and Conditions of Use, indirect or consequential loss or damage includes, without limitation, loss of revenue, profits, anticipated savings or business, loss of data or goodwill, loss of use or value of any equipment including software, claims of third parties, and all associated and incidental costs and expenses.',
              ),
              buildText(
                '• By downloading, accessing or using Dabao Together Mobile Application or any page of this app, you signify your assent to this disclaimer. The contents of this app, including without limitation, all data, information, text, graphics, links and other materials are provided as a convenience to our app users and are meant to be used for informational purposes only. We do not take responsibility for decisions taken by the reader based solely on the information provided in this app.       ',
              ),
              buildText(
                '• The app EXPRESSLY DISCLAIMS ALL WARRANTIES OF ANY KIND, WHETHER EXPRESS OR IMPLIED. The app makes no warranty that (1) THE APP OR THE CONTENT WILL MEET OR SATISFY YOUR REQUIREMENTS (2) THE APP SHALL HAVE NO RESPONSIBILITY FOR ANY DAMAGE TO YOUR PHONE OR TABLET OR LOSS OF DATA THAT RESULTS FROM YOUR USE OF THE APP OR ITS CONTENT.',
              ),
              buildText(
                '• YOU AGREE TO HOLD DABAO TOGETHER MOBILE APPLICATION, AND EACH OF ITS OFFICERS, DIRECTORS, EMPLOYEES AND AGENTS FROM AND AGAINST ANY AND ALL CLAIMS, ACTIONS, DEMANDS, LIABILITIES, JUDGMENTS AND SETTLEMENTS, INCLUDING WITHOUT LIMITATION, FROM ANY DIRECT, INDIRECT, INCIDENTAL, CONSEQUENTIAL, SPECIAL, EXEMPLARY, PUNITIVE OR ANY OTHER CLAIM YOU MAY INCUR IN CONNECTION WITH YOUR USE OF THIS APP, INCLUDING, WITHOUT LIMITATION, ANY ECONOMIC HARM, LOST PROFITS, DAMAGES TO BUSINESS, DATA OR PHONE SYSTEMS, OR ANY DAMAGES RESULTING FROM RELIANCE ON ANY CONTENT OR RESULTING FROM ANY INTERRUPTIONS, WORK STOPPAGES, PHONE OR TABLET FAILURES, DELETION OF FILES, ERRORS, OMISSIONS, INACCURACIES, DEFECTS, VIRUSES, DELAYS OR MISTAKES OF ANY KIND. ',
              ),
              buildText(
                '• The app may include inaccuracies and typographical errors. Changes and improvements are periodically made to the app and the information therein. We do not warrant or assume any legal liability or responsibility for the completeness, or usefulness of any information, service.',
              ),
              buildText(
                '• The above exclusions and limitations apply only to the extent permitted by law. None of your statutory rights as a consumer that cannot be excluded or limited are affected. ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Intellectual Property Rights ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• All editorial content, information, photographs, illustrations, artwork and other graphic materials, and names, logos and trade marks on the Dabao Together Mobile Application are protected by copyright laws and/or other laws and/or international treaties, and belong to us and/or our suppliers, as the case may be. These works, logos, graphics, sounds or images may not be copied, reproduced, retransmitted, distributed, disseminated, sold, published, broadcasted or circulated whether in whole or in part, unless expressly permitted by us and/or our suppliers, as the case may be. ',
              ),
              buildText(
                '• All editorial content, information, photographs, illustrations, artwork and other graphic materials, and names, logos and trade marks on the Dabao Together Mobile Application are protected by copyright laws and/or other laws and/or international treaties, and belong to us and/or our suppliers, as the case may be. These works, logos, graphics, sounds or images may not be copied, reproduced, retransmitted, distributed, disseminated, sold, published, broadcasted or circulated whether in whole or in part, unless expressly permitted by us and/or our suppliers, as the case may be. ',
              ),
              buildText(
                '• Nothing contained on the Dabao Together Mobile Application should be construed as granting by implication, estoppel, or otherwise, any license or right to use any trademark displayed on the Dabao Together Mobile Application without our written permission. Misuse of any trademarks or any other content displayed on the Dabao Together Mobile Application is prohibited. ',
              ),
              buildText(
                '• We will not hesitate to take legal action against any unauthorised usage of our trade marks, name or symbols to preserve and protect its rights in the matter. All rights not expressly granted herein are reserved. Other product and company names mentioned herein may also be the trade marks of their respective owners.  ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Copyright Infringements ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• We respect the intellectual property rights of others. If you believe that any material available on or through the App infringes upon any copyright you own or control, please immediately notify us using the contact information provided below (a “Notification”). A copy of your Notification will be sent to the person who posted or stored the material addressed in the Notification. Please be advised that pursuant to federal law you may be held liable for damages if you make material misrepresentations in a Notification. Thus, if you are not sure that material located on or linked to by the App infringes your copyright, you should consider first contacting an attorney.   ',
              ),

              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Changes to This Terms and Conditions ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• I may update our Terms and Conditions from time to time. I will notify you of any changes by posting the new Terms and Conditions on this page. These changes are effective immediately after they are posted on this page.    ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Contact Us ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• If you have any questions, do not hesitate to contact me at Heyoz@dabaotogether.com.     ',
              ),
              SizedBox(height: 30),
              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  text: 'Privacy Policy',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text:
                        'In order to use the App, you must first acknowledge and agree to our Privacy Policy. You cannot use the App without first accepting our Privacy Policy.  ',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'General ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• The developer provides the Dabao Together Mobile Application, which is a platform to link up people staying near each other to place order together to share the delivery fees. There is in-app messaging for the users to discuss or negotiate the splitting of fees but the purchase will take place outside of the app. They can choose to exchange numbers if they want to.',
              ),
              buildText(
                '• The developer ("The developer", "we", "us") recognizes and understands the importance of the privacy of its users ("users", "you") and wants to respect their desire to store and access personal information in a private and secure manner. This Privacy Policy applies to our Application and describes how the developer manages, stores and utilizes your Personal Data through its Products. ',
              ),
              buildText(
                '• In order to use our app, we require you to consent to the collection and processing of your Personal Data before you start using the app. If you do not agree with the terms of this Privacy Policy, you may not use in any manner the app.  ',
              ),
              buildText(
                '• The developer is committed to protecting the privacy of all of its users Personal Data and providing a secure, user-controlled environment for the use of the app.  ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Permission Required ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                '• INTERNET: For connectivity with the internet ',
              ),
              buildText(
                '• NOTIFICATIONS: For sending push notification ',
              ),
              buildText(
                '• READ/WRITE STORAGE: For accessing device storage media files ',
              ),
              buildText(
                '• GPS LOCATION: For fetching live location ',
              ),
              buildText(
                'Link to privacy policy of third-party service providers used by the app ',
              ),

              buildText(
                '• Google Play Services  ',
              ),
              buildText(
                '• App Store Service  ',
              ),
              buildText(
                '• Firebase Authentication ',
              ),
              buildText(
                '• Firebase Cloud Firestore   ',
              ),
              buildText(
                '• Firebase Cloud Messaging (Push Notification) ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'General Data Protection Regulation (GDPR) ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'We are a Data Controller of your information. ',
              ),
              buildText(
                'The developer collecting and using the personal information on the legal base described in this Privacy Policy depends on the Personal Information we collect and the specific context in which we collect the information:  ',
              ),
              buildText(
                '• The developer needs to perform a contract with you  ',
              ),
              buildText(
                '• You have given the developer permission to do so   ',
              ),
              buildText(
                '• Processing your personal information is in the developer legitimate interests  ',
              ),
              buildText(
                '• The developer needs to comply with the law   ',
              ),
              buildText(
                'The developer will retain your personal information only for as long as is necessary for the purposes set out in this Privacy Policy. We will retain and use your information to the extent necessary to comply with our legal obligations, resolve disputes, and enforce our policies. ',
              ),
              buildText(
                'You are entitled to the following rights under applicable laws:  ',
              ),
              buildText(
                '• The right to access: you may at any time request to access your personal data. Upon request, we will provide a copy of your personal data in a commonly used electronic form. ',
              ),
              buildText(
                '• The right to rectification: you are entitled to obtain rectification of inaccurate personal data and to have incomplete personal data completed. ',
              ),
              buildText(
                '• The right to erase: under certain circumstances (including processing on the basis of your consent), you may request us to delete your User Data. Please note that this right is not unconditional. Therefore, an attempt to invoke the right might not lead to an action from us.   ',
              ),
              buildText(
                '• The right to object: to certain processing activities conducted by the us in relation to your personal data, such as our processing of your personal data based on our legitimate interest. The right to object also applies to the processing of your personal data for direct marketing purposes.  ',
              ),
              buildText(
                '• The right to data portability: you are entitled to receive your personal data (or have your personal data directly transmitted to another data controller) in a structured, commonly used and machine-readable format.  ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Log Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'I want to inform you that whenever you use my Service, in a case of an error in the app I collect data and information (through third party products) on your phone called Log Data. This Log Data may include information such as your device Internet Protocol (“IP”) address, device name, operating system version, the configuration of the app when utilizing my Service, the time and date of your use of the Service, and other statistics.  ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Cookies',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory. ',
              ),
              buildText(
                'This Service does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Your Personal Data',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'The developer is using a secured backend name Firebase Cloud Firestore by Google. In backend, all the user provided content will be stored. All Data will remain safe and secure. No any single information/data will be sent to the anywhere. ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Security',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),

              buildText(
                'We value your trust in providing us your Personal Information, thus we are striving to use commercially acceptable means of protecting it. But remember that no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and We cannot guarantee its absolute security.   ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Service Providers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'We may employ third-party companies and individuals due to the following reasons:    ',
              ),
              buildText(
                '• To facilitate our Service;',
              ),
              buildText(
                '• To provide the Service on our behalf;',
              ),
              buildText(
                '• To perform Service-related services; or',
              ),
              buildText(
                '• To assist us in analysing how our Service is used.',
              ),
              buildText(
                'We want to inform users of this Service that these third parties have access to your Personal Information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose. ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Children\'s Privacy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'These Services do not address anyone under the age of 13. We do not knowingly collect personally identifiable information from children under 13. In the case We discover that a child under 13 has provided me with personal information, we immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that We will be able to do necessary actions. ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Updates or Changes to Our Privacy Policy',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'Occasionally, we may change or update this Privacy Policy to allow us to use or share your previously collected Personal Data for other purposes. If the developer would use your Personal Data in a manner materially different from that stated at the time of the collection, we will provide you with a notice in our Dabao Together Mobile Application indicating that the Privacy Policy has been changed or updated and request you to agree with the updated or changed Privacy Policy.  ',
              ),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.all(5),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                    text: 'Controller',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              buildText(
                'The Developer of Dabao Together Mobile Application   ',
              ),
              buildText(
                'Heyoz@dabaotogether.com    ',
              ),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  Widget buildText(String text) {
    return Container(
      padding: EdgeInsets.all(5),
      child: RichText(
        // overflow: TextOverflow.ellipsis,
        maxLines: 8,
        textAlign: TextAlign.justify,
        text: TextSpan(
          text: text,
          style: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
