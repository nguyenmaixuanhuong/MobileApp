class HttpException implements Exception {
  final String message;

  HttpException(this.message);

  HttpException.firebase(String code)
      : message = _translateFirebaseErrorCode(code);

  static String _translateFirebaseErrorCode(code) {
    switch (code) {
      case 'EMAIL_EXISTS':
        return 'Email đã tồn tại';
      case 'INVALID_EMAIL':
        return 'Email không chính xác';
      case 'WEAK_PASSWORD':
        return 'Mật khẩu quá yếu';
      case 'EMAIL_NOT_FOUND':
        return 'Email không tìm thấy';
      case 'INVALID_PASSWORD':
        return 'Password khoogn đúng';
      default:
        return code;
    }
  }

  @override
  String toString() {
    return message;
  }
}
