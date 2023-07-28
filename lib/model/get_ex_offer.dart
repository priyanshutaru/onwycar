class get_ex_offer {
  int? statusCode;
  String? statusMessage;
  List<ResponseUserRegister>? responseUserRegister;

  get_ex_offer(
      {this.statusCode, this.statusMessage, this.responseUserRegister});

  get_ex_offer.fromJson(Map<String, dynamic> json) {
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
  String? couponId;
  String? couponType;
  String? couponCode;
  String? couponTitle;
  String? couponDescription;
  String? forUserId;
  String? couponAmount;
  String? status;
  String? createdAt;
  String? updatedAt;

  ResponseUserRegister(
      {this.id,
        this.couponId,
        this.couponType,
        this.couponCode,
        this.couponTitle,
        this.couponDescription,
        this.forUserId,
        this.couponAmount,
        this.status,
        this.createdAt,
        this.updatedAt});

  ResponseUserRegister.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    couponId = json['coupon_id'];
    couponType = json['coupon_type'];
    couponCode = json['coupon_code'];
    couponTitle = json['coupon_title'];
    couponDescription = json['coupon_description'];
    forUserId = json['for_user_id'];
    couponAmount = json['coupon_amount'];
    status = json['status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['coupon_id'] = this.couponId;
    data['coupon_type'] = this.couponType;
    data['coupon_code'] = this.couponCode;
    data['coupon_title'] = this.couponTitle;
    data['coupon_description'] = this.couponDescription;
    data['for_user_id'] = this.forUserId;
    data['coupon_amount'] = this.couponAmount;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
