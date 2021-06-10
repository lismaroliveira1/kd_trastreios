import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';

import '../../../../i18n/i18n.dart';

BottomNavyBar buildBottomNavyBar({
  required int index,
  required Function(int value) onItemSelected,
}) {
  return BottomNavyBar(
    selectedIndex: index,
    items: <BottomNavyBarItem>[
      BottomNavyBarItem(
        icon: Icon(Icons.track_changes),
        title: Text(R.translations.inTransit),
        activeColor: Colors.red,
        textAlign: TextAlign.center,
      ),
      BottomNavyBarItem(
        icon: Icon(Icons.check),
        title: Text(R.translations.completed),
        activeColor: Colors.purpleAccent,
        textAlign: TextAlign.center,
      ),
      BottomNavyBarItem(
        icon: Icon(Icons.settings),
        title: Text(R.translations.setup),
        activeColor: Colors.blue,
        textAlign: TextAlign.center,
      ),
    ],
    onItemSelected: (int value) => onItemSelected(value),
  );
}
