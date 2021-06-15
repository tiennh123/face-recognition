import 'package:flutter/material.dart';

@immutable
class JWTModel {
  final String refreshToken;
  final String accessToken;
  final int expiredIn;
  JWTModel({
    this.refreshToken = '',
    this.accessToken = '',
    this.expiredIn = 0,
  });

  factory JWTModel.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) return null;
    return JWTModel(
      refreshToken: parsedJson['RefreshToken'],
      accessToken: parsedJson['AccessToken']['Token'],
      expiredIn: parsedJson['AccessToken']['ExpiresIn'],
    );
  }
}

@immutable
class AccountModel {
  final String userName;
  final String password;

  AccountModel({this.userName, this.password});
  factory AccountModel.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null) return null;
    return AccountModel(
      userName: parsedJson['UserName'],
      password: parsedJson['Password'],
    );
  }
}

class UserProfileModel {
  final String userName;
  final String userId;
  String name;
  String email;
  String phone;
  String genderCode;
  String dateOfBirth;
  String permanentAddress;
  String currentAddress;
  int rowVersion;
  final List<UserPermissionModel> permissions;
  final Setting settings;

  UserProfileModel(
      {this.phone,
      this.genderCode,
      this.dateOfBirth,
      this.permanentAddress,
      this.currentAddress,
      this.permissions,
      this.userName,
      this.userId,
      this.name,
      this.email,
      this.rowVersion,
      this.settings});
  factory UserProfileModel.fromJson(Map<String, dynamic> parsedJson) {
    if (parsedJson == null || parsedJson['UserAccount'] == null) return null;
    parsedJson = parsedJson['UserAccount'];
    List<UserPermissionModel> parsedPermissions =
        parsedJson['Permissions'] == null
            ? null
            : parsedJson['Permissions']
                .map<UserPermissionModel>(
                    (permission) => UserPermissionModel.fromJson(permission))
                .toList();
    Setting parsedSettings = parsedJson['Settings'] != null
        ? Setting.fromJson(parsedJson['Settings'])
        : null;
    return UserProfileModel(
        userName: parsedJson['UserName'],
        userId: parsedJson['UserId'],
        name: parsedJson['Name'],
        email: parsedJson['Email'],
        phone: parsedJson['Phone'],
        genderCode: parsedJson['GenderCode'],
        dateOfBirth: parsedJson['DateOfBirth'],
        permanentAddress: parsedJson['PermanentAddress'],
        currentAddress: parsedJson['CurrentAddress'],
        rowVersion: parsedJson['RowVersion'],
        permissions: parsedPermissions,
        settings: parsedSettings);
  }

  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'Name': name,
      'Email': email,
      'Phone': phone,
      'GenderCode': genderCode,
      'DateOfBirth': dateOfBirth,
      'PermanentAddress': permanentAddress,
      'CurrentAddress': currentAddress,
      'RowVersion': rowVersion,
      'Permissions': permissions,
      'Settings': settings
    };
  }
}

class Setting {
  Setting({
    this.autoCreateFbsStockout,
    this.autoPopulateExtAttr,
    this.defaultVolumeUomCode,
    this.defaultWeightUomCode,
    this.enableCheckGps,
    this.enableModuleFbs,
    this.enableModuleWarehouse,
    this.inventoryReceiptOrderTurnAllowNotFoundSource,
    this.orderAllowMakeOutOfStock,
    this.orderAutoCreateAr,
    this.orderAutoCreateInvoice,
    this.orderAutoCreateShipment,
    this.orderCreateArOnStatus,
    this.orderCreateInvoiceOnStatus,
    this.orderCreateShipmentOnStatus,
    this.priceRequestApprovalProcess,
    this.productWarehouseParallelChunkSize,
    this.productWarehouseUpdateMode,
    this.stockKeepingUnitMode,
    this.systemDatetimeFormat,
    this.systemDateFormat,
    this.systemDefaultTimezone,
    this.vat,
    this.locationDistanceFilter,
    this.locationMaxAccuracy,
    this.locationStopTimeout,
    this.elasticityMultiplier,
    this.speedJumpFilter,
    this.heartbeatInterval,
    this.locationTrackingSchedule,
    this.minimumImagesRequiredNewCustomer,
    this.minimumImagesRequiredExistCustomer,
    this.minimumImagesRequiredShipmentDelivered,
    this.locationCheckInMaxDistance,
    this.imageScaleSize,
    this.imageScaleMinimumHeight,
    this.imageScaleMinimumWidth,
    this.mobileSyncInterval,
    this.mobileFileKeepPeriod,
    this.displayStockOnOrderMake,
    this.enableCustomerApproval,
  });

  String autoCreateFbsStockout;
  String autoPopulateExtAttr;
  String defaultVolumeUomCode;
  String defaultWeightUomCode;
  String enableCheckGps;
  String enableModuleFbs;
  String enableModuleWarehouse;
  String inventoryReceiptOrderTurnAllowNotFoundSource;
  String orderAllowMakeOutOfStock;
  String orderAutoCreateAr;
  String orderAutoCreateInvoice;
  String orderAutoCreateShipment;
  String orderCreateArOnStatus;
  String orderCreateInvoiceOnStatus;
  String orderCreateShipmentOnStatus;
  String priceRequestApprovalProcess;
  String productWarehouseParallelChunkSize;
  String productWarehouseUpdateMode;
  String stockKeepingUnitMode;
  String systemDatetimeFormat;
  String systemDateFormat;
  String systemDefaultTimezone;
  String vat;
  double locationDistanceFilter;
  int locationStopTimeout;
  double locationMaxAccuracy;
  String locationTrackingSchedule;
  double elasticityMultiplier;
  int speedJumpFilter;
  int heartbeatInterval;
  int minimumImagesRequiredNewCustomer;
  int minimumImagesRequiredExistCustomer;
  int minimumImagesRequiredShipmentDelivered;
  int locationCheckInMaxDistance;
  int imageScaleSize; // in kb
  int imageScaleMinimumWidth;
  int imageScaleMinimumHeight;
  int mobileSyncInterval; // in minute
  int mobileFileKeepPeriod; // in minute
  bool displayStockOnOrderMake;
  String enableCustomerApproval;

  factory Setting.fromJson(Map<String, dynamic> json) => Setting(
        autoCreateFbsStockout: json["AUTO_CREATE_FBS_STOCKOUT"],
        autoPopulateExtAttr: json["AUTO_POPULATE_EXT_ATTR"],
        defaultVolumeUomCode: json["DEFAULT_VOLUME_UOM_CODE"],
        defaultWeightUomCode: json["DEFAULT_WEIGHT_UOM_CODE"],
        enableCheckGps: json["ENABLE_CHECK_GPS"],
        enableModuleFbs: json["ENABLE_MODULE_FBS"],
        enableModuleWarehouse: json["ENABLE_MODULE_WAREHOUSE"],
        inventoryReceiptOrderTurnAllowNotFoundSource:
            json["INVENTORY_RECEIPT_ORDER_TURN_ALLOW_NOT_FOUND_SOURCE"],
        orderAllowMakeOutOfStock: json["ORDER_ALLOW_MAKE_OUT_OF_STOCK"],
        orderAutoCreateAr: json["ORDER_AUTO_CREATE_AR"],
        orderAutoCreateInvoice: json["ORDER_AUTO_CREATE_INVOICE"],
        orderAutoCreateShipment: json["ORDER_AUTO_CREATE_SHIPMENT"],
        orderCreateArOnStatus: json["ORDER_CREATE_AR_ON_STATUS"],
        orderCreateInvoiceOnStatus: json["ORDER_CREATE_INVOICE_ON_STATUS"],
        orderCreateShipmentOnStatus: json["ORDER_CREATE_SHIPMENT_ON_STATUS"],
        priceRequestApprovalProcess: json["PRICE_REQUEST_APPROVAL_PROCESS"],
        productWarehouseParallelChunkSize:
            json["PRODUCT_WAREHOUSE_PARALLEL_CHUNK_SIZE"],
        productWarehouseUpdateMode: json["PRODUCT_WAREHOUSE_UPDATE_MODE"],
        stockKeepingUnitMode: json["STOCK_KEEPING_UNIT_MODE"],
        systemDatetimeFormat: json["SYSTEM_DATETIME_FORMAT"],
        systemDateFormat: json["SYSTEM_DATE_FORMAT"],
        systemDefaultTimezone: json["SYSTEM_DEFAULT_TIMEZONE"],
        vat: json["VAT"],
        locationDistanceFilter: json["LOCATION_DISTANCE_FILTER"] != null &&
                json["LOCATION_DISTANCE_FILTER"] != ''
            ? double.parse(json["LOCATION_DISTANCE_FILTER"])
            : 10,
        locationStopTimeout: json["LOCATION_STOP_TIMEOUT"] != null &&
                json["LOCATION_STOP_TIMEOUT"] != ''
            ? int.parse(json["LOCATION_STOP_TIMEOUT"])
            : 2,
        locationMaxAccuracy: json["LOCATION_MAX_ACCURACY"] != null &&
                json["LOCATION_MAX_ACCURACY"] != ''
            ? double.parse(json["LOCATION_MAX_ACCURACY"])
            : 100,
        elasticityMultiplier: json["LOCATION_ELASTICITY_MULTIPLIER"] != null &&
                json["LOCATION_ELASTICITY_MULTIPLIER"] != ''
            ? double.parse(json["LOCATION_ELASTICITY_MULTIPLIER"])
            : 5,
        speedJumpFilter: json["LOCATION_SPEED_JUMP_FILTER"] != null &&
                json["LOCATION_SPEED_JUMP_FILTER"] != ''
            ? int.parse(json["LOCATION_SPEED_JUMP_FILTER"])
            : 55,
        heartbeatInterval: json["LOCATION_HEART_BEAT_INTERVAL"] != null &&
                json["LOCATION_HEART_BEAT_INTERVAL"] != ''
            ? int.parse(json["LOCATION_HEART_BEAT_INTERVAL"])
            : 60,
        locationTrackingSchedule: json["LOCATION_TRACKING_SCHEDULE"] != null &&
                json["LOCATION_TRACKING_SCHEDULE"] != ''
            ? json["LOCATION_TRACKING_SCHEDULE"].toString()
            : "",
        minimumImagesRequiredNewCustomer:
            json["MINIMUM_IMAGES_REQUIRED_NEW_CUSTOMER"] != null &&
                    json["MINIMUM_IMAGES_REQUIRED_NEW_CUSTOMER"] != ''
                ? int.parse(json["MINIMUM_IMAGES_REQUIRED_NEW_CUSTOMER"])
                : 5,
        minimumImagesRequiredExistCustomer:
            json["MINIMUM_IMAGES_REQUIRED_EXIST_CUSTOMER"] != null &&
                    json["MINIMUM_IMAGES_REQUIRED_EXIST_CUSTOMER"] != ''
                ? int.parse(json["MINIMUM_IMAGES_REQUIRED_EXIST_CUSTOMER"])
                : 3,
        minimumImagesRequiredShipmentDelivered:
            json["MINIMUM_IMAGES_REQUIRED_SHIPMENT_DELIVERED"] != null &&
                    json["MINIMUM_IMAGES_REQUIRED_SHIPMENT_DELIVERED"] != ''
                ? int.parse(json["MINIMUM_IMAGES_REQUIRED_SHIPMENT_DELIVERED"])
                : 1,
        locationCheckInMaxDistance:
            json["LOCATION_CHECK_IN_MAX_DISTANCE"] != null &&
                    json["LOCATION_CHECK_IN_MAX_DISTANCE"] != ''
                ? int.parse(json["LOCATION_CHECK_IN_MAX_DISTANCE"])
                : 10,
        imageScaleSize: json["STORAGE_EXPECT_IMAGE_SIZE"] != null &&
                json["STORAGE_EXPECT_IMAGE_SIZE"] != ''
            ? int.parse(json["STORAGE_EXPECT_IMAGE_SIZE"])
            : 200,
        imageScaleMinimumHeight: json["IMAGE_SCALE_MINIMUM_HEIGHT"] != null &&
                json["IMAGE_SCALE_MINIMUM_HEIGHT"] != ''
            ? int.parse(json["IMAGE_SCALE_MINIMUM_HEIGHT"])
            : 706,
        imageScaleMinimumWidth: json["IMAGE_SCALE_MINIMUM_WIDTH"] != null &&
                json["IMAGE_SCALE_MINIMUM_WIDTH"] != ''
            ? int.parse(json["IMAGE_SCALE_MINIMUM_WIDTH"])
            : 1024,
        mobileSyncInterval: json["MOBILE_SYNC_INTERVAL"] != null &&
                json["MOBILE_SYNC_INTERVAL"] != ''
            ? int.parse(json["MOBILE_SYNC_INTERVAL"])
            : 3,
        mobileFileKeepPeriod: json["MOBILE_FILE_KEEP_PERIOD"] != null &&
                json["MOBILE_FILE_KEEP_PERIOD"] != ''
            ? int.parse(json["MOBILE_FILE_KEEP_PERIOD"])
            : 30,
        displayStockOnOrderMake: json["DISPLAY_STOCK_ON_ORDER_MAKE"] != null &&
                json["DISPLAY_STOCK_ON_ORDER_MAKE"] != ''
            ? json["DISPLAY_STOCK_ON_ORDER_MAKE"] == "Y"
            : false,
        enableCustomerApproval: json["ENABLE_CUSTOMER_APPROVAL"],
      );

  Map<String, dynamic> toJson() => {
        "AUTO_CREATE_FBS_STOCKOUT": autoCreateFbsStockout,
        "AUTO_POPULATE_EXT_ATTR": autoPopulateExtAttr,
        "DEFAULT_VOLUME_UOM_CODE": defaultVolumeUomCode,
        "DEFAULT_WEIGHT_UOM_CODE": defaultWeightUomCode,
        "ENABLE_CHECK_GPS": enableCheckGps,
        "ENABLE_MODULE_FBS": enableModuleFbs,
        "ENABLE_MODULE_WAREHOUSE": enableModuleWarehouse,
        "INVENTORY_RECEIPT_ORDER_TURN_ALLOW_NOT_FOUND_SOURCE":
            inventoryReceiptOrderTurnAllowNotFoundSource,
        "ORDER_ALLOW_MAKE_OUT_OF_STOCK": orderAllowMakeOutOfStock,
        "ORDER_AUTO_CREATE_AR": orderAutoCreateAr,
        "ORDER_AUTO_CREATE_INVOICE": orderAutoCreateInvoice,
        "ORDER_AUTO_CREATE_SHIPMENT": orderAutoCreateShipment,
        "ORDER_CREATE_AR_ON_STATUS": orderCreateArOnStatus,
        "ORDER_CREATE_INVOICE_ON_STATUS": orderCreateInvoiceOnStatus,
        "ORDER_CREATE_SHIPMENT_ON_STATUS": orderCreateShipmentOnStatus,
        "PRICE_REQUEST_APPROVAL_PROCESS": priceRequestApprovalProcess,
        "PRODUCT_WAREHOUSE_PARALLEL_CHUNK_SIZE":
            productWarehouseParallelChunkSize,
        "PRODUCT_WAREHOUSE_UPDATE_MODE": productWarehouseUpdateMode,
        "STOCK_KEEPING_UNIT_MODE": stockKeepingUnitMode,
        "SYSTEM_DATETIME_FORMAT": systemDatetimeFormat,
        "SYSTEM_DATE_FORMAT": systemDateFormat,
        "SYSTEM_DEFAULT_TIMEZONE": systemDefaultTimezone,
        "VAT": vat,
        "LOCATION_DISTANCE_FILTER": locationDistanceFilter,
        "LOCATION_STOP_TIMEOUT": locationStopTimeout,
        "LOCATION_MAX_ACCURACY": locationMaxAccuracy,
        "LOCATION_ELASTICITY_MULTIPLIER": elasticityMultiplier,
        "LOCATION_SPEED_JUMP_FILTER": speedJumpFilter,
        "LOCATION_HEART_BEAT_INTERVAL": heartbeatInterval,
        "LOCATION_TRACKING_SCHEDULE": locationTrackingSchedule,
        "MINIMUM_IMAGES_REQUIRED_EXIST_CUSTOMER":
            minimumImagesRequiredExistCustomer,
        "MINIMUM_IMAGES_REQUIRED_NEW_CUSTOMER":
            minimumImagesRequiredNewCustomer,
        "MINIMUM_IMAGES_REQUIRED_SHIPMENT_DELIVERED":
            minimumImagesRequiredShipmentDelivered,
        "LOCATION_CHECK_IN_MAX_DISTANCE": locationCheckInMaxDistance,
        "IMAGE_SCALE_MINIMUM_WIDTH": imageScaleMinimumWidth,
        "IMAGE_SCALE_MINIMUM_HEIGHT": imageScaleMinimumHeight,
        "IMAGE_SCALE_SIZE": imageScaleSize,
        "MOBILE_SYNC_INTERVAL": mobileSyncInterval,
        "MOBILE_FILE_KEEP_PERIOD": mobileFileKeepPeriod,
        "DISPLAY_STOCK_ON_ORDER_MAKE": displayStockOnOrderMake,
        "ENABLE_CUSTOMER_APPROVAL": enableCustomerApproval,
      };
}

class UserPermissionModel {
  final String name;
  final String groupName;
  final String shortName;
  final String description;
  final int value;

  static String display = 'Display';
  static String create = 'Create';
  static String delete = 'Delete';
  static String read = 'Read';
  static String attendance = 'Attendance';
  static String checkIn = 'CheckIn';

  UserPermissionModel(
      {this.name,
      this.groupName,
      this.shortName,
      this.description,
      this.value});
  factory UserPermissionModel.fromJson(Map<String, dynamic> parsedJson) {
    return UserPermissionModel(
      name: parsedJson['Name'],
      groupName: parsedJson['GroupName'],
      shortName: parsedJson['ShortName'],
      description: parsedJson['Description'],
      value: parsedJson['Value'],
    );
  }
}
