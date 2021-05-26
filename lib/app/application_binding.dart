import 'package:get/get.dart';
import 'package:http/http.dart';

class ApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => Client());
  }
}
