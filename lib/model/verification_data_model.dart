class VerificationDataModel {
  late String status;
  late String data;

  VerificationDataModel.fromJson(Map<String, dynamic> jsonData) {
    status = jsonData['status'];
    data = jsonData['data'];
  }
}