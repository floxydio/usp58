class HistoryRedeem {
  List<HistoryData>? data;
  String? message;

  HistoryRedeem({this.data, this.message});

  HistoryRedeem.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <HistoryData>[];
      json['data'].forEach((v) {
        data!.add(new HistoryData.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = this.message;
    return data;
  }
}

class HistoryData {
  int? id;
  String? title;
  String? picture;
  String? redeemAt;

  HistoryData({this.id, this.picture, this.redeemAt});

  HistoryData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    picture = json['picture'];
    redeemAt = json['redeem_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['picture'] = this.picture;
    data['redeem_at'] = this.redeemAt;
    return data;
  }
}
