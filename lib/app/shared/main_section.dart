import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainSectionService extends StatelessWidget {
  String title;
  String route;
  var bgColor;
  Color iconColor;
  Color txtColor;
  IconData? representativeIcon;
  String? count;

  MainSectionService(
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
