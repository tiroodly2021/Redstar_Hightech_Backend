import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../models/permission_model.dart';
import '../../../models/role_model.dart';

class SetPermissionView extends GetView {
  final Role currentRole;
  List<Permission>? permissionList;

  SetPermissionView({required this.currentRole, this.permissionList});

  @override
  Widget build(BuildContext context) {
    print(permissionList);

    return Scaffold(
      appBar: AppBar(
        title: Text('Permission for ' + currentRole.name),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'SetPermissionView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
