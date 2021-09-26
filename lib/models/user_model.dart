class UserModel {
  String uid = "";
  String displayName = "";
  String email = "";

  UserModel.fromMap(Map fund) {
    this.uid = fund['uid'];
    this.displayName = fund['displayName'] ?? '';
    this.email = fund['email'];
  }
}