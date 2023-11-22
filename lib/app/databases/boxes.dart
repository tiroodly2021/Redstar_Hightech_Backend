import 'package:hive/hive.dart';

class Boxes {
  static Box getStorageBox() => Hive.box('storage');
}
