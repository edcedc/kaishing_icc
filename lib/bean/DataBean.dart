
import 'package:json_annotation/json_annotation.dart';

part 'DataBean.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class DataBean {

  @JsonKey(name: 'LoginID')
  String? loginID;

  @JsonKey(name: 'RoNo')
  String? roNo;

  @JsonKey(name: 'companyID')
  String? companyID;

  @JsonKey(name: 'LocationName')
  String? locationName;

  @JsonKey(name: 'password')
  String? password;

  @JsonKey(name: 'quantity')
  int quantity;

  @JsonKey(name: 'ID')
  int id;

  @JsonKey(name: 'code')
  int code;

  @JsonKey(name: 'quantity2')
  int quantity2;

  @JsonKey(name: 'InventoryLimit')
  int inventoryLimit;

  @JsonKey(name: 'InventoryNum')
  int inventoryNum;

  @JsonKey(name: 'LoctionNum')
  int loctionNum;

  @JsonKey(name: 'allLoctionNum')
  int allLoctionNum;

  @JsonKey(name: 'LoctionLevel')
  int loctionLevel;

  @JsonKey(name: 'type')
  int type;

  @JsonKey(name: 'order_number')
  String? orderNumber;

  @JsonKey(name: 'ValidityDate')
  String? validityDate;

  @JsonKey(name: 'LocRoNo')
  String? locRoNo;

  @JsonKey(name: 'MaterialNo')
  String? materialNo;

  @JsonKey(name: 'MaterialName')
  String? materialName;

  @JsonKey(name: 'PurposeName')
  String? purposeName;

  @JsonKey(name: 'LocName')
  String? locName;

  @JsonKey(name: 'Status')
  String? status;

  @JsonKey(name: 'price')
  double price;

  @JsonKey(name: 'location')
  String? location;

  @JsonKey(name: 'remarks')
  String? remarks;

  @JsonKey(name: 'userid')
  String? userid;

  @JsonKey(name: 'image')
  String? image;

  @JsonKey(name: 'BatchNo')
  String? batchNo;

  @JsonKey(name: 'LoctionRoNo')
  String? loctionRoNo;

  @JsonKey(name: 'LoctionName')
  String? loctionName;

  @JsonKey(name: 'Supplier')
  String? supplier;

  @JsonKey(name: 'LocTopRoNo')
  String? locTopRoNo;

  @JsonKey(name: 'isSave')
  bool isSave;

  @JsonKey(name: 'isExpanded')
  bool isExpanded;

  @JsonKey(name: 'isEdit')
  bool isEdit;

  @JsonKey(name: 'isDelete')
  bool isDelete;

  @JsonKey(name: 'Pic')
  List<DataBean>? pic;

  @JsonKey(name: 'Loc')
  List<DataBean>? loc;

  @JsonKey(name: 'List')
  List<DataBean>? list;

  DataBean({
    this.loginID = null,
    this.roNo = null,
    this.companyID = null,
    this.password = null,
    this.id = 0,
    this.allLoctionNum = 0,
    this.quantity = 0,
    this.quantity2 = 0,
    this.loctionNum = 0,
    this.inventoryLimit = 0,
    this.loctionLevel = 0,
    this.inventoryNum = 0,
    this.type = 0,
    this.orderNumber = null,
    this.locTopRoNo = null,
    this.status = null,
    this.price = 0.0,
    this.code = 0,
    this.location = null,
    this.validityDate = null,
    this.locRoNo = null,
    this.remarks = null,
    this.loctionName = null,
    this.loctionRoNo = null,
    this.userid = null,
    this.locationName = null,
    this.image = null,
    this.supplier = null,
    this.isSave = false,
    this.isEdit = false,
    this.isExpanded = false,
    this.isDelete = false,
    this.pic,
    this.loc,
    this.list,
  });


  @override
  String toString() {
    return 'DataBean{loginID: $loginID, roNo: $roNo, companyID: $companyID, locationName: $locationName, password: $password, quantity: $quantity, id: $id, code: $code, quantity2: $quantity2, inventoryLimit: $inventoryLimit, inventoryNum: $inventoryNum, loctionNum: $loctionNum, orderNumber: $orderNumber, validityDate: $validityDate, locRoNo: $locRoNo, materialNo: $materialNo, materialName: $materialName, purposeName: $purposeName, locName: $locName, status: $status, price: $price, location: $location, remarks: $remarks, userid: $userid, image: $image, batchNo: $batchNo, loctionRoNo: $loctionRoNo, loctionName: $loctionName, supplier: $supplier, isSave: $isSave, isEdit: $isEdit, isDelete: $isDelete, pic: $pic, loc: $loc}';
  }

  factory DataBean.fromJson(Map<String, dynamic> srcJson) => _$DataBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataBeanToJson(this);

}
