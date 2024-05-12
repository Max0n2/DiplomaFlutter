
class EventModel{
  final String name;
  final String place;
  final String inviteCode;
  final int date;
  // final String? inviteLink;


  EventModel({required this.name, required this.place, required this.date, required this.inviteCode,});

  factory EventModel.fromFirestore(Map<String, dynamic> json){
    return EventModel(
      name: json?['name'],
      place: json?['place'],
      date: json?['date'],
      inviteCode: json?['inviteCode'],
      // inviteLink: json?['inviteLink']
    );
  }
}