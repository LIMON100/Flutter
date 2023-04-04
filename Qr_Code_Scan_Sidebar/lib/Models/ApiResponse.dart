class ApiResponse {
  final List<Map<String, dynamic>> function;
  final Request request;

  ApiResponse({required this.function, required this.request});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      function: List<Map<String, dynamic>>.from(json['funtion'] ?? []),
      request: Request.fromJson(json['request']),
    );
  }
}

class Request {
  final String firmware;
  final String release;
  final String date;
  final String time;

  Request({
    required this.firmware,
    required this.release,
    required this.date,
    required this.time,
  });

  factory Request.fromJson(Map<String, dynamic> json) {
    return Request(
      firmware: json['firmware'] ?? '',
      release: json['release'] ?? '',
      date: json['date'] ?? '',
      time: json['time'] ?? '',
    );
  }
}
