class Camera {
  int cameraID;
  String cameraName;
  String? location;
  String? description;
  DateTime? installationDate;
  String url;

  Camera({
    required this.cameraID,
    required this.cameraName,
    this.location,
    this.description,
    this.installationDate,
    required this.url,
  });

  factory Camera.fromJson(Map<String, dynamic> json) {
    return Camera(
      cameraID: json['CameraID'],
      cameraName: json['CameraName'],
      location: json['Location'],
      description: json['Description'],
      installationDate: DateTime.parse(json['InstallationDate']),
      url: json['url'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'CameraID': cameraID,
      'CameraName': cameraName,
      'Location': location,
      'Description': description,
      'InstallationDate': installationDate?.toIso8601String(),
      'url': url,
    };
  }
}
