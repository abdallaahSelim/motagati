

class UserModel {
  final String uId;
  final String username;
  final String email;
  final String phone;
  final String? Image;
  final String userDeviceToken;
  final bool isAdmin;
  final bool isActive;
final String?Adress;
  final dynamic createdOn;

  UserModel({
    required this.uId,
    required this.username,
    required this.email,
    required this.phone,
    required this.userDeviceToken,
    required this.isAdmin,
    required this.isActive,
    required this.createdOn,
    required this.Image,
    required this.Adress
  });

  // Serialize the UserModel instance to a JSON map
  Map<String, dynamic> toMap() {
    return {
      'uId': uId,
      'username': username,
      'email': email,
      'phone': phone,
      'userDeviceToken': userDeviceToken,
      'isAdmin': isAdmin,
      'isActive': isActive,
      'createdOn': createdOn,
      'Adress':Adress,
      'Image':Image,

    };
  }

  // Create a UserModel instance from a JSON map
  factory UserModel.fromMap(Map<String, dynamic> json) {
    return UserModel(
      uId: json['uId'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      userDeviceToken: json['userDeviceToken'],
      isAdmin: json['isAdmin'],
      isActive: json['isActive'],
      createdOn: json['createdOn'].toString(),
     Image: json['Image'], Adress:json['Adress']
    );
  }
}
