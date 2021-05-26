import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/helpers/ui_error.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_use_cases.dart';

class HomeController extends GetxController {
  final HomeUseCases homeUseCases;
  HomeController(this.homeUseCases);

  var _indexBottomBar = 0.obs;
  var _codeFieldError = Rx<UIError>(UIError.noError);
  var _nameFieldError = Rx<UIError>(UIError.noError);

  int get indexBottomBarOut => _indexBottomBar.value;
  Stream<UIError?> get codeFieldErrorStream => _codeFieldError.stream;
  Stream<UIError?> get nameFieldErrorStream => _nameFieldError.stream;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  void changeIndexBottomBar(int index) {
    _indexBottomBar.value = index;
  }

  @override
  void onClose() {}

  void validateCode(String value) {
    value.length <= 10
        ? _codeFieldError.value = UIError.invalidCode
        : _codeFieldError.value = UIError.noError;
  }

  void validateName(String value) {
    value.length > 2
        ? _nameFieldError.value = UIError.noError
        : _nameFieldError.value = UIError.invalidName;
  }
}
