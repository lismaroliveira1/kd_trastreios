import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
import '../../../../i18n/i18n.dart';

StreamBuilder<UIError?> buildTrackingButton({
  required Stream<UIError?> uiErrorStream,
  required Function callback,
}) {
  return StreamBuilder<UIError?>(
    stream: uiErrorStream,
    builder: (context, snapshot) {
      return TextButton(
        onPressed: snapshot.data == UIError.noError ? () => callback() : null,
        child: Text(R.translations.getTracking),
      );
    },
  );
}
