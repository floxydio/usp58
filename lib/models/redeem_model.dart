class RedeemModel {
  List<RedeemData>? data;
  String? message;

  RedeemModel({this.data, this.message});

  RedeemModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <RedeemData>[];
      json['data'].forEach((v) {
        data!.add(new RedeemData.fromJson(v));
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

class RedeemData {
  int? id;
  int? point;
  String? title;
  String? picture;
  int? quantity;
  String? description;
  int? active;
  String? createdAt;

  RedeemData(
      {this.id,
      this.point,
      this.title,
      this.picture,
      this.quantity,
      this.description,
      this.active,
      this.createdAt});

  RedeemData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    point = json['point'];
    title = json['title'];
    picture = json['picture'];
    quantity = json['quantity'];
    description = json['description'];
    active = json['active'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['point'] = this.point;
    data['title'] = this.title;
    data['picture'] = this.picture;
    data['quantity'] = this.quantity;
    data['description'] = this.description;
    data['active'] = this.active;
    data['createdAt'] = this.createdAt;
    return data;
  }
}
