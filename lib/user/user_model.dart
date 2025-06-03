import 'package:equatable/equatable.dart';

class User extends Equatable {
  final int? id;  // Change to int to match API expectations
  final String? username;
  final String? email;
  final String? firstName; 
  final String? lastName;
  final String? gender;
  final String? image;
  
  const User({
    this.id, 
    this.username, 
    this.email,
    this.firstName,
    this.lastName,
    this.gender,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] is String ? int.tryParse(json['id']) : json['id'],  // Handle both string and int
      username: json['username'],
      email: json['email'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      gender: json['gender'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'email': email,
    'firstName': firstName,
    'lastName': lastName,
    'gender' : gender,
    'image': image,
  };

  @override
  List<Object?> get props => [id, username, email, firstName, lastName, image];
}