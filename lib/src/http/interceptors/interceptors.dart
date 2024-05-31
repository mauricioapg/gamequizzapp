import 'package:flutter/cupertino.dart';
import 'package:http_interceptor/http/interceptor_contract.dart';
import 'package:http_interceptor/models/request_data.dart';
import 'package:http_interceptor/models/response_data.dart';


class LoggingInterceptor implements InterceptorContract {

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    debugPrint('REQUEST');
    debugPrint('URL: ' + data.baseUrl);
    debugPrint('Headers: ' + data.headers.toString());
    // debugPrint('Body: ' + data.body);
    debugPrint(data.toString());
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    debugPrint('RESPONSE');
    debugPrint('Status Code: ' + data.statusCode.toString());
    debugPrint('Headers: ' + data.headers.toString());
    // debugPrint('Body: ' + data.body.toString());
    debugPrint(data.toString());
    return data;
  }
}
