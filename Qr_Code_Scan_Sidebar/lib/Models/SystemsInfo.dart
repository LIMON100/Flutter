/// fw : "0.0.1"
/// hw : "0.0.1"
/// dt : "Mar 24 2023"
/// mac : "94:B5:55: C:12:AC"
/// rssi : -48
/// ram : 210932
/// flash : 40000
/// temp : 57.222222222222221
/// time_up : 3134

class SystemsInfo {
  SystemsInfo({
      String? fw, 
      String? hw, 
      String? dt, 
      String? mac, 
      num? rssi, 
      num? ram, 
      num? flash, 
      num? temp, 
      num? timeUp,}){
    _fw = fw;
    _hw = hw;
    _dt = dt;
    _mac = mac;
    _rssi = rssi;
    _ram = ram;
    _flash = flash;
    _temp = temp;
    _timeUp = timeUp;
}

  SystemsInfo.fromJson(dynamic json) {
    _fw = json['fw'];
    _hw = json['hw'];
    _dt = json['dt'];
    _mac = json['mac'];
    _rssi = json['rssi'];
    _ram = json['ram'];
    _flash = json['flash'];
    _temp = json['temp'];
    _timeUp = json['time_up'];
  }
  String? _fw;
  String? _hw;
  String? _dt;
  String? _mac;
  num? _rssi;
  num? _ram;
  num? _flash;
  num? _temp;
  num? _timeUp;
SystemsInfo copyWith({  String? fw,
  String? hw,
  String? dt,
  String? mac,
  num? rssi,
  num? ram,
  num? flash,
  num? temp,
  num? timeUp,
}) => SystemsInfo(  fw: fw ?? _fw,
  hw: hw ?? _hw,
  dt: dt ?? _dt,
  mac: mac ?? _mac,
  rssi: rssi ?? _rssi,
  ram: ram ?? _ram,
  flash: flash ?? _flash,
  temp: temp ?? _temp,
  timeUp: timeUp ?? _timeUp,
);
  String? get fw => _fw;
  String? get hw => _hw;
  String? get dt => _dt;
  String? get mac => _mac;
  num? get rssi => _rssi;
  num? get ram => _ram;
  num? get flash => _flash;
  num? get temp => _temp;
  num? get timeUp => _timeUp;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['fw'] = _fw;
    map['hw'] = _hw;
    map['dt'] = _dt;
    map['mac'] = _mac;
    map['rssi'] = _rssi;
    map['ram'] = _ram;
    map['flash'] = _flash;
    map['temp'] = _temp;
    map['time_up'] = _timeUp;
    return map;
  }

}