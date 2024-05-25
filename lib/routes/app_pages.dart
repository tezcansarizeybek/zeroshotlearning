import 'package:get/get.dart';
import 'package:zeroshotmobile/modules/main/main_binding.dart';
import 'package:zeroshotmobile/modules/main/main_page.dart';

part 'app_routes.dart';

class AppPages {
  static const INITIAL = Routes.MAINPAGE;

  static final List<GetPage<dynamic>> routes = <GetPage>[
    // Auth Routes
    GetPage(
      name: Routes.MAINPAGE,
      page: () => MainPage(),
      binding: MainBinding(),
    ),
  ];
}
