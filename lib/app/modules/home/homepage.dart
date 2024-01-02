/* import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'views/desktop/desktop_body.dart';
import 'views/mobile/mobile_body.dart';
import 'views/responsive_layout.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    /*  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
 */
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Orientation myOrientation = MediaQuery.of(context).orientation;
    print("orientation is ${myOrientation.toString()}");

    return Scaffold(body: OrientationBuilder(builder: (_, orientation) {
      if (orientation == Orientation.portrait) {
        return ResponsiveLayout(
            mobileBody: const MobileBody(),
            desktopBody: const MyDesktopBody(),
            orientation: myOrientation.toString());
      } else {
        return ResponsiveLayout(
            mobileBody: const MobileBody(),
            desktopBody: const MyDesktopBody(),
            orientation: myOrientation.toString());
      } // else show the landscape one
    }));
  }
}
 */