class VerifyEmailEntities {
  late final String email;
  late final String code;

  VerifyEmailEntities({
    required this.email,
    required this.code,
  });

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'code': code,
    };
  }

  // @override
  // bool operator ==(Object other) => identical(this, other) || other is VerifyEmailEntities && runtimeType == other.runtimeType && email == other.email && code == other.code;
  //
  // @override
  // int get hashCode => email.hashCode ^ code.hashCode;
}