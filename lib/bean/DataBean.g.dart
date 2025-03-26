// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataBean _$DataBeanFromJson(Map<String, dynamic> json) => DataBean(
      loginID: json['LoginID'] as String? ?? '',
      roNo: json['RoNo'] as String? ?? '',
      companyID: json['companyID'] as String? ?? '',
      password: json['password'] as String? ?? '',
      id: (json['ID'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      code: (json['code'] as num?)?.toInt() ?? 0,
      loctionNum: (json['LoctionNum'] as num?)?.toInt() ?? 0,
      quantity2: (json['quantity2'] as num?)?.toInt() ?? 0,
      inventoryLimit: (json['InventoryLimit'] as num?)?.toInt() ?? 0,
      inventoryNum: (json['InventoryNum'] as num?)?.toInt() ?? 0,
      orderNumber: json['order_number'] as String? ?? '',
      status: json['Status'] as String? ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      location: json['location'] as String? ?? '',
      remarks: json['remarks'] as String? ?? '',
      userid: json['userid'] as String? ?? '',
      locationName: json['LocationName'] as String? ?? '',
      loctionName: json['LoctionName'] as String? ?? '',
      loctionRoNo: json['LoctionRoNo'] as String? ?? '',
      image: json['image'] as String? ?? '',
      isSave: json['isSave'] as bool? ?? false,
      isEdit: json['isEdit'] as bool? ?? false,
      pic: (json['Pic'] as List<dynamic>?)
          ?.map((e) => DataBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      loc: (json['Loc'] as List<dynamic>?)
          ?.map((e) => DataBean.fromJson(e as Map<String, dynamic>))
          .toList(),
    )
      ..materialNo = json['MaterialNo'] as String?
      ..materialName = json['MaterialName'] as String?
      ..purposeName = json['PurposeName'] as String?
      ..locName = json['LocName'] as String?
      ..batchNo = json['BatchNo'] as String?;

Map<String, dynamic> _$DataBeanToJson(DataBean instance) => <String, dynamic>{
      'LoginID': instance.loginID,
      'RoNo': instance.roNo,
      'companyID': instance.companyID,
      'LocationName': instance.locationName,
      'password': instance.password,
      'quantity': instance.quantity,
      'ID': instance.id,
      'code': instance.code,
      'quantity2': instance.quantity2,
      'LoctionNum': instance.loctionNum,
      'InventoryLimit': instance.inventoryLimit,
      'InventoryNum': instance.inventoryNum,
      'order_number': instance.orderNumber,
      'MaterialNo': instance.materialNo,
      'MaterialName': instance.materialName,
      'PurposeName': instance.purposeName,
      'LocName': instance.locName,
      'Status': instance.status,
      'price': instance.price,
      'location': instance.location,
      'remarks': instance.remarks,
      'userid': instance.userid,
      'image': instance.image,
      'BatchNo': instance.batchNo,
      'isSave': instance.isSave,
      'isEdit': instance.isEdit,
      'Pic': instance.pic,
      'Loc': instance.loc,
      'LoctionName': instance.loctionName,
      'LoctionRoNo': instance.loctionRoNo,
    };
