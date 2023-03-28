/// ssid : ""
/// pass : ""
/// ip : "0.0.0.0"
/// mask : "0.0.0.0"
/// gtw : "0.0.0.0"

class CheckWifiInfo {
  CheckWifiInfo({
      String? ssid, 
      String? pass, 
      String? ip, 
      String? mask, 
      String? gtw,}){
    _ssid = ssid;
    _pass = pass;
    _ip = ip;
    _mask = mask;
    _gtw = gtw;
}

  CheckWifiInfo.fromJson(dynamic json) {
    _ssid = json['ssid'];
    _pass = json['pass'];
    _ip = json['ip'];
    _mask = json['mask'];
    _gtw = json['gtw'];
  }
  String? _ssid;
  String? _pass;
  String? _ip;
  String? _mask;
  String? _gtw;
CheckWifiInfo copyWith({  String? ssid,
  String? pass,
  String? ip,
  String? mask,
  String? gtw,
}) => CheckWifiInfo(  ssid: ssid ?? _ssid,
  pass: pass ?? _pass,
  ip: ip ?? _ip,
  mask: mask ?? _mask,
  gtw: gtw ?? _gtw,
);
  String? get ssid => _ssid;
  String? get pass => _pass;
  String? get ip => _ip;
  String? get mask => _mask;
  String? get gtw => _gtw;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ssid'] = _ssid;
    map['pass'] = _pass;
    map['ip'] = _ip;
    map['mask'] = _mask;
    map['gtw'] = _gtw;
    return map;
  }

}