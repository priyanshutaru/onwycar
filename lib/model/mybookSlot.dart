class myBookSlot {
  int? statusCode;
  String? statusMessage;
  List<Response>? response;

  myBookSlot({this.statusCode, this.statusMessage, this.response});

  myBookSlot.fromJson(Map<String, dynamic> json) {
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
  String? venId;
  String? cityId;
  String? fixKm;
  String? fixRate;
  String? createdAt;
  String? updatedAt;

  Response(
      {this.id,
        this.venId,
        this.cityId,
        this.fixKm,
        this.fixRate,
        this.createdAt,
        this.updatedAt});

  Response.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    venId = json['ven_id'];
    cityId = json['city_id'];
    fixKm = json['fix_km'];
    fixRate = json['fix_rate'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['ven_id'] = this.venId;
    data['city_id'] = this.cityId;
    data['fix_km'] = this.fixKm;
    data['fix_rate'] = this.fixRate;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
