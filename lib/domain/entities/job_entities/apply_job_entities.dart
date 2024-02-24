class ApplyJobEntities {
  final String jobId;
  final String fullName;
  final String mobile;
  final String dialCode;
  final String email;
  final String coverLetter;
  final String resumeId;

  const ApplyJobEntities({
    required this.jobId,
    required this.fullName,
    required this.mobile,
    required this.dialCode,
    required this.email,
    required this.coverLetter,
    required this.resumeId,
  });

  Map<String, dynamic> toMap() {
    return {
      'job': jobId,
      'full_name': fullName,
      'mobile': mobile,
      'dial_code': dialCode,
      'email': email,
      'cover_letter': coverLetter,
      'resume': resumeId,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApplyJobEntities &&
          runtimeType == other.runtimeType &&
          jobId == other.jobId &&
          fullName == other.fullName &&
          mobile == other.mobile &&
          dialCode == other.dialCode &&
          email == other.email &&
          coverLetter == other.coverLetter &&
          resumeId == other.resumeId;

  @override
  int get hashCode => jobId.hashCode ^ fullName.hashCode ^ mobile.hashCode ^ dialCode.hashCode ^ email.hashCode ^ coverLetter.hashCode ^ resumeId.hashCode;
}
