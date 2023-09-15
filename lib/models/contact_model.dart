class ContactModel {
  late final String id;
  late final String name;
  late final String contactNo;
  late final String profilePhoto;

  ContactModel({
    required this.id,
    required this.name,
    required this.contactNo,
    required this.profilePhoto,
  });

  ContactModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    contactNo = json['contactNo'];
    profilePhoto = json['profilePhoto'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['contactNo'] = contactNo;
    data['profilePhoto'] = profilePhoto;
    return data;
  }
}
