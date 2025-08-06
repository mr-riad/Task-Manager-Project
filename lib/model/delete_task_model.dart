class DeleteTaskModel {
  String? status;
  Data? data;

  DeleteTaskModel({this.status, this.data});

  DeleteTaskModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? new Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  bool? acknowledged;
  int? deletedCount;

  Data({this.acknowledged, this.deletedCount});

  Data.fromJson(Map<String, dynamic> json) {
    acknowledged = json['acknowledged'];
    deletedCount = json['deletedCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['acknowledged'] = this.acknowledged;
    data['deletedCount'] = this.deletedCount;
    return data;
  }
}