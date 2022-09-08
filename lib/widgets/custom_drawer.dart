import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../controller/general_controller.dart';
import '../modules/home/logic.dart';
import '../modules/home/state.dart';
import '../route_generator.dart';

class MyCustomDrawer extends StatefulWidget {
  const MyCustomDrawer({Key? key}) : super(key: key);

  @override
  _MyCustomDrawerState createState() => _MyCustomDrawerState();
}

class _MyCustomDrawerState extends State<MyCustomDrawer> {
  final HomeLogic logic = Get.put(HomeLogic());
  final HomeState state = Get.find<HomeLogic>().state;
  openUrl(String uri) async {
    if (await canLaunchUrlString(uri)) await launchUrlString(uri);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * .2,
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.profile);
            },
            leading: SvgPicture.asset('assets/drawerProfileIcon.svg'),
            title: Text('Profile', style: state.drawerTitleTextStyle),
          ),
          // ListTile(
          //   onTap: () {
          //     // Get.toNamed(PageRoutes.);
          //   },
          //   leading: SvgPicture.asset('assets/drawerCartIcon.svg'),
          //   title: Text('Bookings', style: state.drawerTitleTextStyle),
          // ),

          ListTile(
            onTap: () {
              openUrl(
                  'https://www.termsandconditionsgenerator.com/live.php?token=lSj6WeVA9l0E6owyMFEdGngyD1uvzMK2');
            },
            leading: Icon(
              Icons.privacy_tip_outlined,
              color: Colors.white,
            ),
            title:
                Text('Terms & conditions', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              openUrl(
                  'https://www.freeprivacypolicy.com/live/5832eae9-b49b-46ba-9c34-b582707cf9ba');
            },
            leading: Icon(Icons.privacy_tip_outlined, color: Colors.white),
            title: Text('Privacy Policy', style: state.drawerTitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.toNamed(PageRoutes.contactUs);
            },
            leading: Image.asset('assets/Chat_bubble.png'),
            title: Text('Contact Us', style: state.drawerTitleTextStyle),
          ),

          const Spacer(),
          ListTile(
            onTap: () {
              Get.find<GeneralController>().firebaseAuthentication.signOut();
            },
            title: Row(
              children: [
                Text('Sign-out', style: state.drawerTitleTextStyle),
                const Icon(
                  Icons.arrow_forward_sharp,
                  color: Colors.white,
                  size: 25,
                )
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * .05,
          ),
        ],
      ),
    );
  }
}
