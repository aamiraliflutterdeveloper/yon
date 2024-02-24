class SignUpEntities {
  late final String fullName;
  late final String email;
  late final String password;
  late final String confirmPass;

  SignUpEntities({required this.password, required this.fullName, required this.email,  required this.confirmPass});

  Map<String, dynamic> toMap() {
    return {
      'full_name': fullName,
      'password': password,
      'email': email,
      'confirm_password': confirmPass
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is SignUpEntities && runtimeType == other.runtimeType && fullName == other.fullName && password == other.password && email == other.email && confirmPass == other.confirmPass;

  @override
  int get hashCode => fullName.hashCode ^ password.hashCode ^ email.hashCode ^ confirmPass.hashCode;
}