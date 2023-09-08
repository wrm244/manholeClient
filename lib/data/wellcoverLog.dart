class WellCoverLog {
  int logID;
  int wellCoverID;
  DateTime dateTime;
  String status;
  String? location;
  int? recognitionResult;
  int? cameraID;
  String? algorithmVersion;
  String? additionalInfo;

  WellCoverLog({
    required this.logID,
    required this.wellCoverID,
    required this.dateTime,
    required this.status,
    this.location,
    this.recognitionResult,
    this.cameraID,
    this.algorithmVersion,
    this.additionalInfo,
  });

  factory WellCoverLog.fromJson(Map<String, dynamic> json) {
    return WellCoverLog(
      logID: json['LogID'],
      wellCoverID: json['WellCoverID'],
      dateTime: DateTime.parse(json['DateTime']),
      status: json['Status'],
      location: json['Location'],
      recognitionResult: json['RecognitionResult'],
      cameraID: json['CameraID'],
      algorithmVersion: json['AlgorithmVersion'],
      additionalInfo: json['AdditionalInfo'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'LogID': logID,
      'WellCoverID': wellCoverID,
      'DateTime': dateTime.toIso8601String(),
      'Status': status,
      'Location': location,
      'RecognitionResult': recognitionResult,
      'CameraID': cameraID,
      'AlgorithmVersion': algorithmVersion,
      'AdditionalInfo': additionalInfo,
    };
  }
}
