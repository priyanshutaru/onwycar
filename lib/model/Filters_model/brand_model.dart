class brand {
  int? statusCode;
  String? statusMessage;
  List<ResponseUserRegister1>? responseUserRegister;

  brand({this.statusCode, this.statusMessage, this.responseUserRegister});

  brand.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response_userRegister'] != null) {
      responseUserRegister = <ResponseUserRegister1>[];
      json['response_userRegister'].forEach((v) {
        responseUserRegister!.add(new ResponseUserRegister1.fromJson(v));
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

class ResponseUserRegister1 {
  String? id;
  String? bandID;
  String? brandOf;
  String? brnadName;
  String? vsubStatus;
  String? createdAt;
  Null? updatedAt;

  ResponseUserRegister1(
      {this.id,
        this.bandID,
        this.brandOf,
        this.brnadName,
        this.vsubStatus,
        this.createdAt,
        this.updatedAt});

  ResponseUserRegister1.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bandID = json['band_ID'];
    brandOf = json['brand_of'];
    brnadName = json['brnad_name'];
    vsubStatus = json['vsub_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['band_ID'] = this.bandID;
    data['brand_of'] = this.brandOf;
    data['brnad_name'] = this.brnadName;
    data['vsub_status'] = this.vsubStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
