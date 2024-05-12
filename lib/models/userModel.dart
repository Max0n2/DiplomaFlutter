class UserModel {
  final String firstname;
  final String lastname;
  final List<dynamic> inviteCodes;

  UserModel({
    required this.firstname,
    required this.lastname,
    required this.inviteCodes,
  });

  factory UserModel.fromFirestore(Map<String, dynamic> json) {
    return UserModel(
      firstname: json['firstname'],
      lastname: json['lastname'],
      inviteCodes: List<Map<String, dynamic>>.from(json['eventList']),
    );
  }
}

class UserModelInEvent {
  final String firstname;
  final String lastname;
  final double money;

  UserModelInEvent({
    required this.firstname,
    required this.lastname,
    required this.money,
  });

  factory UserModelInEvent.fromFirestore(Map<String, dynamic> json) {
    return UserModelInEvent(
      firstname: json['firstname'],
      lastname: json['lastname'],
      money: json['money'],
    );
  }
}

