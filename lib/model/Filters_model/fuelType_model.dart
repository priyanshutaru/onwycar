class fuelType {
  int? statusCode;
  String? statusMessage;
  List<ResponseUserRegister2>? responseUserRegister;

  fuelType({this.statusCode, this.statusMessage, this.responseUserRegister});

  fuelType.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response_userRegister'] != null) {
      responseUserRegister = <ResponseUserRegister2>[];
      json['response_userRegister'].forEach((v) {
        responseUserRegister!.add(new ResponseUserRegister2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.responseUserRegister != null) {
      data['response_userRegister'] =
          this.responseUserRegister!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ResponseUserRegister2 {
  String? id;
  String? fixCity;
  String? fixFuelType;
  String? fixRate;
  String? fixDistance;
  String? fixStatus;
  String? fixAddedBy;
  String? createdAt;
  String? updatedAt;

  ResponseUserRegister2(
      {this.id,
        this.fixCity,
        this.fixFuelType,
        this.fixRate,
        this.fixDistance,
        this.fixStatus,
        this.fixAddedBy,
        this.createdAt,
        this.updatedAt});

  ResponseUserRegister2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fixCity = json['fix_city'];
    fixFuelType = json['fix_fuel_type'];
    fixRate = json['fix_rate'];
    fixDistance = json['fix_distance'];
    fixStatus = json['fix_status'];
    fixAddedBy = json['fix_addedBy'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fix_city'] = this.fixCity;
    data['fix_fuel_type'] = this.fixFuelType;
    data['fix_rate'] = this.fixRate;
    data['fix_distance'] = this.fixDistance;
    data['fix_status'] = this.fixStatus;
    data['fix_addedBy'] = this.fixAddedBy;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
