import 'package:flutter/material.dart';

class ListNotFound extends StatelessWidget {
  String message;
  String info;
  String imageUrl;
  String route;

  ListNotFound(
      {Key? key,
      required this.route,
      required this.message,
      required this.info,
      required this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              imageUrl,
              height: 100,
              width: 100,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyText1,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: RaisedButton(
                color: Colors.black,
                onPressed: () {
                  Navigator.pushNamed(context, route);
                },
                child: Text(
                  info,
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ),
              ),
            ),
          )
        ]);
  }
}
