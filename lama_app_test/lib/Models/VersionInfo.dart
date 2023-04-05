class VersionInfo {
  final List<Map<String, dynamic>> function;
  final Request request;

  VersionInfo({required this.function, required this.request});

  factory VersionInfo.fromJson(Map<String, dynamic> json) {
    return VersionInfo(
      function: List<Map<String, dynamic>>.from(json['funtion'] ?? []),
      request: Request.fromJson(json['request']),
    );
  }
}

class Request {
  final String firmware;
  final String reselase;
  final String date;
  final String time;

  Request({
    required this.firmware,
    required this.reselase,
    required this.date,
    required this.time,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      firmware: json['firmware'] ?? '',
      reselase: json['reselase'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
