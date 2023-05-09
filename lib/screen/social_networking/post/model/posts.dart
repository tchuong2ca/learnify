class Posts{
  int? comment;
  String? description;
  String? fullname;
  String? id;
  String? userAvatar;
  String? username;
  List<dynamic>? like;

  Posts(
      {this.comment,
        this.description,
        this.fullname,
        this.id,
        this.userAvatar,
        this.username,
      this.like});
}