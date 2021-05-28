import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
import '../../../../i18n/i18n.dart';

StreamBuilder<UIError?> buildCodeTextField({
  required Stream<UIError?> codeFieldErrorStream,
  required Function(String value) validateCode,
}) {
  return StreamBuilder<UIError?>(
      stream: codeFieldErrorStream,
      builder: (context, snapshot) {
        return TextFormField(
          onChanged: (value) => validateCode(value),
          decoration: InputDecoration(
            labelText: R.translations.tranckindCode,
            errorText: snapshot.data == UIError.noError
                ? null
                : snapshot.data?.description,
          ),
        );
      });
}
