
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

  @JsonKey(name: 'order_number')
  String? orderNumber;

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

  @JsonKey(name: 'isSave')
  bool isSave;

  @JsonKey(name: 'isEdit')
  bool isEdit;

  @JsonKey(name: 'Pic')
  List<DataBean>? pic;

  @JsonKey(name: 'Loc')
  List<DataBean>? loc;

  DataBean({
    this.loginID = '',
    this.roNo = '',
    this.companyID = '',
    this.password = '',
    this.id = 0,
    this.quantity = 0,
    this.quantity2 = 0,
    this.loctionNum = 0,
    this.inventoryLimit = 0,
    this.inventoryNum = 0,
    this.orderNumber = '',
    this.status = '',
    this.price = 0.0,
    this.code = 0,
    this.location = '',
    this.remarks = '',
    this.loctionName = '',
    this.loctionRoNo = '',
    this.userid = '',
    this.locationName = '',
    this.image = '',
    this.isSave = false,
    this.isEdit = false,
    this.pic,
    this.loc,
  });

  @override
  String toString() {
    return 'DataBean{loginID: $loginID, roNo: $roNo, companyID: $companyID, locationName: $locationName, password: $password, quantity: $quantity, id: $id, code: $code, quantity2: $quantity2, inventoryLimit: $inventoryLimit, inventoryNum: $inventoryNum, loctionNum: $loctionNum, orderNumber: $orderNumber, materialNo: $materialNo, materialName: $materialName, purposeName: $purposeName, locName: $locName, status: $status, price: $price, location: $location, remarks: $remarks, userid: $userid, image: $image, batchNo: $batchNo, loctionRoNo: $loctionRoNo, loctionName: $loctionName, isSave: $isSave, isEdit: $isEdit, pic: $pic, loc: $loc}';
  }

  factory DataBean.fromJson(Map<String, dynamic> srcJson) => _$DataBeanFromJson(srcJson);

  Map<String, dynamic> toJson() => _$DataBeanToJson(this);

}
