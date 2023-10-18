class RedeemSetting {
  RedeemSettingData? data;
  String? message;

  RedeemSetting({this.data, this.message});

  RedeemSetting.fromJson(Map<String, dynamic> json) {
    data = json['data'] != null
        ? new RedeemSettingData.fromJson(json['data'])
        : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = this.message;
    return data;
  }
}

class RedeemSettingData {
  String? settingName;
  int? activeStatus;
  String? imagePath;

  RedeemSettingData({this.settingName, this.activeStatus, this.imagePath});

  RedeemSettingData.fromJson(Map<String, dynamic> json) {
    settingName = json['setting_name'];
    activeStatus = json['active_status'];
    imagePath = json['image_path'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['setting_name'] = this.settingName;
    data['active_status'] = this.activeStatus;
    data['image_path'] = this.imagePath;
    return data;
  }
}
