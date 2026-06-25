class NoContactsFoundException implements Exception {
  final String message;
  NoContactsFoundException([this.message = "No contacts found on your device."]);

  @override
  String toString() => message;
}
