import 'dart:convert';

FaceModel faceModelFromJson(String str) => FaceModel.fromJson(json.decode(str));

String faceModelToJson(FaceModel data) => json.encode(data.toJson());

class FaceModel {
  FaceModel({
      this.userName,
      this.faceData,
  });

  String userName;
  List<double> faceData;

  factory FaceModel.fromJson(Map<String, dynamic> json) {
    if(json == null) return null;
    var faceData = jsonDecode(json["faceData"]);
    var data = FaceModel(
      userName: json["userName"],
      faceData: List<double>.from(faceData.map((x) => x.toDouble())),
    );
    return data;
  }

  Map<String, String> toJson() => {
      "owner": userName.substring(0, userName.lastIndexOf('@')), // required
      "device_name": "Joy 3", // required
      "device_id": "243d6ddf-13e6-4b1d-9867-9d49b11dd2bf", // required
      "device_version": "10", // required
      "app_version": "7.0.0-dev", // required
      "latitude": "10.7916164", // required
      "longitude": "106.6276689", // required
      "userName": userName,
      "faceData": List<dynamic>.from(faceData.map((x) => x)).toString(),
  };
}