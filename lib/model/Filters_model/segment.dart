class segment {
  int? statusCode;
  String? statusMessage;
  List<ResponseUserRegister>? responseUserRegister;

  segment({this.statusCode, this.statusMessage, this.responseUserRegister});

  segment.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response_userRegister'] != null) {
      responseUserRegister = <ResponseUserRegister>[];
      json['response_userRegister'].forEach((v) {
        responseUserRegister!.add(new ResponseUserRegister.fromJson(v));
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

class ResponseUserRegister {
  String? id;
  String? vsubType;
  String? vsubBrand;
  String? vsubSubType;
  String? vsubStatus;
  String? createdAt;
  String? updatedAt;

  ResponseUserRegister(
      {this.id,
        this.vsubType,
        this.vsubBrand,
        this.vsubSubType,
        this.vsubStatus,
        this.createdAt,
        this.updatedAt});

  ResponseUserRegister.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    vsubType = json['vsub_type'];
    vsubBrand = json['vsub_brand'];
    vsubSubType = json['vsub_sub_type'];
    vsubStatus = json['vsub_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['vsub_type'] = this.vsubType;
    data['vsub_brand'] = this.vsubBrand;
    data['vsub_sub_type'] = this.vsubSubType;
    data['vsub_status'] = this.vsubStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
