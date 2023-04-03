<<<<<<< HEAD
/// ssid : "Efty"
/// pass : "password"

class Model {
  Model({
      String? ssid, 
      String? pass,}){
    _ssid = ssid;
    _pass = pass;
}

  Model.fromJson(dynamic json) {
    _ssid = json['ssid'];
    _pass = json['pass'];
  }
  String? _ssid;
  String? _pass;
Model copyWith({  String? ssid,
  String? pass,
}) => Model(  ssid: ssid ?? _ssid,
  pass: pass ?? _pass,
);
  String? get ssid => _ssid;
  String? get pass => _pass;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ssid'] = _ssid;
    map['pass'] = _pass;
    return map;
  }

=======
/// ssid : "Efty"
/// pass : "password"

class Model {
  Model({
      String? ssid, 
      String? pass,}){
    _ssid = ssid;
    _pass = pass;
}

  Model.fromJson(dynamic json) {
    _ssid = json['ssid'];
    _pass = json['pass'];
  }
  String? _ssid;
  String? _pass;
Model copyWith({  String? ssid,
  String? pass,
}) => Model(  ssid: ssid ?? _ssid,
  pass: pass ?? _pass,
);
  String? get ssid => _ssid;
  String? get pass => _pass;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['ssid'] = _ssid;
    map['pass'] = _pass;
    return map;
  }

>>>>>>> a8776f8116c317b8a4629530ef06c600a63434ce
}