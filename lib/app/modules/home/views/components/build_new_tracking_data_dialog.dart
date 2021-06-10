import 'package:flutter/material.dart';

import '../../../../helpers/helpers.dart';
import '../../../../i18n/i18n.dart';
import './components.dart';

Dialog buildNewTrackingDialog({
  required Stream<UIError?> nameFieldErrorStream,
  required Stream<UIError?> codeFieldErrorStream,
  required Stream<UIError?> uiErrorStream,
  required Function(String value) validateName,
  required Function(String value) validateCode,
  required Function getTrackings,
  required bool isBarCode,
}) {
  return Dialog(
    child: InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Container(
          height: 240,
          width: 300,
          child: Column(
            children: <Widget>[
              Text(R.translations.newTrackingPackage),
              Spacer(),
              !isBarCode
                  ? buildCodeTextField(
                      codeFieldErrorStream: codeFieldErrorStream,
                      validateCode: (value) => validateCode(value),
                    )
                  : Container(),
              buildNameTextField(
                  nameFieldErrorStream: nameFieldErrorStream,
                  validateName: (value) => validateName(value)),
              Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  buildTrackingButton(
                    callback: () => getTrackings(),
                    uiErrorStream: uiErrorStream,
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(R.translations.cancel),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    ),
  );
}
