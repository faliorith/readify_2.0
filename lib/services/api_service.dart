import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_service.g.dart';

@RestApi(baseUrl: 'https://www.googleapis.com/books/v1/')
abstract class ApiService {
  factory ApiService(Dio dio) = _ApiService;

  @GET('volumes')
  Future<Map<String, dynamic>> searchBooks(
    @Query('q') String query,
    @Query('maxResults') int maxResults,
  );
}