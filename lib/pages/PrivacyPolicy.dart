import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({Key? key}) : super(key: key);

  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        title: Text("PrivacyPolicy"),
      ),
      body: SingleChildScrollView(
        child: Html(
         data: '''<div class="col-xs-12 col-sm-9 col-md-9 col-lg-9">
             <div class="all-content row">
        <div style="width:100%;padding-right: 15px; padding-left: 15px;">
        <span>

        <h1>PrivacyPolicy for E Tamil News</h1>

        <p>At E Tamil News, accessible from https://etamilnews.com, one of our main priorities is the privacy of our visitors. This PrivacyPolicy document contains types of information that is collected and recorded by E Tamil News and how we use it.</p>

        <p>If you have additional questions or require more information about our PrivacyPolicy, do not hesitate to contact us.</p>

        <h2>Log Files</h2>

        <p>E Tamil News follows a standard procedure of using log files. These files log visitors when they visit websites. All hosting companies do this and a part of hosting services' analytics. The information collected by log files include internet protocol (IP) addresses, browser type, Internet Service Provider (ISP), date and time stamp, referring/exit pages, and possibly the number of clicks. These are not linked to any information that is personally identifiable. The purpose of the information is for analyzing trends, administering the site, tracking users' movement on the website, and gathering demographic information. Our PrivacyPolicy was created with the help of the <a href="https://www.privacypolicyonline.com/privacy-policy-generator/">PrivacyPolicy Generator</a>.</p>



        <h2>Our Advertising Partners</h2>

        <p>Some of advertisers on our site may use cookies and web beacons. Our advertising partners are listed below. Each of our advertising partners has their own PrivacyPolicy for their policies on user data. For easier access, we hyperlinked to their Privacy Policies below.</p>

        <ul>
        <li>
        <p>Google</p>
        <p><a href="https://policies.google.com/technologies/ads">https://policies.google.com/technologies/ads</a></p>
        </li>
        </ul>

        <h2>Privacy Policies</h2>

        <p>You may consult this list to find the PrivacyPolicy for each of the advertising partners of E Tamil News.</p>

        <p>Third-party ad servers or ad networks uses technologies like cookies, JavaScript, or Web Beacons that are used in their respective advertisements and links that appear on E Tamil News, which are sent directly to users' browser. They automatically receive your IP address when this occurs. These technologies are used to measure the effectiveness of their advertising campaigns and/or to personalize the advertising content that you see on websites that you visit.</p>

        <p>Note that E Tamil News has no access to or control over these cookies that are used by third-party advertisers.</p>

        <h2>Third Party Privacy Policies</h2>

        <p>E Tamil News's PrivacyPolicy does not apply to other advertisers or websites. Thus, we are advising you to consult the respective Privacy Policies of these third-party ad servers for more detailed information. It may include their practices and instructions about how to opt-out of certain options. </p>

        <p>You can choose to disable cookies through your individual browser options. To know more detailed information about cookie management with specific web browsers, it can be found at the browsers' respective websites. What Are Cookies?</p>

        <h2>Children's Information</h2>

        <p>Another part of our priority is adding protection for children while using the internet. We encourage parents and guardians to observe, participate in, and/or monitor and guide their online activity.</p>

        <p>E Tamil News does not knowingly collect any Personal Identifiable Information from children under the age of 13. If you think that your child provided this kind of information on our website, we strongly encourage you to contact us immediately and we will do our best efforts to promptly remove such information from our records.</p>

        <h2>Online PrivacyPolicy Only</h2>

        <p>This PrivacyPolicy applies only to our online activities and is valid for visitors to our website with regards to the information that they shared and/or collect in E Tamil News. This policy is not applicable to any information collected offline or via channels other than this website.</p>

        <h2>Consent</h2>

        <p>By using our website, you hereby consent to our PrivacyPolicy and agree to its Terms and Conditions.</p>
        </span>

        <br><br>
        Contact of publishers and Developers<br>
        Murali Selvaraj<br>
        107,GH backside<br>
        Mathur<br>
        Krishnagiri district<br>
            Pincode :635203<br>
            Cell:9943094945<br>
        Editor@thiral.in<br>
            </div>


            </div>
            </div>''',
        ),
      )
    );
  }
}
