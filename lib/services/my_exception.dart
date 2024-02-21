class MyException implements Exception {
  String? heading;
  String? msg;
  MyException({this.heading, this.msg});
  @override
  String toString() {
    return '$heading: $msg';
  }
}

class UnauthorisedException extends MyException {
  UnauthorisedException(String message)
      : super(heading: 'UnauthorisedException', msg: message);
}

class FetchDataException extends MyException {
  FetchDataException(String message)
      : super(heading: 'FetchDataException', msg: message);
}

class BadRequestException extends MyException {
  BadRequestException(String message)
      : super(heading: 'BadRequestException', msg: message);
}

class NetworkUnreachableException extends MyException {
  NetworkUnreachableException(String message)
      : super(heading: 'NetworkUnreachableException', msg: message);
}

class InvalidInputException extends MyException {
  InvalidInputException(String message)
      : super(heading: 'InvalidInputException', msg: message);
}
