class UserLoginData {
  int? status;
  String? userApiHash;
  Permissions? permissions;

  UserLoginData({this.status, this.userApiHash, this.permissions});

  UserLoginData.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    userApiHash = json['user_api_hash'];
    permissions = json['permissions'] != null
        ? Permissions.fromJson(json['permissions'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['user_api_hash'] = this.userApiHash;
    if (this.permissions != null) {
      data['permissions'] = this.permissions!.toJson();
    }
    return data;
  }
}

class Permissions {
  Devices? devices;
  Devices? alerts;
  Devices? geofences;
  Devices? routes;
  Devices? poi;
  Devices? reports;
  Devices? drivers;
  Devices? customEvents;
  Devices? userGprsTemplates;
  Devices? userSmsTemplates;
  Devices? smsGateway;
  Devices? sendCommand;
  Devices? history;
  Devices? maintenance;
  Devices? camera;
  Devices? deviceCamera;
  Devices? tasks;
  Devices? chat;
  Devices? deviceImei;
  Devices? deviceSimNumber;
  Devices? deviceForward;
  Devices? deviceProtocol;
  Devices? deviceExpirationDate;
  Devices? deviceInstallationDate;
  Devices? deviceSimActivationDate;
  Devices? deviceSimExpirationDate;
  Devices? deviceMsisdn;
  Devices? deviceCustomFields;
  Devices? deviceDeviceTypeId;
  Devices? sharing;
  Devices? checklistTemplate;
  Devices? checklist;
  Devices? checklistActivity;
  Devices? checklistQrCode;
  Devices? checklistQrPreStartOnly;
  Devices? checklistOptionalImage;
  Devices? deviceConfiguration;
  Devices? deviceRouteTypes;
  Devices? callActions;
  Devices? widgetTemplateWebhook;
  Devices? customDeviceAdd;

  Permissions(
      {this.devices,
      this.alerts,
      this.geofences,
      this.routes,
      this.poi,
      this.reports,
      this.drivers,
      this.customEvents,
      this.userGprsTemplates,
      this.userSmsTemplates,
      this.smsGateway,
      this.sendCommand,
      this.history,
      this.maintenance,
      this.camera,
      this.deviceCamera,
      this.tasks,
      this.chat,
      this.deviceImei,
      this.deviceSimNumber,
      this.deviceForward,
      this.deviceProtocol,
      this.deviceExpirationDate,
      this.deviceInstallationDate,
      this.deviceSimActivationDate,
      this.deviceSimExpirationDate,
      this.deviceMsisdn,
      this.deviceCustomFields,
      this.deviceDeviceTypeId,
      this.sharing,
      this.checklistTemplate,
      this.checklist,
      this.checklistActivity,
      this.checklistQrCode,
      this.checklistQrPreStartOnly,
      this.checklistOptionalImage,
      this.deviceConfiguration,
      this.deviceRouteTypes,
      this.callActions,
      this.widgetTemplateWebhook,
      this.customDeviceAdd});

  Permissions.fromJson(Map<String, dynamic> json) {
    devices =
        json['devices'] != null ? new Devices.fromJson(json['devices']) : null;
    alerts =
        json['alerts'] != null ? new Devices.fromJson(json['alerts']) : null;
    geofences = json['geofences'] != null
        ? new Devices.fromJson(json['geofences'])
        : null;
    routes =
        json['routes'] != null ? new Devices.fromJson(json['routes']) : null;
    poi = json['poi'] != null ? new Devices.fromJson(json['poi']) : null;
    reports =
        json['reports'] != null ? new Devices.fromJson(json['reports']) : null;
    drivers =
        json['drivers'] != null ? new Devices.fromJson(json['drivers']) : null;
    customEvents = json['custom_events'] != null
        ? new Devices.fromJson(json['custom_events'])
        : null;
    userGprsTemplates = json['user_gprs_templates'] != null
        ? new Devices.fromJson(json['user_gprs_templates'])
        : null;
    userSmsTemplates = json['user_sms_templates'] != null
        ? new Devices.fromJson(json['user_sms_templates'])
        : null;
    smsGateway = json['sms_gateway'] != null
        ? new Devices.fromJson(json['sms_gateway'])
        : null;
    sendCommand = json['send_command'] != null
        ? new Devices.fromJson(json['send_command'])
        : null;
    history =
        json['history'] != null ? new Devices.fromJson(json['history']) : null;
    maintenance = json['maintenance'] != null
        ? new Devices.fromJson(json['maintenance'])
        : null;
    camera =
        json['camera'] != null ? new Devices.fromJson(json['camera']) : null;
    deviceCamera = json['device_camera'] != null
        ? new Devices.fromJson(json['device_camera'])
        : null;
    tasks = json['tasks'] != null ? new Devices.fromJson(json['tasks']) : null;
    chat = json['chat'] != null ? new Devices.fromJson(json['chat']) : null;
    deviceImei = json['device.imei'] != null
        ? new Devices.fromJson(json['device.imei'])
        : null;
    deviceSimNumber = json['device.sim_number'] != null
        ? new Devices.fromJson(json['device.sim_number'])
        : null;
    deviceForward = json['device.forward'] != null
        ? new Devices.fromJson(json['device.forward'])
        : null;
    deviceProtocol = json['device.protocol'] != null
        ? new Devices.fromJson(json['device.protocol'])
        : null;
    deviceExpirationDate = json['device.expiration_date'] != null
        ? new Devices.fromJson(json['device.expiration_date'])
        : null;
    deviceInstallationDate = json['device.installation_date'] != null
        ? new Devices.fromJson(json['device.installation_date'])
        : null;
    deviceSimActivationDate = json['device.sim_activation_date'] != null
        ? new Devices.fromJson(json['device.sim_activation_date'])
        : null;
    deviceSimExpirationDate = json['device.sim_expiration_date'] != null
        ? new Devices.fromJson(json['device.sim_expiration_date'])
        : null;
    deviceMsisdn = json['device.msisdn'] != null
        ? new Devices.fromJson(json['device.msisdn'])
        : null;
    deviceCustomFields = json['device.custom_fields'] != null
        ? new Devices.fromJson(json['device.custom_fields'])
        : null;
    deviceDeviceTypeId = json['device.device_type_id'] != null
        ? new Devices.fromJson(json['device.device_type_id'])
        : null;
    sharing =
        json['sharing'] != null ? new Devices.fromJson(json['sharing']) : null;
    checklistTemplate = json['checklist_template'] != null
        ? new Devices.fromJson(json['checklist_template'])
        : null;
    checklist = json['checklist'] != null
        ? new Devices.fromJson(json['checklist'])
        : null;
    checklistActivity = json['checklist_activity'] != null
        ? new Devices.fromJson(json['checklist_activity'])
        : null;
    checklistQrCode = json['checklist_qr_code'] != null
        ? new Devices.fromJson(json['checklist_qr_code'])
        : null;
    checklistQrPreStartOnly = json['checklist_qr_pre_start_only'] != null
        ? new Devices.fromJson(json['checklist_qr_pre_start_only'])
        : null;
    checklistOptionalImage = json['checklist_optional_image'] != null
        ? new Devices.fromJson(json['checklist_optional_image'])
        : null;
    deviceConfiguration = json['device_configuration'] != null
        ? new Devices.fromJson(json['device_configuration'])
        : null;
    deviceRouteTypes = json['device_route_types'] != null
        ? new Devices.fromJson(json['device_route_types'])
        : null;
    callActions = json['call_actions'] != null
        ? new Devices.fromJson(json['call_actions'])
        : null;
    widgetTemplateWebhook = json['widget_template_webhook'] != null
        ? new Devices.fromJson(json['widget_template_webhook'])
        : null;
    customDeviceAdd = json['custom_device_add'] != null
        ? new Devices.fromJson(json['custom_device_add'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.devices != null) {
      data['devices'] = this.devices!.toJson();
    }
    if (this.alerts != null) {
      data['alerts'] = this.alerts!.toJson();
    }
    if (this.geofences != null) {
      data['geofences'] = this.geofences!.toJson();
    }
    if (this.routes != null) {
      data['routes'] = this.routes!.toJson();
    }
    if (this.poi != null) {
      data['poi'] = this.poi!.toJson();
    }
    if (this.reports != null) {
      data['reports'] = this.reports!.toJson();
    }
    if (this.drivers != null) {
      data['drivers'] = this.drivers!.toJson();
    }
    if (this.customEvents != null) {
      data['custom_events'] = this.customEvents!.toJson();
    }
    if (this.userGprsTemplates != null) {
      data['user_gprs_templates'] = this.userGprsTemplates!.toJson();
    }
    if (this.userSmsTemplates != null) {
      data['user_sms_templates'] = this.userSmsTemplates!.toJson();
    }
    if (this.smsGateway != null) {
      data['sms_gateway'] = this.smsGateway!.toJson();
    }
    if (this.sendCommand != null) {
      data['send_command'] = this.sendCommand!.toJson();
    }
    if (this.history != null) {
      data['history'] = this.history!.toJson();
    }
    if (this.maintenance != null) {
      data['maintenance'] = this.maintenance!.toJson();
    }
    if (this.camera != null) {
      data['camera'] = this.camera!.toJson();
    }
    if (this.deviceCamera != null) {
      data['device_camera'] = this.deviceCamera!.toJson();
    }
    if (this.tasks != null) {
      data['tasks'] = this.tasks!.toJson();
    }
    if (this.chat != null) {
      data['chat'] = this.chat!.toJson();
    }
    if (this.deviceImei != null) {
      data['device.imei'] = this.deviceImei!.toJson();
    }
    if (this.deviceSimNumber != null) {
      data['device.sim_number'] = this.deviceSimNumber!.toJson();
    }
    if (this.deviceForward != null) {
      data['device.forward'] = this.deviceForward!.toJson();
    }
    if (this.deviceProtocol != null) {
      data['device.protocol'] = this.deviceProtocol!.toJson();
    }
    if (this.deviceExpirationDate != null) {
      data['device.expiration_date'] = this.deviceExpirationDate!.toJson();
    }
    if (this.deviceInstallationDate != null) {
      data['device.installation_date'] = this.deviceInstallationDate!.toJson();
    }
    if (this.deviceSimActivationDate != null) {
      data['device.sim_activation_date'] =
          this.deviceSimActivationDate!.toJson();
    }
    if (this.deviceSimExpirationDate != null) {
      data['device.sim_expiration_date'] =
          this.deviceSimExpirationDate!.toJson();
    }
    if (this.deviceMsisdn != null) {
      data['device.msisdn'] = this.deviceMsisdn!.toJson();
    }
    if (this.deviceCustomFields != null) {
      data['device.custom_fields'] = this.deviceCustomFields!.toJson();
    }
    if (this.deviceDeviceTypeId != null) {
      data['device.device_type_id'] = this.deviceDeviceTypeId!.toJson();
    }
    if (this.sharing != null) {
      data['sharing'] = this.sharing!.toJson();
    }
    if (this.checklistTemplate != null) {
      data['checklist_template'] = this.checklistTemplate!.toJson();
    }
    if (this.checklist != null) {
      data['checklist'] = this.checklist!.toJson();
    }
    if (this.checklistActivity != null) {
      data['checklist_activity'] = this.checklistActivity!.toJson();
    }
    if (this.checklistQrCode != null) {
      data['checklist_qr_code'] = this.checklistQrCode!.toJson();
    }
    if (this.checklistQrPreStartOnly != null) {
      data['checklist_qr_pre_start_only'] =
          this.checklistQrPreStartOnly!.toJson();
    }
    if (this.checklistOptionalImage != null) {
      data['checklist_optional_image'] = this.checklistOptionalImage!.toJson();
    }
    if (this.deviceConfiguration != null) {
      data['device_configuration'] = this.deviceConfiguration!.toJson();
    }
    if (this.deviceRouteTypes != null) {
      data['device_route_types'] = this.deviceRouteTypes!.toJson();
    }
    if (this.callActions != null) {
      data['call_actions'] = this.callActions!.toJson();
    }
    if (this.widgetTemplateWebhook != null) {
      data['widget_template_webhook'] = this.widgetTemplateWebhook!.toJson();
    }
    if (this.customDeviceAdd != null) {
      data['custom_device_add'] = this.customDeviceAdd!.toJson();
    }
    return data;
  }
}

class Devices {
  bool? view;
  bool? edit;
  bool? remove;

  Devices({this.view, this.edit, this.remove});

  Devices.fromJson(Map<String, dynamic> json) {
    view = json['view'];
    edit = json['edit'];
    remove = json['remove'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['view'] = this.view;
    data['edit'] = this.edit;
    data['remove'] = this.remove;
    return data;
  }
}
