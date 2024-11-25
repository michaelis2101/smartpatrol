import 'package:flutter/material.dart';
import 'package:open_settings/open_settings.dart';
import 'package:smart_patrol/utils/styles/colors.dart';

class WidgetToolbarStatusPage extends StatelessWidget {
  const WidgetToolbarStatusPage(
      {super.key,
      required this.appName,
      required this.isOnline,
      required this.showIconCalendar});

  final String appName;
  final bool showIconCalendar, isOnline;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: () {
          OpenSettings.openWIFISetting();
        },
        child: Row(
          children: [
            Container(
                padding: const EdgeInsets.only(right: 12),
                child: Text(isOnline ? 'Online' : 'Offline',
                    style: const TextStyle(color: Colors.white))),
            Container(
              padding: const EdgeInsets.only(right: 12),
              height: 12,
              width: 12,
              decoration: BoxDecoration(
                  border: const Border(
                    top: BorderSide(color: Color(0xFFFFFFFF)),
                    left: BorderSide(color: Color(0xFFFFFFFF)),
                    right: BorderSide(color: Color(0xFFFFFFFF)),
                    bottom: BorderSide(color: Color(0xFFFFFFFF)),
                  ),
                  shape: BoxShape.circle, //making box to circle
                  color: isOnline ? kGreen : kGreyLight),
            ),
            Container(
              padding: const EdgeInsets.only(right: 12),
            )
          ],
        ),
      );
}
