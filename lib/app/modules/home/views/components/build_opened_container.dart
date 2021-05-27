import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:timelines/timelines.dart';

Widget buildOpenedContainer(Map package, BuildContext context) {
  List<dynamic> _trackings = package['trackings'];
  return Container(
    color: Theme.of(Get.context!).backgroundColor,
    child: SafeArea(
      child: ListView(
        children: <Widget>[
          Text(package['name']),
          Text(package['code']),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: FixedTimeline.tileBuilder(
              theme: TimelineTheme.of(context).copyWith(
                nodePosition: 0,
                connectorTheme:
                    TimelineTheme.of(context).connectorTheme.copyWith(
                          thickness: 2.0,
                          indent: 3.0,
                        ),
                indicatorTheme:
                    TimelineTheme.of(context).indicatorTheme.copyWith(
                          size: 20.0,
                          position: 0,
                        ),
              ),
              builder: TimelineTileBuilder(
                indicatorBuilder: (_, index) =>
                    Indicator.outlined(borderWidth: 1.0),
                startConnectorBuilder: (_, index) => Connector.solidLine(),
                endConnectorBuilder: (_, index) => Connector.solidLine(),
                contentsBuilder: (_, index) {
                  int _countItens = 4;
                  if (_trackings[index]['destiny'] == '') _countItens = 3;
                  return Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(_trackings[index]['description']),
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        FixedTimeline.tileBuilder(
                          theme: TimelineTheme.of(context).copyWith(
                            nodePosition: 0,
                            connectorTheme: TimelineTheme.of(context)
                                .connectorTheme
                                .copyWith(
                                  thickness: 1.0,
                                ),
                            indicatorTheme: TimelineTheme.of(context)
                                .indicatorTheme
                                .copyWith(
                                  size: 6.0,
                                  position: 0.4,
                                ),
                          ),
                          builder: TimelineTileBuilder(
                            contentsAlign: ContentsAlign.basic,
                            indicatorBuilder: (_, indexChild) =>
                                Indicator.outlined(borderWidth: 1.0),
                            startConnectorBuilder: (_, indexChild) =>
                                Connector.solidLine(),
                            endConnectorBuilder: (_, indexChild) =>
                                Connector.solidLine(),
                            contentsBuilder: (_, indexChild) {
                              String value() {
                                switch (indexChild) {
                                  case 0:
                                    return 'Data: ${_trackings[index]['dataTime'].split(' ')[0]}';
                                  case 1:
                                    return 'Hora: ${_trackings[index]['dataTime'].split(' ')[1]}';
                                  case 2:
                                    return 'Cidade origem: ${_trackings[index]['city']}';
                                  case 3:
                                    if (_trackings[index]['destiny'] == '') {
                                      return '';
                                    }
                                    return 'Cidade destino: ${_trackings[index]['destiny']}';
                                }
                                return '';
                              }

                              return Padding(
                                padding: EdgeInsets.only(left: 8.0),
                                child: Column(
                                  children: [Text(value())],
                                ),
                              );
                            },
                            itemExtentBuilder: (_, index) => 20,
                            itemCount: _countItens,
                          ),
                        ),
                      ],
                    ),
                  );
                },
                itemExtentBuilder: (_, index) => 120,
                itemCount: _trackings.length,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
