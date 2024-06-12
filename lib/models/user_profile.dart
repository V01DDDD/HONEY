class UserProfile {
  final String uid;
  final String name;
  final String email;
  final bool personalInfoComplete;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.personalInfoComplete,
  });

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
    };
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      personalInfoComplete: true,
    );
  }
}
