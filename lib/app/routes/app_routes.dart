part of 'app_pages.dart';
// DO NOT EDIT. This is code generated via package:get_cli/get_cli.dart

abstract class Routes {
  Routes._();

/*  FINANCE ROUTES */
  static const FINANCE_HOME = _Paths.FINANCE_HOME;

  static const FINANCE_ADD_TRANSACTION = _Paths.FINANCE_ADD_TRANSACTION;

  static const FINANCE_TRANSACTION = _Paths.FINANCE_TRANSACTION;

  static const FINANCE_EDIT_TRANSACTION = _Paths.FINANCE_EDIT_TRANSACTION;

  static const FINANCE_ADD_CATEGORY = _Paths.FINANCE_ADD_CATEGORY;

  static const FINANCE_CATEGORY = _Paths.FINANCE_CATEGORY;

  static const FIANCE_EDIT_CATEGORY = _Paths.FINANCE_EDIT_CATEGORY;

  /*  END  FIANCE ROUTES */

  static const EDIT_PROFILE = _Paths.EDIT_PROFILE;
  static const INITIAL = _Paths.SPLASH;
  static const HOME = _Paths.HOME;
  static const PRODUCT = _Paths.PRODUCT;
  static const ADD_PRODUCT = _Paths.ADD_PRODUCT;
  static const PRODUCT_LIST = _Paths.PRODUCT_LIST;
  static const ORDER = _Paths.ORDER;
  static const CATEGORY = _Paths.CATEGORY;
  static const ADD_CATEGORY = _Paths.ADD_CATEGORY;
  static const UPDATE_CATEGORY = _Paths.UPDATE_CATEGORY;

  static const UPDATE_PRODUCT = _Paths.UPDATE_PRODUCT;
  static const PENDING_ORDER = _Paths.PENDING_ORDER;
  static const CANCELLED_ORDER = _Paths.CANCELLED_ORDER;
  static const ORDER_DELIVERED = _Paths.ORDER_DELIVERED;
  static const ORDER_DELIVER_PENDING = _Paths.ORDER_DELIVER_PENDING;
  static const SETTINGS = _Paths.SETTINGS;
  static const LOGIN = _Paths.LOGIN;
  static const REGISTRATION = _Paths.REGISTRATION;

  static const USER = _Paths.USER;
  static const ADD_USER = _Paths.ADD_USER;
  static const UPDATE_USER = _Paths.UPDATE_USER;

  static const ROLE = _Paths.ROLE;
  static const ADD_ROLE = _Paths.ADD_ROLE;
  static const UPDATE_ROLE = _Paths.UPDATE_ROLE;
  static const SHOW_ROLE = _Paths.SHOW_ROLE;

  static const PERMISSION = _Paths.PERMISSION;
  static const ADD_PERMISSION = _Paths.ADD_PERMISSION;
  static const SET_PERMISSIONS = _Paths.SET_PERMISSIONS;

  static const DELETE_PRODUCT = _Paths.DELETE_PRODUCT;
  static const DELETE_CATEGORY = _Paths.DELETE_CATEGORY;

  // static const UPDATE_PERMISSION = _Paths.ADD_PERMISSION;

  static const ACCESS_ERROR = _Paths.ACCESS_ERROR;

  static const GUEST = _Paths.GUEST;
}

abstract class _Paths {
  _Paths._();

  /* Finance Name Routes */

  static const FINANCE_HOME = '/finance/home';

  static const FINANCE_ADD_TRANSACTION = '/finance/transaction/add';

  static const FINANCE_TRANSACTION = '/finance/transaction';

  static const FINANCE_EDIT_TRANSACTION = '/finance/transaction/edit';

  static const FINANCE_ADD_CATEGORY = '/finance/category/add';

  static const FINANCE_CATEGORY = '/finance/category';

  static const FINANCE_EDIT_CATEGORY = '/finance/category/edit';

  /* End Finance Name Routes */

  static const EDIT_PROFILE = "/edit-profile";
  static const SPLASH = "/initial";

  static const HOME = '/';

  static const PRODUCT = '/product';
  static const ADD_PRODUCT = '/product/add';
  static const UPDATE_PRODUCT = "/product/update";

  static const PRODUCT_LIST = '/product/list';

  static const ORDER = '/order';

  static const CATEGORY = '/category';
  static const ADD_CATEGORY = '/category/add';
  static const UPDATE_CATEGORY = '/category/update';

  static const PENDING_ORDER = '/pending-order';
  static const CANCELLED_ORDER = '/cancelled-order';
  static const ORDER_DELIVERED = '/order-delivered';
  static const ORDER_DELIVER_PENDING = '/order-deliver-pending';
  static const SETTINGS = '/settings';

  static const LOGIN = '/login';
  static const REGISTRATION = '/registration';

  static const USER = '/user';
  static const ADD_USER = '/user/add';
  static const UPDATE_USER = '/user/update';

  static const ROLE = '/role';
  static const ADD_ROLE = '/role/add';
  static const UPDATE_ROLE = '/role/update';
  static const SHOW_ROLE = '/role/show';

  static const PERMISSION = '/permission';
  static const ADD_PERMISSION = '/permission/add';
  // static const UPDATE_PERMISSION = '/permission/update';

  static const ACCESS_ERROR = '/error';

  static const DELETE_CATEGORY = '/category/delete';
  static const DELETE_PRODUCT = '/product/delete';
  static const DELETE_USER = '/user/delete';
  static const DELETE_ROLE = '/role/delete';
  static const DELETE_PERMISSION = '/permission/delete';

  static const SET_PERMISSIONS = '/permission/set';
  static const GUEST = '/guest';
  static const FINANCIAL_HOME = '/financial-home';
}
