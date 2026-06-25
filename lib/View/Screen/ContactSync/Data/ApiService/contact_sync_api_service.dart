import 'package:dio/dio.dart';
import '../../../../../helper/shared_prefe/shared_prefe.dart';
import '../../../../../service/api_url.dart';

abstract class ContactSyncApiService {
  Future<Map<String, dynamic>> uploadContacts(List<Map<String, String>> contacts);
}

class ContactSyncApiServiceImpl implements ContactSyncApiService {
  final Dio _dio;

  ContactSyncApiServiceImpl({Dio? dio}) : _dio = dio ?? Dio() {
    _dio.options.baseUrl = ApiUrl.baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 15);
    _dio.options.receiveTimeout = const Duration(seconds: 15);
  }

  @override
  Future<Map<String, dynamic>> uploadContacts(List<Map<String, String>> contacts) async {
    final token = await SharedPrefsHelper.getToken();
    final response = await _dio.post(
      '/social/sync-contacts',
      data: {
        'contacts': contacts,
      },
      options: Options(
        headers: {
          'Content-Type': 'application/json',
          if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
        },
      ),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.data['data'] as Map<String, dynamic>;
    } else {
      throw DioException(
        requestOptions: response.requestOptions,
        response: response,
        type: DioExceptionType.badResponse,
      );
    }
  }
}
