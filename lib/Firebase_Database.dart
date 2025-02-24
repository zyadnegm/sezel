import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sezel/UserInfo_Model.dart';

class Firebase_Function {
  static CollectionReference<User_Model> User_Collection() {
    return FirebaseFirestore.instance.collection("Users").withConverter(
      fromFirestore: (snapshot, _) {
        return User_Model.fromJson(snapshot.data()!);
      },
      toFirestore: (value, _) {
        return value.toJson();
      },
    );
  }

  static Future<void> add_user(User_Model user) {
    var document = User_Collection().doc(user.user_id.toString());
    return document.set(user);
  }


}
