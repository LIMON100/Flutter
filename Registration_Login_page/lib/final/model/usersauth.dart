class UsersAuth {
  final int? usrId;
  final String usrName;
  final String usrPassword;

  UsersAuth({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
  });

  factory UsersAuth.fromMap(Map<String, dynamic> json) => UsersAuth(
    usrId: json["usrId"],
    usrName: json["usrName"],
    usrPassword: json["usrPassword"],
  );

  Map<String, dynamic> toMap() => {
    "usrId": usrId,
    "usrName": usrName,
    "usrPassword": usrPassword,
  };
}