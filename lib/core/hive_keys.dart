class HiveKeys {
  static const users =
      'users'; // box name; stores email -> {name, passwordHash}
  static const session = 'session'; // box name; stores {currentEmail}
  static const currentEmail = 'currentEmail';
}
