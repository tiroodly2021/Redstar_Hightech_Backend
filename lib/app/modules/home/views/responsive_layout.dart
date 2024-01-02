import 'package:flutter/material.dart';

import '../../../constants/const.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget desktopBody;
  String? orientation;

  ResponsiveLayout(
      {Key? key,
      required this.mobileBody,
      required this.desktopBody,
      this.orientation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > mobileWidth || orientation == 'landscape') {
          return desktopBody;
        } else {
          return mobileBody;
        }
      },
    );
  }
}
