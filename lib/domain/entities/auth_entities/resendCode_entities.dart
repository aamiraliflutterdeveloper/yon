class ResendCodeEntities{
  late final String email;

  ResendCodeEntities({required this.email});

  Map<String, dynamic> toMap() {
    return {
      'email': email,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) || other is ResendCodeEntities && runtimeType == other.runtimeType && email == other.email;

  @override
  int get hashCode => email.hashCode;
}





