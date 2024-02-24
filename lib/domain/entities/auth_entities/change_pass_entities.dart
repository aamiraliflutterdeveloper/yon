class ChangePassEntities {
  late final String oldPassword;
  late final String newPassword;
  late final String confirmPassword;

  ChangePassEntities({
    required this.oldPassword,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toMap() {
    return {
      'old_password': oldPassword,
      'password1': newPassword,
      'password2': confirmPassword,
    };
  }



  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChangePassEntities &&
          runtimeType == other.runtimeType &&
          oldPassword == other.oldPassword &&
          newPassword == other.newPassword &&
          confirmPassword == other.confirmPassword;

  @override
  int get hashCode => oldPassword.hashCode ^ newPassword.hashCode ^ confirmPassword.hashCode;
}