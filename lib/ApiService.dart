import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:path_provider/path_provider.dart';

class ApiService {
  late Dio dio;
  late CookieJar cookieJar;

  ApiService() {
    dio = Dio();
    _initCookies();
  }

  Future<void> _initCookies() async {
    final dir = await getApplicationDocumentsDirectory();
    cookieJar = PersistCookieJar(storage: FileStorage(dir.path));
    dio.interceptors.add(CookieManager(cookieJar));
  }

  // ✅ دالة لضبط الكوكيز في Dio
  void setCookies(String cookies) {
    dio.options.headers["Cookie"] = cookies;
    print("✅ الكوكيز تم إضافتها إلى Dio: $cookies");
  }

  Future<List<dynamic>?> login() async {
    try {
      final response = await dio.get(
        "https://sezelhelp.com/wp-json/auth/v1/login",
        options: Options(
          headers: {
            "Content-Type": "application/json",
          },
        ),
      );

      if (response.statusCode! >= 200 && response.data["success"] == true) {
        // String token = response.data["token"];
        List<dynamic> tokens = [
          response.data["token"],
          response.data["user_id"],
        ];
        print("✅ تسجيل الدخول ناجح! jwttoken: ${tokens[0]} ");
        print("✅ تسجيل الدخول ناجح! user_id: ${tokens[1]} ");

        return tokens;
      } else {
        print("❌ فشل تسجيل الدخول: ${response.data["error"]}");
        return null;
      }
    } catch (e) {
      print("🚨 خطأ أثناء تسجيل الدخول: $e");
      return null;
    }
  }
}
