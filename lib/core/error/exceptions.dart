class ServerException implements Exception {
  final String message;
  ServerException({this.message = 'An unknown server error occurred.'});
}

class CacheException implements Exception {
  final String message;
  CacheException({this.message = 'An unknown cache error occurred.'});
}

class NetworkException implements Exception {
  final String message;
  NetworkException({this.message = 'A network error occurred. Please check your connection.'});
}
