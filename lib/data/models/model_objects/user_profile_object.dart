// class UserProfileModel {
//   String? id;
//   String? firstName;
//   String? lastName;
//   bool? isAdmin;
//   String? profilePicture;
//   String? username;
//   String? mobileNumber;
//   String? email;
//   String? dateJoined;
//   String? streetAddress;
//   String? bio;
//   String? city;
//   String? state;
//   String? latitude;
//   String? longitude;
//
//   UserProfileModel({
//     id,
//     firstName,
//     lastName,
//     isAdmin,
//     profilePicture,
//     username,
//     mobileNumber,
//     email,
//     dateJoined,
//     streetAddress,
//     bio,
//     city,
//     state,
//     latitude,
//     longitude,
//   });
//
//   UserProfileModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'] ?? "";
//     firstName = json['first_name'] ?? "";
//     lastName = json['last_name'] ?? "";
//     isAdmin = json['is_admin'] ?? false;
//     profilePicture = json['profile_picture'] ?? "";
//     username = json['username'] ?? "";
//     mobileNumber = json['mobile_number'] ?? "";
//     email = json['email'] ?? "";
//     dateJoined = json['date_joined'] ?? "";
//     streetAddress = json['street_adress'] ?? "";
//     city = json['city'] ?? "";
//     state = json['state'] ?? "";
//     bio = json['bio'] ?? "";
//     latitude = json['latitude'] ?? "";
//     longitude = json['longitude'] ?? "";
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = <String, dynamic>{};
//     data['id'] = id;
//     data['first_name'] = firstName;
//     data['last_name'] = lastName;
//     data['is_admin'] = isAdmin;
//     data['profile_picture'] = profilePicture;
//     data['username'] = username;
//     data['mobile_number'] = mobileNumber;
//     data['email'] = email;
//     data['date_joined'] = dateJoined;
//     data['street_adress'] = streetAddress;
//     data['city'] = city;
//     data['state'] = state;
//     data['bio'] = bio;
//     data['latitude'] = latitude;
//     data['longitude'] = longitude;
//     return data;
//   }
// }
