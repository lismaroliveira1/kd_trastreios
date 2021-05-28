import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
import '../../../../i18n/i18n.dart';

StreamBuilder<UIError?> buildNameTextField({
  required Stream<UIError?> nameFieldErrorStream,
  required Function(String value) validateName,
}) {
  return StreamBuilder<UIError?>(
    stream: nameFieldErrorStream,
    builder: (context, snapshot) {
      return TextFormField(
        onChanged: (value) => validateName(value),
        decoration: InputDecoration(
          labelText: R.translations.packageName,
          errorText: snapshot.data == UIError.noError
              ? null
              : snapshot.data?.description,
        ),
      );
    },
  );
}
