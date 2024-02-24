class ForgotPassEntities{
  late final String email;

  ForgotPassEntities({required this.email});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ForgotPassEntities && runtimeType == other.runtimeType && email == other.email;

  @override
  int get hashCode => email.hashCode;
}