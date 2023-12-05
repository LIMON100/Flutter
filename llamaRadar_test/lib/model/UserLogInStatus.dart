class UserLoginStatus {
  final int? usrId;
  final String usrName;
  final String usrPassword;
  final bool loggedIn;

  UserLoginStatus({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
    required this.loggedIn});

  factory UserLoginStatus.fromMap(Map<String, dynamic> json) => UserLoginStatus(
    usrId: json["usrId"],
    usrName: json["usrName"],
    usrPassword: json["usrPassword"],
    loggedIn: json['logged_in'],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "usrName": usrName,
    "usrPassword": usrPassword,
    'logged_in': loggedIn
  };
}