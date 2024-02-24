class ResetPassEntities {
  late final String email;
  late final String newPassword;
  late final String confirmPassword;
  late final String code;

  ResetPassEntities({
    required this.email,
    required this.newPassword,
    required this.confirmPassword,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'password1': newPassword,
      'password2': confirmPassword,
      'code': code,
    };
  }



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ResetPassEntities &&
              runtimeType == other.runtimeType &&
              email == other.email &&
              newPassword == other.newPassword &&
              code == other.code &&
              confirmPassword == other.confirmPassword;


  @override
  int get hashCode => email.hashCode ^ newPassword.hashCode ^ code.hashCode ^ confirmPassword.hashCode;
}