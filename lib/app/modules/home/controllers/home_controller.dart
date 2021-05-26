import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/helpers/ui_error.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_use_cases.dart';

class HomeController extends GetxController {
  final HomeUseCases homeUseCases;
  HomeController(this.homeUseCases);

  var _indexBottomBar = 0.obs;
  var _trackingName = ''.obs;
  var _trackingCode = ''.obs;
  var _codeFieldError = Rx<UIError>(UIError.noError);
  var _nameFieldError = Rx<UIError>(UIError.noError);
  var _isValidFields = Rx<UIError>(UIError.invalidFields);

  int get indexBottomBarOut => _indexBottomBar.value;
  Stream<UIError?> get codeFieldErrorStream => _codeFieldError.stream;
  Stream<UIError?> get nameFieldErrorStream => _nameFieldError.stream;
  Stream<UIError?> get isValidFieldOut => _isValidFields.stream;

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
    _trackingCode.value = value;
    if (value.length == 0) _isValidFields.value = UIError.invalidFields;
    value.length <= 10
        ? _codeFieldError.value = UIError.invalidCode
        : _codeFieldError.value = UIError.noError;
    validateButton();
  }

  void validateName(String value) {
    _trackingName.value = value;
    if (value.length == 0) _isValidFields.value = UIError.invalidFields;
    value.length < 2
        ? _nameFieldError.value = UIError.invalidName
        : _nameFieldError.value = UIError.noError;
    validateButton();
  }

  void validateButton() {
    _nameFieldError.value == UIError.noError &&
            _trackingName.value != '' &&
            _trackingCode.value != '' &&
            _codeFieldError.value == UIError.noError
        ? _isValidFields.value = UIError.noError
        : _isValidFields.value = UIError.invalidFields;
  }

  Future<void> getPackage() async {
    await homeUseCases.getPackages(_trackingCode.value);
  }
}
