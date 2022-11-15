class User{
  String? _email;
  String?_name;
  String? _phone;
  String? _token;

  User(String? email, String? name, String? phone, String? token){
    _email = email;
    _name = name;
    _phone = phone;
    _token = token;
  }

  String get token => _token ??"";

  String get phone => _phone ??"";

  String get name => _name ??"";

  String get email => _email ??"";

  @override
  String toString() {
    return 'User{_email: $_email, _name: $_name, _phone: $_phone, _token: $_token}';
  }
}