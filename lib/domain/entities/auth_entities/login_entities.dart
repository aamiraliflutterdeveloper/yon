class LoginEntities{
  late final String email;
  late final String password;

  LoginEntities({required this.email,  required this.password});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password': password,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is LoginEntities && runtimeType == other.runtimeType && email == other.email && password == other.password;

  @override
  int get hashCode => email.hashCode ^ password.hashCode;
}