// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DataBean.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DataBean _$DataBeanFromJson(Map<String, dynamic> json) => DataBean(
      loginID: json['LoginID'] as String? ?? null,
      roNo: json['RoNo'] as String? ?? null,
      companyID: json['companyID'] as String? ?? null,
      password: json['password'] as String? ?? null,
      id: (json['ID'] as num?)?.toInt() ?? 0,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      quantity2: (json['quantity2'] as num?)?.toInt() ?? 0,
      loctionNum: (json['LoctionNum'] as num?)?.toInt() ?? 0,
      inventoryLimit: (json['InventoryLimit'] as num?)?.toInt() ?? 0,
      inventoryNum: (json['InventoryNum'] as num?)?.toInt() ?? 0,
      loctionLevel: (json['LoctionLevel'] as num?)?.toInt() ?? 0,
      allLoctionNum: (json['allLoctionNum'] as num?)?.toInt() ?? 0,
      orderNumber: json['order_number'] as String? ?? null,
      status: json['Status'] as String? ?? null,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      code: (json['code'] as num?)?.toInt() ?? 0,
      type: (json['type'] as num?)?.toInt() ?? 0,
      location: json['location'] as String? ?? null,
      validityDate: json['ValidityDate'] as String? ?? null,
      locRoNo: json['LocRoNo'] as String? ?? null,
      remarks: json['remarks'] as String? ?? null,
      loctionName: json['LoctionName'] as String? ?? null,
      loctionRoNo: json['LoctionRoNo'] as String? ?? null,
      userid: json['userid'] as String? ?? null,
      locationName: json['LocationName'] as String? ?? null,
      locTopRoNo: json['LocTopRoNo'] as String? ?? null,
      image: json['image'] as String? ?? null,
      supplier: json['Supplier'] as String? ?? null,
      isSave: json['isSave'] as bool? ?? false,
      isEdit: json['isEdit'] as bool? ?? false,
      isDelete: json['isDelete'] as bool? ?? false,
      isExpanded: json['isExpanded'] as bool? ?? false,
      pic: (json['Pic'] as List<dynamic>?)
          ?.map((e) => DataBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      loc: (json['Loc'] as List<dynamic>?)
          ?.map((e) => DataBean.fromJson(e as Map<String, dynamic>))
          .toList(),
      list: (json['List'] as List<dynamic>?)
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
      'LoctionLevel': instance.loctionLevel,
      'ID': instance.id,
      'code': instance.code,
      'quantity2': instance.quantity2,
      'type': instance.type,
      'allLoctionNum': instance.allLoctionNum,
      'InventoryLimit': instance.inventoryLimit,
      'InventoryNum': instance.inventoryNum,
      'LoctionNum': instance.loctionNum,
      'LocTopRoNo': instance.locTopRoNo,
      'order_number': instance.orderNumber,
      'ValidityDate': instance.validityDate,
      'LocRoNo': instance.locRoNo,
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
      'LoctionRoNo': instance.loctionRoNo,
      'LoctionName': instance.loctionName,
      'Supplier': instance.supplier,
      'isSave': instance.isSave,
      'isEdit': instance.isEdit,
      'isDelete': instance.isDelete,
      'isDelete': instance.isExpanded,
      'Pic': instance.pic,
      'Loc': instance.loc,
      'List': instance.list,
    };
