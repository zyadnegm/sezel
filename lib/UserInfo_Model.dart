class User_Model {
  String fcm_token;
  String jwt_token;
  int user_id;

  User_Model(this.fcm_token, this.jwt_token, this.user_id);

  // تحويل كائن JSON إلى كائن User_Model
  factory User_Model.fromJson(Map<String, dynamic> json) {
    return User_Model(
      json['fcm_token'] ?? '',  // تجنب القيم الفارغة
      json['jwt_token'] ?? '',
      json['user_id'] ?? 0,
    );
  }

  // تحويل كائن User_Model إلى كائن JSON
  Map<String, dynamic> toJson() {
    return {
      'fcm_token': fcm_token,
      'jwt_token': jwt_token,
      'user_id': user_id,
    };
  }
}
