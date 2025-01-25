class TikTokException implements Exception {
  final String message;
  final dynamic error;

  TikTokException(this.message, {this.error});

  @override
  String toString() {
    return 'TikTokException: $message${error != null ? '\nError: $error' : ''}';
  }
}
