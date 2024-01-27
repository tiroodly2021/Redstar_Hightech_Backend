import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

String domainUrl = "http://192.168.0.109:8000/";
//String domainUrl = "http:// 192.168.228.160:8000/";

String superFirstName = "Super";
String superLastName = "User";

String superUserEmail = "SysAdmin.Redstar@gmail.com";
String superUserPassword = "SystemAuthPass"; /* nfDF6RaaEmVlWtEgKfiTDrCeS2G3 */

// set the common device dimensions here for mobile / tablet / desktop

const mobileWidth = 600;

const FINANCE_ROLE = 'test';

var customBoxBorder = BoxDecoration(
    border: Border(
  bottom: BorderSide(width: 1.0, color: Colors.grey.shade200),
  top: BorderSide(width: 1.0, color: Colors.grey.shade200),
  right: BorderSide(width: 1.0, color: Colors.grey.shade200),
  left: BorderSide(width: 1.0, color: Colors.grey.shade200),
));
