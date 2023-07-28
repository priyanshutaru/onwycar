class nonfulecar {
  int? statusCode;
  String? statusMessage;
  List<Response1>? response;

  nonfulecar({this.statusCode, this.statusMessage, this.response});

  nonfulecar.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response'] != null) {
      response = <Response1>[];
      json['response'].forEach((v) {
        response!.add(new Response1.fromJson(v));
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

class Response1 {
  String? vehicleId;
  String? vehicleName;
  String? city;
  String? modelNo;
  String? vehicleNo;
  String? vehicleImage;
  String? vehicleType;
  String? vehicleSeat;
  String? vehicleCategory;
  String? bookingStatus;
  String? type;
  String? brand;
  String? category;
  String? transmissionType;
  String? filterFuelType;
  String? fuelType;
  List<Slot>? slot;

  Response1(
      {this.vehicleId,
        this.vehicleName,
        this.city,
        this.modelNo,
        this.vehicleNo,
        this.vehicleImage,
        this.vehicleType,
        this.vehicleSeat,
        this.vehicleCategory,
        this.bookingStatus,
        this.type,
        this.brand,
        this.category,
        this.transmissionType,
        this.filterFuelType,
        this.fuelType,
        this.slot});

  Response1.fromJson(Map<String, dynamic> json) {
    vehicleId = json['vehicle_id'];
    vehicleName = json['vehicle_name'];
    city = json['city'];
    modelNo = json['model_no'];
    vehicleNo = json['vehicle_no'];
    vehicleImage = json['vehicle_image'];
    vehicleType = json['vehicle_type'];
    vehicleSeat = json['vehicle_seat'];
    vehicleCategory = json['vehicle_category'];
    bookingStatus = json['booking_status'];
    type = json['type'];
    brand = json['brand'];
    category = json['category'];
    transmissionType = json['transmission_type'];
    filterFuelType = json['filter_fuel_type'];
    fuelType = json['fuel_type'];
    if (json['slot'] != null) {
      slot = <Slot>[];
      json['slot'].forEach((v) {
        slot!.add(new Slot.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['vehicle_id'] = this.vehicleId;
    data['vehicle_name'] = this.vehicleName;
    data['city'] = this.city;
    data['model_no'] = this.modelNo;
    data['vehicle_no'] = this.vehicleNo;
    data['vehicle_image'] = this.vehicleImage;
    data['vehicle_type'] = this.vehicleType;
    data['vehicle_seat'] = this.vehicleSeat;
    data['vehicle_category'] = this.vehicleCategory;
    data['booking_status'] = this.bookingStatus;
    data['type'] = this.type;
    data['brand'] = this.brand;
    data['category'] = this.category;
    data['transmission_type'] = this.transmissionType;
    data['filter_fuel_type'] = this.filterFuelType;
    data['fuel_type'] = this.fuelType;
    if (this.slot != null) {
      data['slot'] = this.slot!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slot {
  String? fixRateId;
  int? fixRate;
  String? fixKm;

  Slot({this.fixRateId, this.fixRate, this.fixKm});

  Slot.fromJson(Map<String, dynamic> json) {
    fixRateId = json['fix_rate_id'];
    fixRate = json['fix_rate'];
    fixKm = json['fix_km'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fix_rate_id'] = this.fixRateId;
    data['fix_rate'] = this.fixRate;
    data['fix_km'] = this.fixKm;
    return data;
  }
}
