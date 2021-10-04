class UserModel {
  late String uid;
  late String displayName;
  late String email;

  UserModel({
    this.uid = "",
    this.displayName = "",
    this.email = "",
  });

  UserModel.fromMap(Map fund) {
    this.uid = fund['uid'];
    this.displayName = fund['displayName'];
    this.email = fund['email'];
  }
}
