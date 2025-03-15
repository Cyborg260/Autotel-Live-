class DeviceHistoryModel {
  DeviceHistoryModel({
    required this.items,
    required this.device,
    required this.distanceSum,
    required this.topSpeed,
    required this.moveDuration,
    required this.stopDuration,
    required this.fuelConsumption,
    required this.sensors,
    required this.fuelConsumptionArr,
    required this.itemClass,
    required this.images,
    required this.status,
  });
  late final List<Items> items;
  late final Device device;
  late final dynamic distanceSum;
  late final dynamic topSpeed;
  late final dynamic moveDuration;
  late final dynamic stopDuration;
  late final dynamic fuelConsumption;
  late final List<Sensors> sensors;
  late final List<dynamic> fuelConsumptionArr;
  late final List<ItemClass> itemClass;
  late final List<Images> images;
  late final dynamic status;

  DeviceHistoryModel.fromJson(Map<dynamic, dynamic> json) {
    items = List.from(json['items']).map((e) => Items.fromJson(e)).toList();
    device = Device.fromJson(json['device']);
    distanceSum = json['distance_sum'];
    topSpeed = json['top_speed'];
    moveDuration = json['move_duration'];
    stopDuration = json['stop_duration'];
    fuelConsumption = json['fuel_consumption'];
    sensors =
        List.from(json['sensors']).map((e) => Sensors.fromJson(e)).toList();
    fuelConsumptionArr =
        List.castFrom<dynamic, dynamic>(json['fuel_consumption_arr']);
    itemClass = List.from(json['item_class'])
        .map((e) => ItemClass.fromJson(e))
        .toList();
    images = List.from(json['images']).map((e) => Images.fromJson(e)).toList();
    status = json['status'];
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['items'] = items.map((e) => e.toJson()).toList();
    _data['device'] = device.toJson();
    _data['distance_sum'] = distanceSum;
    _data['top_speed'] = topSpeed;
    _data['move_duration'] = moveDuration;
    _data['stop_duration'] = stopDuration;
    _data['fuel_consumption'] = fuelConsumption;
    _data['sensors'] = sensors.map((e) => e.toJson()).toList();
    _data['fuel_consumption_arr'] = fuelConsumptionArr;
    _data['item_class'] = itemClass.map((e) => e.toJson()).toList();
    _data['images'] = images.map((e) => e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }
}

class Items {
  Items({
    required this.status,
    this.time,
    required this.show,
    this.topSpeed,
    this.left,
    this.avgSpeed,
    required this.rawTime,
    required this.distance,
    this.driver,
    required this.statusItems,
  });
  late final dynamic status;
  late final dynamic? time;
  late final dynamic? show;
  late final dynamic? topSpeed;
  late final dynamic? avgSpeed;
  late final dynamic? left;
  late final dynamic rawTime;
  late final dynamic distance;
  late final dynamic? driver;
  late final List<dynamic> statusItems;

  Items.fromJson(Map<dynamic, dynamic> json) {
    status = json['status'];
    time = json['time'];
    show = json['show'];
    left = json['left'];
    topSpeed = json['top_speed'];
    avgSpeed = json['average_speed'];
    rawTime = json['raw_time'];
    distance = json['distance'];
    driver = null;
    statusItems = json['items'];
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['status'] = status;
    _data['time'] = time;
    _data['show'] = show;
    _data['left'] = left;
    _data['raw_time'] = rawTime;
    _data['distance'] = distance;
    _data['driver'] = driver;
    _data['items'] = statusItems;
    return _data;
  }
}

class Device {
  Device({
    required this.id,
    this.userId,
    this.currentDriverId,
    this.timezoneId,
    required this.traccarDeviceId,
    required this.iconId,
    required this.iconColors,
    required this.active,
    required this.deleted,
    required this.name,
    required this.imei,
    required this.fuelMeasurementId,
    required this.fuelQuantity,
    required this.fuelPrice,
    required this.fuelPerKm,
    required this.simNumber,
    required this.msisdn,
    required this.deviceModel,
    required this.plateNumber,
    required this.vin,
    required this.registrationNumber,
    required this.objectOwner,
    required this.additionalNotes,
    this.expirationDate,
    required this.simExpirationDate,
    required this.simActivationDate,
    required this.installationDate,
    required this.tailColor,
    required this.tailLength,
    required this.engineHours,
    required this.detectEngine,
    required this.minMovingSpeed,
    required this.minFuelFillings,
    required this.minFuelThefts,
    required this.snapToRoad,
    required this.gprsTemplatesOnly,
    required this.validByAvgSpeed,
    required this.parameters,
    this.currents,
    required this.createdAt,
    required this.updatedAt,
    this.forward,
    this.deviceTypeId,
    required this.vrn,
    required this.make,
    required this.model,
    required this.colour,
    required this.engine,
    required this.chasisNo,
    required this.type,
    required this.customerName,
    required this.mobile_1,
    required this.mobile_2,
    required this.secondaryMobileNo,
    required this.emergency1MobileNo,
    required this.emergency2MobileNo,
    required this.nicNo,
    required this.address,
    required this.normalPassword,
    required this.emergencyPassword,
    required this.motherName,
    required this.dateOfBirth,
    required this.instructions,
    required this.ownerName,
    required this.corporateName,
    required this.bankName,
    required this.insuranceName,
    required this.province,
    required this.city,
    required this.geofence,
    required this.valueAddedServices,
    required this.salesPerson,
    required this.installer,
    required this.stopDuration,
    required this.sensors,
    required this.traccar,
  });
  late final dynamic id;
  late final dynamic userId;
  late final dynamic currentDriverId;
  late final dynamic timezoneId;
  late final dynamic traccarDeviceId;
  late final dynamic iconId;
  late final IconColors iconColors;
  late final dynamic active;
  late final dynamic deleted;
  late final dynamic name;
  late final dynamic imei;
  late final dynamic fuelMeasurementId;
  late final dynamic fuelQuantity;
  late final dynamic fuelPrice;
  late final dynamic fuelPerKm;
  late final dynamic simNumber;
  late final dynamic msisdn;
  late final dynamic deviceModel;
  late final dynamic plateNumber;
  late final dynamic vin;
  late final dynamic registrationNumber;
  late final dynamic objectOwner;
  late final dynamic additionalNotes;
  late final dynamic expirationDate;
  late final dynamic simExpirationDate;
  late final dynamic simActivationDate;
  late final dynamic installationDate;
  late final dynamic tailColor;
  late final dynamic tailLength;
  late final dynamic engineHours;
  late final dynamic detectEngine;
  late final dynamic minMovingSpeed;
  late final dynamic minFuelFillings;
  late final dynamic minFuelThefts;
  late final dynamic snapToRoad;
  late final dynamic gprsTemplatesOnly;
  late final dynamic validByAvgSpeed;
  late final dynamic parameters;
  late final dynamic currents;
  late final dynamic createdAt;
  late final dynamic updatedAt;
  late final dynamic forward;
  late final dynamic deviceTypeId;
  late final dynamic vrn;
  late final dynamic make;
  late final dynamic model;
  late final dynamic colour;
  late final dynamic engine;
  late final dynamic chasisNo;
  late final dynamic type;
  late final dynamic customerName;
  late final dynamic mobile_1;
  late final dynamic mobile_2;
  late final dynamic secondaryMobileNo;
  late final dynamic emergency1MobileNo;
  late final dynamic emergency2MobileNo;
  late final dynamic nicNo;
  late final dynamic address;
  late final dynamic normalPassword;
  late final dynamic emergencyPassword;
  late final dynamic motherName;
  late final dynamic dateOfBirth;
  late final dynamic instructions;
  late final dynamic ownerName;
  late final dynamic corporateName;
  late final dynamic bankName;
  late final dynamic insuranceName;
  late final dynamic province;
  late final dynamic city;
  late final dynamic geofence;
  late final dynamic valueAddedServices;
  late final dynamic salesPerson;
  late final dynamic installer;
  late final dynamic stopDuration;
  late final List<Sensors> sensors;
  late final Traccar traccar;

  Device.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    userId = null;
    currentDriverId = null;
    timezoneId = null;
    traccarDeviceId = json['traccar_device_id'];
    iconId = json['icon_id'];
    iconColors = IconColors.fromJson(json['icon_colors']);
    active = json['active'];
    deleted = json['deleted'];
    name = json['name'];
    imei = json['imei'];
    fuelMeasurementId = json['fuel_measurement_id'];
    fuelQuantity = json['fuel_quantity'];
    fuelPrice = json['fuel_price'];
    fuelPerKm = json['fuel_per_km'];
    simNumber = json['sim_number'];
    msisdn = json['msisdn'];
    deviceModel = json['device_model'];
    plateNumber = json['plate_number'];
    vin = json['vin'];
    registrationNumber = json['registration_number'];
    objectOwner = json['object_owner'];
    additionalNotes = json['additional_notes'];
    expirationDate = null;
    simExpirationDate = json['sim_expiration_date'];
    simActivationDate = json['sim_activation_date'];
    installationDate = json['installation_date'];
    tailColor = json['tail_color'];
    tailLength = json['tail_length'];
    engineHours = json['engine_hours'];
    detectEngine = json['detect_engine'];
    minMovingSpeed = json['min_moving_speed'];
    minFuelFillings = json['min_fuel_fillings'];
    minFuelThefts = json['min_fuel_thefts'];
    snapToRoad = json['snap_to_road'];
    gprsTemplatesOnly = json['gprs_templates_only'];
    validByAvgSpeed = json['valid_by_avg_speed'];
    parameters = json['parameters'];
    currents = null;
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    forward = null;
    deviceTypeId = null;
    vrn = json['vrn'];
    make = json['make'];
    model = json['model'];
    colour = json['colour'];
    engine = json['engine'];
    chasisNo = json['chasis_no'];
    type = json['type'];
    customerName = json['customer_name'];
    mobile_1 = json['mobile_1'];
    mobile_2 = json['mobile_2'];
    secondaryMobileNo = json['secondary_mobile_no'];
    emergency1MobileNo = json['emergency1_mobile_no'];
    emergency2MobileNo = json['emergency2_mobile_no'];
    nicNo = json['nic_no'];
    address = json['address'];
    normalPassword = json['normal_password'];
    emergencyPassword = json['emergency_password'];
    motherName = json['mother_name'];
    dateOfBirth = json['date_of_birth'];
    instructions = json['instructions'];
    ownerName = json['owner_name'];
    corporateName = json['corporate_name'];
    bankName = json['bank_name'];
    insuranceName = json['insurance_name'];
    province = json['province'];
    city = json['city'];
    geofence = json['geofence'];
    valueAddedServices = json['value_added_services'];
    salesPerson = json['sales_person'];
    installer = json['installer'];
    stopDuration = json['stop_duration'];
    sensors =
        List.from(json['sensors']).map((e) => Sensors.fromJson(e)).toList();
    traccar = Traccar.fromJson(json['traccar']);
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['current_driver_id'] = currentDriverId;
    _data['timezone_id'] = timezoneId;
    _data['traccar_device_id'] = traccarDeviceId;
    _data['icon_id'] = iconId;
    _data['icon_colors'] = iconColors.toJson();
    _data['active'] = active;
    _data['deleted'] = deleted;
    _data['name'] = name;
    _data['imei'] = imei;
    _data['fuel_measurement_id'] = fuelMeasurementId;
    _data['fuel_quantity'] = fuelQuantity;
    _data['fuel_price'] = fuelPrice;
    _data['fuel_per_km'] = fuelPerKm;
    _data['sim_number'] = simNumber;
    _data['msisdn'] = msisdn;
    _data['device_model'] = deviceModel;
    _data['plate_number'] = plateNumber;
    _data['vin'] = vin;
    _data['registration_number'] = registrationNumber;
    _data['object_owner'] = objectOwner;
    _data['additional_notes'] = additionalNotes;
    _data['expiration_date'] = expirationDate;
    _data['sim_expiration_date'] = simExpirationDate;
    _data['sim_activation_date'] = simActivationDate;
    _data['installation_date'] = installationDate;
    _data['tail_color'] = tailColor;
    _data['tail_length'] = tailLength;
    _data['engine_hours'] = engineHours;
    _data['detect_engine'] = detectEngine;
    _data['min_moving_speed'] = minMovingSpeed;
    _data['min_fuel_fillings'] = minFuelFillings;
    _data['min_fuel_thefts'] = minFuelThefts;
    _data['snap_to_road'] = snapToRoad;
    _data['gprs_templates_only'] = gprsTemplatesOnly;
    _data['valid_by_avg_speed'] = validByAvgSpeed;
    _data['parameters'] = parameters;
    _data['currents'] = currents;
    _data['created_at'] = createdAt;
    _data['updated_at'] = updatedAt;
    _data['forward'] = forward;
    _data['device_type_id'] = deviceTypeId;
    _data['vrn'] = vrn;
    _data['make'] = make;
    _data['model'] = model;
    _data['colour'] = colour;
    _data['engine'] = engine;
    _data['chasis_no'] = chasisNo;
    _data['type'] = type;
    _data['customer_name'] = customerName;
    _data['mobile_1'] = mobile_1;
    _data['mobile_2'] = mobile_2;
    _data['secondary_mobile_no'] = secondaryMobileNo;
    _data['emergency1_mobile_no'] = emergency1MobileNo;
    _data['emergency2_mobile_no'] = emergency2MobileNo;
    _data['nic_no'] = nicNo;
    _data['address'] = address;
    _data['normal_password'] = normalPassword;
    _data['emergency_password'] = emergencyPassword;
    _data['mother_name'] = motherName;
    _data['date_of_birth'] = dateOfBirth;
    _data['instructions'] = instructions;
    _data['owner_name'] = ownerName;
    _data['corporate_name'] = corporateName;
    _data['bank_name'] = bankName;
    _data['insurance_name'] = insuranceName;
    _data['province'] = province;
    _data['city'] = city;
    _data['geofence'] = geofence;
    _data['value_added_services'] = valueAddedServices;
    _data['sales_person'] = salesPerson;
    _data['installer'] = installer;
    _data['stop_duration'] = stopDuration;
    _data['sensors'] = sensors.map((e) => e.toJson()).toList();
    _data['traccar'] = traccar.toJson();
    return _data;
  }
}

class IconColors {
  IconColors({
    required this.moving,
    required this.stopped,
    required this.offline,
    required this.engine,
  });
  late final dynamic moving;
  late final dynamic stopped;
  late final dynamic offline;
  late final dynamic engine;

  IconColors.fromJson(Map<dynamic, dynamic> json) {
    moving = json['moving'];
    stopped = json['stopped'];
    offline = json['offline'];
    engine = json['engine'];
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['moving'] = moving;
    _data['stopped'] = stopped;
    _data['offline'] = offline;
    _data['engine'] = engine;
    return _data;
  }
}

class Sensors {
  Sensors({
    required this.id,
    required this.userId,
    required this.deviceId,
    required this.name,
    required this.type,
    required this.tagName,
    required this.addToHistory,
    this.onValue,
    this.offValue,
    this.shownValueBy,
    this.fuelTankName,
    this.fullTank,
    this.fullTankValue,
    this.minValue,
    this.maxValue,
    this.formula,
    this.odometerValueBy,
    this.odometerValue,
    required this.odometerValueUnit,
    this.temperatureMax,
    this.temperatureMaxValue,
    this.temperatureMin,
    this.temperatureMinValue,
    required this.value,
    required this.valueFormula,
    required this.showInPopup,
    required this.unitOfMeasurement,
    this.onTagValue,
    this.offTagValue,
    this.onType,
    this.offType,
    this.calibrations,
    this.skipCalibration,
    this.skipEmpty,
    this.decbin,
    this.hexbin,
  });
  late final dynamic id;
  late final dynamic userId;
  late final dynamic deviceId;
  late final dynamic name;
  late final dynamic type;
  late final dynamic tagName;
  late final dynamic addToHistory;
  late final dynamic? onValue;
  late final dynamic offValue;
  late final dynamic? shownValueBy;
  late final dynamic fuelTankName;
  late final dynamic fullTank;
  late final dynamic fullTankValue;
  late final dynamic? minValue;
  late final dynamic? maxValue;
  late final dynamic? formula;
  late final dynamic? odometerValueBy;
  late final dynamic odometerValue;
  late final dynamic odometerValueUnit;
  late final dynamic temperatureMax;
  late final dynamic temperatureMaxValue;
  late final dynamic temperatureMin;
  late final dynamic temperatureMinValue;
  late final dynamic value;
  late final dynamic valueFormula;
  late final dynamic showInPopup;
  late final dynamic unitOfMeasurement;
  late final dynamic? onTagValue;
  late final dynamic? offTagValue;
  late final dynamic? onType;
  late final dynamic? offType;
  late final Null calibrations;
  late final Null skipCalibration;
  late final Null skipEmpty;
  late final dynamic? decbin;
  late final dynamic? hexbin;

  Sensors.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    deviceId = json['device_id'];
    name = json['name'];
    type = json['type'];
    tagName = json['tag_name'];
    addToHistory = json['add_to_history'];
    onValue = null;
    offValue = null;
    shownValueBy = null;
    fuelTankName = null;
    fullTank = null;
    fullTankValue = null;
    minValue = null;
    maxValue = null;
    formula = null;
    odometerValueBy = null;
    odometerValue = null;
    odometerValueUnit = json['odometer_value_unit'];
    temperatureMax = null;
    temperatureMaxValue = null;
    temperatureMin = null;
    temperatureMinValue = null;
    value = json['value'];
    valueFormula = json['value_formula'];
    showInPopup = json['show_in_popup'];
    unitOfMeasurement = json['unit_of_measurement'];
    onTagValue = null;
    offTagValue = null;
    onType = null;
    offType = null;
    calibrations = null;
    skipCalibration = null;
    skipEmpty = null;
    decbin = null;
    hexbin = null;
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['id'] = id;
    _data['user_id'] = userId;
    _data['device_id'] = deviceId;
    _data['name'] = name;
    _data['type'] = type;
    _data['tag_name'] = tagName;
    _data['add_to_history'] = addToHistory;
    _data['on_value'] = onValue;
    _data['off_value'] = offValue;
    _data['shown_value_by'] = shownValueBy;
    _data['fuel_tank_name'] = fuelTankName;
    _data['full_tank'] = fullTank;
    _data['full_tank_value'] = fullTankValue;
    _data['min_value'] = minValue;
    _data['max_value'] = maxValue;
    _data['formula'] = formula;
    _data['odometer_value_by'] = odometerValueBy;
    _data['odometer_value'] = odometerValue;
    _data['odometer_value_unit'] = odometerValueUnit;
    _data['temperature_max'] = temperatureMax;
    _data['temperature_max_value'] = temperatureMaxValue;
    _data['temperature_min'] = temperatureMin;
    _data['temperature_min_value'] = temperatureMinValue;
    _data['value'] = value;
    _data['value_formula'] = valueFormula;
    _data['show_in_popup'] = showInPopup;
    _data['unit_of_measurement'] = unitOfMeasurement;
    _data['on_tag_value'] = onTagValue;
    _data['off_tag_value'] = offTagValue;
    _data['on_type'] = onType;
    _data['off_type'] = offType;
    _data['calibrations'] = calibrations;
    _data['skip_calibration'] = skipCalibration;
    _data['skip_empty'] = skipEmpty;
    _data['decbin'] = decbin;
    _data['hexbin'] = hexbin;
    return _data;
  }
}

class Traccar {
  Traccar({
    required this.id,
    required this.name,
    required this.uniqueId,
    required this.latestPositionId,
    required this.lastValidLatitude,
    required this.lastValidLongitude,
    required this.other,
    required this.speed,
    required this.time,
    required this.deviceTime,
    required this.serverTime,
    required this.ackTime,
    required this.altitude,
    required this.course,
    this.power,
    this.address,
    required this.protocol,
    required this.latestPositions,
    required this.movedAt,
    required this.stopedAt,
    required this.engineOnAt,
    required this.engineOffAt,
    required this.engineChangedAt,
    this.databaseId,
  });
  late final dynamic id;
  late final dynamic name;
  late final dynamic uniqueId;
  late final dynamic latestPositionId;
  late final double lastValidLatitude;
  late final double lastValidLongitude;
  late final dynamic other;
  late final dynamic speed;
  late final dynamic time;
  late final dynamic deviceTime;
  late final dynamic serverTime;
  late final dynamic ackTime;
  late final dynamic altitude;
  late final dynamic course;
  late final dynamic power;
  late final dynamic address;
  late final dynamic protocol;
  late final dynamic latestPositions;
  late final dynamic movedAt;
  late final dynamic stopedAt;
  late final dynamic engineOnAt;
  late final dynamic engineOffAt;
  late final dynamic engineChangedAt;
  late final dynamic databaseId;

  Traccar.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    name = json['name'];
    uniqueId = json['uniqueId'];
    latestPositionId = json['latestPosition_id'];
    lastValidLatitude = json['lastValidLatitude'];
    lastValidLongitude = json['lastValidLongitude'];
    other = json['other'];
    speed = json['speed'];
    time = json['time'];
    deviceTime = json['device_time'];
    serverTime = json['server_time'];
    ackTime = json['ack_time'];
    altitude = json['altitude'];
    course = json['course'];
    power = null;
    address = null;
    protocol = json['protocol'];
    latestPositions = json['latest_positions'];
    movedAt = json['moved_at'];
    stopedAt = json['stoped_at'];
    engineOnAt = json['engine_on_at'];
    engineOffAt = json['engine_off_at'];
    engineChangedAt = json['engine_changed_at'];
    databaseId = null;
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['id'] = id;
    _data['name'] = name;
    _data['uniqueId'] = uniqueId;
    _data['latestPosition_id'] = latestPositionId;
    _data['lastValidLatitude'] = lastValidLatitude;
    _data['lastValidLongitude'] = lastValidLongitude;
    _data['other'] = other;
    _data['speed'] = speed;
    _data['time'] = time;
    _data['device_time'] = deviceTime;
    _data['server_time'] = serverTime;
    _data['ack_time'] = ackTime;
    _data['altitude'] = altitude;
    _data['course'] = course;
    _data['power'] = power;
    _data['address'] = address;
    _data['protocol'] = protocol;
    _data['latest_positions'] = latestPositions;
    _data['moved_at'] = movedAt;
    _data['stoped_at'] = stopedAt;
    _data['engine_on_at'] = engineOnAt;
    _data['engine_off_at'] = engineOffAt;
    _data['engine_changed_at'] = engineChangedAt;
    _data['database_id'] = databaseId;
    return _data;
  }
}

class ItemClass {
  ItemClass({
    required this.id,
    required this.value,
    required this.title,
  });
  late final dynamic id;
  late final dynamic value;
  late final dynamic title;

  ItemClass.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    value = json['value'];
    title = json['title'];
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    _data['title'] = title;
    return _data;
  }
}

class Images {
  Images({
    required this.id,
    required this.value,
    required this.title,
  });
  late final dynamic id;
  late final dynamic value;
  late final dynamic title;

  Images.fromJson(Map<dynamic, dynamic> json) {
    id = json['id'];
    value = json['value'];
    title = json['title'];
  }

  Map<dynamic, dynamic> toJson() {
    final _data = <dynamic, dynamic>{};
    _data['id'] = id;
    _data['value'] = value;
    _data['title'] = title;
    return _data;
  }
}
