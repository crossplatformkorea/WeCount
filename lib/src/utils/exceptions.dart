class UserNotSignedInException implements Exception {
  UserNotSignedInException();

  @override
  String toString() {
    return 'exceptionNotSignedIn';
  }
}

class UnauthorizedException implements Exception {
  UnauthorizedException();

  @override
  String toString() {
    return 'exceptionUnauthorized';
  }
}

class NotFoundException implements Exception {
  NotFoundException();

  @override
  String toString() {
    return 'exceptionNotFound';
  }
}

enum CommunityExceptionCode {
  notFound,
  alreadyExists,
  unauthorized,
}

class CommunityException implements Exception {
  CommunityException({
    required this.code,
    this.message,
  });

  CommunityExceptionCode code;
  String? message;

  @override
  String toString() {
    return '$code: $message';
  }
}

enum FeedExceptionCode {
  notFound,
  alreadyExists,
  unauthorized,
}

class FeedException implements Exception {
  FeedException({
    required this.code,
    this.message,
  });

  FeedExceptionCode code;
  String? message;

  @override
  String toString() {
    return '$code: $message';
  }
}
