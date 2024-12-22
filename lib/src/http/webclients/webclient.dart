import 'package:http/http.dart';
import 'package:http_interceptor/http/intercepted_client.dart';
import 'package:gamequizzapp/src/http/interceptors/interceptors.dart';


const String baseAPIUrl = "https://quizzgameapi-ji6nrrlm7q-uc.a.run.app";
// const String baseAPIUrl = "http://192.168.1.102:8080";

final Client client = InterceptedClient.build(
    interceptors: [LoggingInterceptor()],
    requestTimeout: const Duration(seconds: 5)
);
