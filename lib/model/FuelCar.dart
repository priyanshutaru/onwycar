class fuelCar {
  int? statusCode;
  String? statusMessage;
  List<Response2>? response2;

  fuelCar({this.statusCode, this.statusMessage, this.response2});

  fuelCar.fromJson(Map<String, dynamic> json) {
    statusCode = json['status_code'];
    statusMessage = json['status_message'];
    if (json['response2'] != null) {
      response2 = <Response2>[];
      json['response2'].forEach((v) {
        response2!.add(new Response2.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status_code'] = this.statusCode;
    data['status_message'] = this.statusMessage;
    if (this.response2 != null) {
      data['response2'] = this.response2!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Response2 {
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
  List<Slot1>? slot1;

  Response2(
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
        this.slot1});

  Response2.fromJson(Map<String, dynamic> json) {
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
      slot1 = <Slot1>[];
      json['slot'].forEach((v) {
        slot1!.add(new Slot1.fromJson(v));
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
    if (this.slot1 != null) {
      data['slot'] = this.slot1!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Slot1 {
  String? fixRateId;
  int? fixRate;
  String? fixKm;

  Slot1({this.fixRateId, this.fixRate, this.fixKm});

  Slot1.fromJson(Map<String, dynamic> json) {
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
