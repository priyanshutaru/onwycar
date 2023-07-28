class transactionHist {
  int? statusCode;
  String? statusMessage;
  List<Response>? response;

  transactionHist({this.statusCode, this.statusMessage, this.response});

  transactionHist.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <Response>[];
      json['response'].forEach((v) {
        response!.add(new Response.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.response != null) {
      data['response'] = this.response!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response {
  String? id;
  String? userId;
  String? amtForId;
  String? paymentType;
  String? damageAmt;
  String? penalityAmt;
  String? securityAmt;
  String? paymentAmount;
  String? walletAmount;
  String? walletAmountAfter;
  String? transectionID;
  String? description;
  String? paymentStatus;
  String? createdAt;
  String? updatedAt;

  Response(
      {this.id,
        this.userId,
        this.amtForId,
        this.paymentType,
        this.damageAmt,
        this.penalityAmt,
        this.securityAmt,
        this.paymentAmount,
        this.walletAmount,
        this.walletAmountAfter,
        this.transectionID,
        this.description,
        this.paymentStatus,
        this.createdAt,
        this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    amtForId = json['amt_for_id'];
    paymentType = json['payment_type'];
    damageAmt = json['damage_amt'];
    penalityAmt = json['penality_amt'];
    securityAmt = json['security_amt'];
    paymentAmount = json['payment_amount'];
    walletAmount = json['wallet_amount'];
    walletAmountAfter = json['wallet_amount_after'];
    transectionID = json['transection_ID'];
    description = json['description'];
    paymentStatus = json['payment_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['amt_for_id'] = this.amtForId;
    data['payment_type'] = this.paymentType;
    data['damage_amt'] = this.damageAmt;
    data['penality_amt'] = this.penalityAmt;
    data['security_amt'] = this.securityAmt;
    data['payment_amount'] = this.paymentAmount;
    data['wallet_amount'] = this.walletAmount;
    data['wallet_amount_after'] = this.walletAmountAfter;
    data['transection_ID'] = this.transectionID;
    data['description'] = this.description;
    data['payment_status'] = this.paymentStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
