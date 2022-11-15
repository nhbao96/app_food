class UserDto {
  String? email;
  String? name;
  String? phone;
  int? userGroup;
  String? registerDate;
  String? token;

  UserDto(
      {this.email,
        this.name,
        this.phone,
        this.userGroup,
        this.registerDate,
        this.token});

  UserDto.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    name = json['name'];
    phone = json['phone'];
    userGroup = json['userGroup'];
    registerDate = json['registerDate'];
    token = json['token'];
  }

  @override
  String toString() {
    return 'UserDto{email: $email, name: $name, phone: $phone, userGroup: $userGroup, registerDate: $registerDate, token: $token}';
  }

  static UserDto parser(Map<String,dynamic> json) => UserDto.fromJson(json);
}