class AppException implements Exception {
  final _message;
  final _prefix;
  AppException([this._message, this._prefix]);

  @override
  String toString() {
    return '$_prefix$_message';
  }
}

// Class to to show exceptions
class FetchDataException implements AppException {
  FetchDataException([String? message, String? prefix]);

  @override
  get _message => throw UnimplementedError();

  @override
  get _prefix => throw UnimplementedError();
}
