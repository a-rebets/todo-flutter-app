class AppUser {
  String? id;
  String name;
  String email;
  DateTime creationDate;

  AppUser({
    this.id,
    required this.name,
    required this.email,
    required this.creationDate,
  });
}
