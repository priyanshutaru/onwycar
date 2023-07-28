class myBooking {
  int? statusCode;
  String? statusMessage;
  List<ResponseUserRegister>? responseUserRegister;

  myBooking({this.statusCode, this.statusMessage, this.responseUserRegister});

  myBooking.fromJson(Map<String, dynamic> json) {
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
  String? bookingId;
  String? bookingStatus;
  Null? startMeter;
  String? vehicleId;
  String? cityId;
  String? invoiceId;
  String? vehicleName;
  String? vehilceNo;
  String? startDate;
  String? startTime;
  String? dropDate;
  String? dropTime;
  String? image;

  ResponseUserRegister(
      {this.bookingId,
        this.bookingStatus,
        this.startMeter,
        this.vehicleId,
        this.cityId,
        this.invoiceId,
        this.vehicleName,
        this.vehilceNo,
        this.startDate,
        this.startTime,
        this.dropDate,
        this.dropTime,
        this.image});

  ResponseUserRegister.fromJson(Map<String, dynamic> json) {
    bookingId = json['booking_id'];
    bookingStatus = json['booking_status'];
    startMeter = json['start_meter'];
    vehicleId = json['vehicle_id'];
    cityId = json['city_id'];
    invoiceId = json['invoice_id'];
    vehicleName = json['vehicle_name'];
    vehilceNo = json['vehilce_no'];
    startDate = json['start_date'];
    startTime = json['start_time'];
    dropDate = json['drop_date'];
    dropTime = json['drop_time'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['booking_id'] = this.bookingId;
    data['booking_status'] = this.bookingStatus;
    data['start_meter'] = this.startMeter;
    data['vehicle_id'] = this.vehicleId;
    data['city_id'] = this.cityId;
    data['invoice_id'] = this.invoiceId;
    data['vehicle_name'] = this.vehicleName;
    data['vehilce_no'] = this.vehilceNo;
    data['start_date'] = this.startDate;
    data['start_time'] = this.startTime;
    data['drop_date'] = this.dropDate;
    data['drop_time'] = this.dropTime;
    data['image'] = this.image;
    return data;
  }
}
