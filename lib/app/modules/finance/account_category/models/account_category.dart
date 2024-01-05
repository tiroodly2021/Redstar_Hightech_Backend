import 'package:equatable/equatable.dart';
import 'package:hive_flutter/hive_flutter.dart';
part 'account_category.g.dart';

@HiveType(typeId: 2)
class AccountCategory extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  int? iconid;
  @HiveField(2)
  String categoryName;
  @HiveField(3)
  int type;
  @HiveField(4)
  bool isDeleted = false;

  AccountCategory({
    this.id = 0,
    required this.categoryName,
    required this.type,
  });
  setDeleted() {
    isDeleted = true;

    save();
  }

  @override
  List<Object?> get props => [];
}

class AccountCategoryType {
  static const int income = 0;
  static const int expense = 1;
}



/* 



import 'package:hive_flutter/hive_flutter.dart';
part 'category.g.dart';

@HiveType(typeId: 2)
class Category extends HiveObject {
  @HiveField(0)
  final int id;
  @HiveField(1)
  int? iconid;
  @HiveField(2)
  String categoryName;
  @HiveField(3)
  int type;
  @HiveField(4)
  bool isDeleted = false;

  Category({
    this.id = 0,
    required this.categoryName,
    required this.type,
  });
  setDeleted() {
    isDeleted = true;

    save();
  }
}

class CategoryType {
  static const int income = 0;
  static const int expense = 1;
}




 */