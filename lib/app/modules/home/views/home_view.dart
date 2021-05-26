import 'package:animations/animations.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kd_rastreios_cp/app/i18n/i18n.dart';
import 'package:kd_rastreios_cp/app/modules/home/controllers/home_controller.dart';

class HomeView extends StatelessWidget {
  final HomeController controller;
  HomeView(this.controller);
  @override
  Widget build(BuildContext context) {
    void _hideKeyboard() {
      final currentFocus = FocusScope.of(context);
      if (!currentFocus.hasPrimaryFocus) {
        currentFocus.unfocus();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('HomeView'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              showModal(
                context: context,
                configuration: FadeScaleTransitionConfiguration(
                  transitionDuration: Duration(milliseconds: 600),
                  reverseTransitionDuration: Duration(milliseconds: 250),
                ),
                builder: (context) => Dialog(
                  child: InkWell(
                    onTap: () => _hideKeyboard(),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Container(
                        height: 240,
                        width: 300,
                        color: Colors.white,
                        child: Column(
                          children: <Widget>[
                            Text(R.translations.newTrackingPackage),
                            SizedBox(
                              height: 35,
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: R.translations.tranckindCode,
                              ),
                            ),
                            TextFormField(
                              decoration: InputDecoration(
                                labelText: R.translations.packageName,
                              ),
                            ),
                            Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  onPressed: () {},
                                  child: Text(R.translations.getTracking),
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
                ),
              );
            },
          ),
        ],
      ),
      bottomNavigationBar: Obx(
        () => BottomNavyBar(
          selectedIndex: controller.indexBottomBarOut,
          items: <BottomNavyBarItem>[
            BottomNavyBarItem(
              icon: Icon(Icons.apps),
              title: Text(R.translations.inTransit),
              activeColor: Colors.red,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.people),
              title: Text(R.translations.completed),
              activeColor: Colors.purpleAccent,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.location_city),
              title: Text(
                R.translations.nearbyAgencies,
              ),
              activeColor: Colors.pink,
              textAlign: TextAlign.center,
            ),
            BottomNavyBarItem(
              icon: Icon(Icons.settings),
              title: Text(R.translations.setup),
              activeColor: Colors.blue,
              textAlign: TextAlign.center,
            ),
          ],
          onItemSelected: (int value) => controller.changeIndexBottomBar(value),
        ),
      ),
      body: Center(
        child: Text(
          'HomeView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
