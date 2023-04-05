/// dhcp : 0
/// ip : "xxx.xxx.xxx.xxx"
/// gw : "xxx.xxx.xxx.xxx"
/// mask : "xxx.xxx.xxx.xxx"
/// dns1 : "xxx.xxx.xxx.xxx"
/// dns2 : "xxx.xxx.xxx.xxx"

class WifiStat {
  WifiStat({
      num? dhcp, 
      String? ip, 
      String? gw, 
      String? mask, 
      String? dns1, 
      String? dns2,}){
    _dhcp = dhcp;
    _ip = ip;
    _gw = gw;
    _mask = mask;
    _dns1 = dns1;
    _dns2 = dns2;
}

  WifiStat.fromJson(dynamic json) {
    _dhcp = json['dhcp'];
    _ip = json['ip'];
    _gw = json['gw'];
    _mask = json['mask'];
    _dns1 = json['dns1'];
    _dns2 = json['dns2'];
  }
  num? _dhcp;
  String? _ip;
  String? _gw;
  String? _mask;
  String? _dns1;
  String? _dns2;
WifiStat copyWith({  num? dhcp,
  String? ip,
  String? gw,
  String? mask,
  String? dns1,
  String? dns2,
}) => WifiStat(  dhcp: dhcp ?? _dhcp,
  ip: ip ?? _ip,
  gw: gw ?? _gw,
  mask: mask ?? _mask,
  dns1: dns1 ?? _dns1,
  dns2: dns2 ?? _dns2,
);
  num? get dhcp => _dhcp;
  String? get ip => _ip;
  String? get gw => _gw;
  String? get mask => _mask;
  String? get dns1 => _dns1;
  String? get dns2 => _dns2;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['dhcp'] = _dhcp;
    map['ip'] = _ip;
    map['gw'] = _gw;
    map['mask'] = _mask;
    map['dns1'] = _dns1;
    map['dns2'] = _dns2;
    return map;
  }

}