class ProfileModel {
  int? id;
  String? firstName;
  String? middleName;
  String? lastName;
  String? dateOfBirthEn;
  String? dateOfBirthNp;
  String? tempAddress;
  String? tempStreet;
  String? tempDistrict;
  String? tempZone;
  String? tempCountry;
  String? permAddress;
  String? permStreet;
  String? permDistrict;
  String? permZone;
  String? permCountry;
  String? username;
  String? phone;
  Profile? profile;

  ProfileModel({
    this.id,
    this.firstName,
    this.middleName,
    this.lastName,
    this.dateOfBirthEn,
    this.dateOfBirthNp,
    this.tempAddress,
    this.tempStreet,
    this.tempDistrict,
    this.tempZone,
    this.tempCountry,
    this.permAddress,
    this.permStreet,
    this.permDistrict,
    this.permZone,
    this.permCountry,
    this.profile,
    this.username,
    this.phone,
  });

  ProfileModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    middleName = json['middle_name'];
    lastName = json['last_name'];
    dateOfBirthEn = json['date_of_birth_en'];
    dateOfBirthNp = json['date_of_birth_np'];
    tempAddress = json['temp_address'];
    tempStreet = json['temp_street'];
    tempDistrict = json['temp_district'];
    tempZone = json['temp_zone'];
    tempCountry = json['temp_country'];
    permAddress = json['perm_address'];
    permStreet = json['perm_street'];
    permDistrict = json['perm_district'];
    permZone = json['perm_zone'];
    permCountry = json['perm_country'];
    username = json['username'];
    phone = json['phone'];
    profile = json['profile'] != null
        ? Profile.fromJson(json['profile'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['middle_name'] = middleName;
    data['last_name'] = lastName;
    data['date_of_birth_en'] = dateOfBirthEn;
    data['date_of_birth_np'] = dateOfBirthNp;
    data['temp_address'] = tempAddress;
    data['temp_street'] = tempStreet;
    data['temp_district'] = tempDistrict;
    data['temp_zone'] = tempZone;
    data['temp_country'] = tempCountry;
    data['perm_address'] = permAddress;
    data['perm_street'] = permStreet;
    data['perm_district'] = permDistrict;
    data['perm_zone'] = permZone;
    data['perm_country'] = permCountry;
    if (profile != null) {
      data['profile'] = profile!.toJson();
    }
    return data;
  }
}

class Profile {
  int? id;
  String? imageUrl;

  Profile({this.id, this.imageUrl});

  Profile.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['image_url'] = imageUrl;
    return data;
  }
}
