class RestartInfo {
  final List<dynamic> function;
  final RestartRequest request;

  RestartInfo({required this.function, required this.request});

  factory RestartInfo.fromJson(Map<String, dynamic> json) {
    return RestartInfo(
      function: json['funtion'],
      request: RestartRequest.fromJson(json['request']),
    );
  }
}

class RestartRequest {
  final int restartCounter;

  RestartRequest({required this.restartCounter});

  factory RestartRequest.fromJson(Map<String, dynamic> json) {
    return RestartRequest(restartCounter: json['restart_counter']);
  }
}