//
//
// class DhcpInfo {
//   final List<Map<String, dynamic>> function;
//   final Request request;
//
//   DhcpInfo({required this.function, required this.request});
//
//   factory DhcpInfo.fromJson(Map<String, dynamic> json) {
//     return DhcpInfo(
//       function: List<Map<String, dynamic>>.from(json['funtion'] ?? []),
//       request: Request.fromJson(json['request']),
//     );
//   }
// }
//
// class Request {
//   final int dhcp;
//
//   Request({
//     required this.dhcp,
//   });
//
//   factory Request.fromJson(Map<String, dynamic> json) {
//     return Request(
//       dhcp: json['dhcp'] ?? '',
//     );
//   }
// }


class DhcpInfo {
  DhcpInfo({
    num? dhcp,
  }){
    _dhcp = dhcp;
  }

  DhcpInfo.fromJson(dynamic json) {
    _dhcp = json['dhcp'];

  }
  num? _dhcp;

  DhcpInfo copyWith({  num? dhcp,

  }) => DhcpInfo(  dhcp: dhcp ?? _dhcp,

  );
  num? get dhcp => _dhcp;


  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dhcp'] = _dhcp;
    return map;
  }

}