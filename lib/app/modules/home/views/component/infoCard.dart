/* import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InfoCard extends StatelessWidget {
  String title;
  String route;
  var bgColor;
  Color iconColor;
  Color txtColor;
  IconData? representativeIcon;
  String? count;

  InfoCard(
      {Key? key,
      required this.title,
      required this.route,
      required this.bgColor,
      required this.iconColor,
      required this.txtColor,
      this.representativeIcon,
      this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.infinity,
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: InkWell(
          onTap: () {
            Get.toNamed(route);
          },
          child: Card(
            color: bgColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Icon(
                    representativeIcon,
                    size: 40,
                    color: iconColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  title.contains("\r\n")
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(title.split("\r\n")[0],
                                style: TextStyle(
                                    color: txtColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold)),
                            Text(title.split("\r\n")[1],
                                style: TextStyle(
                                    color: txtColor,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold))
                          ],
                        )
                      : Text(title,
                          style: TextStyle(
                              color: txtColor,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
                  Text(
                    "(" + count! + ")",
                    style: TextStyle(
                        color: txtColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )
                ]),
              ],
            ),
          ),
        ));
  }
}
 */

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/config/responsive.dart';
import 'package:redstar_hightech_backend/app/config/size_config.dart';
import 'package:redstar_hightech_backend/app/style/colors.dart';
import 'package:redstar_hightech_backend/app/style/style.dart';

class InfoCard extends StatelessWidget {
  String title;
  String route;
  var bgColor;
  Color iconColor;
  Color txtColor;
  IconData? representativeIcon;
  String? count;

  InfoCard(
      {Key? key,
      required this.title,
      required this.route,
      required this.bgColor,
      required this.iconColor,
      required this.txtColor,
      this.representativeIcon,
      this.count})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Get.toNamed(route);
      },
      child: Container(
        constraints: BoxConstraints(
            minWidth: Responsive.isDesktop(context)
                ? 200
                : SizeConfig.screenWidth / 2 - 40),
        padding: EdgeInsets.only(
            top: 20,
            bottom: 20,
            left: 20,
            right: Responsive.isMobile(context) ? 20 : 40),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: bgColor,
          // color: AppColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              representativeIcon,
              size: 35,
              color: iconColor,
            ),
            // SvgPicture.asset(representativeIcon, width: 35),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            /* PrimaryText(text: title, color: AppColors.secondary, size: 16), */
            title.contains("\r\n")
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(title.split("\r\n")[0],
                          style: TextStyle(
                              color: txtColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      Text(title.split("\r\n")[1],
                          style: TextStyle(
                              color: txtColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold))
                    ],
                  )
                : Text(title,
                    style: TextStyle(
                        color: txtColor,
                        fontSize: 16,
                        fontWeight: FontWeight.bold)),
            SizedBox(
              height: SizeConfig.blockSizeVertical * 2,
            ),
            PrimaryText(
              text: count!,
              size: 18,
              fontWeight: FontWeight.w700,
              color: txtColor,
            )
          ],
        ),
      ),
    );
  }
}
