//import 'package:firebase_database/firebase_database.dart';

//class Todo {
//  String key;
//  String subject;
//  bool completed;
//  String userId;
//
//  Todo(this.subject, this.userId, this.completed);
//
//  Todo.fromSnapshot(DataSnapshot snapshot)
//      : key = snapshot.key,
//        userId = snapshot.value["userId"],
//        subject = snapshot.value["subject"],
//        completed = snapshot.value["completed"];
//
//  toJson() {
//    return {
//      "userId": userId,
//      "subject": subject,
//      "completed": completed,
//    };
//  }
//}

class Vehicle {
  String key;
  String category;
  int costperpassage;
  String immatriculation;
  String type;
  String userid;

  Vehicle(this.category, this.costperpassage, this.immatriculation, this.type,
      this.userid);

//  Vehicle.fromSnapshot(DataSnapshot snapshot)
//      : key = snapshot.key,
//        category = snapshot.value["category"],
//        costperpassage = snapshot.value["costperpassage"],
//        immatriculation = snapshot.value["immatriculation"],
//        type = snapshot.value["type"],
//        userid = snapshot.value["userid"];
//  toJson() {
//    return {
//      "category": category,
//      "costperpassage": costperpassage,
//      "immatriculation": immatriculation,
//      "type": type,
//      "userid": userid,
//    };
}

class UserData {
  String tollid;
  int balance;
  String email;
  String name;
  int nbofvehicle;
  String userid;

  UserData(this.tollid, this.balance, this.email, this.name, this.nbofvehicle,
      this.userid);
}
