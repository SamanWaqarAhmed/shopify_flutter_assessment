import '../network/api_exception.dart';

String errorMessageOf(Object error) {
  if (error is ApiException) return error.message;
  return 'Something went wrong. Please try again.';
}
