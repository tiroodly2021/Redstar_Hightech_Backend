import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:get/get.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/permission_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/controllers/role_controller.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/permission_model.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/models/role_model.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/widgets/set_perssion_card.dart';
import 'package:redstar_hightech_backend/app/modules/authentication/views/admin/roles/widgets/set_search_perssion_card.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/controllers/account_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/account/models/account_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/controllers/transaction_controller.dart';
import 'package:redstar_hightech_backend/app/modules/finance/transaction/models/transaction_model.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/empty_view.dart';
import 'package:redstar_hightech_backend/app/modules/finance/widgets/tile_transaction.dart';
import 'package:redstar_hightech_backend/app/services/database_service.dart';
import 'package:redstar_hightech_backend/util.dart';

class PermissionSearchDelegate extends SearchDelegate {
  Role? currentRole;

  PermissionSearchDelegate({this.currentRole});

  @override
  String? get searchFieldLabel => 'Search Permission';
  List<Permission> permissions = PermissionController().permissions;
  List<Role> roles = RoleController().roles;

  final PermissionController permissionController = Get.find();

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(
          Icons.clear,
        ),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Permission> resultList = [];

    for (var item in permissions) {
      if (query.isNotEmpty &&
          item.description.toLowerCase().contains(query.toLowerCase())) {
        resultList.add(item);
      }
    }
    if (query.isNotEmpty && resultList.isEmpty) {
      return const EmptyView(icon: Icons.search, label: 'No Results Found');
    }

    print('resultList ${resultList.length}');

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: resultList.length,
          itemBuilder: (context, index) {
            Permission currItem = resultList[index];
            return SetSearchPermissionCard(
              role: currentRole,
              permission: currItem,
              permissionController: permissionController,
              index: index,
            );
          }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Permission> suggestionList = [];

    for (Permission item in permissions) {
      if (query.isNotEmpty &&
          item.description.toLowerCase().contains(query.toLowerCase())) {
        suggestionList.add(item);
      }
    }

    return SlidableAutoCloseBehavior(
      child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10),
          itemCount: suggestionList.length,
          itemBuilder: (context, index) {
            final currCat = suggestionList[index];
            return ListTile(
              leading:
                  const Icon(Icons.person) /* Util.getCatIcon(currCat.type) */,
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 0, horizontal: 25),
              visualDensity: const VisualDensity(horizontal: 0, vertical: 0),
              title: Text(suggestionList[index].description,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              onTap: () {
                query = currCat.description;
                showResults(context);
              },
            );
          }),
    );
  }
}
