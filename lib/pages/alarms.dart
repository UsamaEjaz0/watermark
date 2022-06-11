import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:watermark/dialogs/add_order.dart';
import 'package:watermark/dialogs/view_order.dart';
import 'package:watermark/models/order.dart';
import 'package:watermark/utils/app_config.dart';
import 'package:watermark/widgets/custom_list_item.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import '../main.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

import '../models/custom_order.dart';

class Alarms extends StatefulWidget {
  @override
  _AlarmsState createState() => _AlarmsState();
}

class _AlarmsState extends State<Alarms> {
  final key = GlobalKey<AnimatedListState>();

  CollectionReference ref = FirebaseFirestore.instance.collection('orders');

  @override
  Widget build(BuildContext ctxt) {
    SizeConfig().init(ctxt);
    return Container(
      alignment: Alignment.center,
      child: Column(children: [
        StreamBuilder(
            stream: ref.snapshots(),
            builder: (_, AsyncSnapshot<QuerySnapshot> snapshot) {
              return Expanded(
                  child: snapshot.hasData
                      ? ListView.builder(
                    key: key,
                    itemCount: snapshot.data.docs.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> doc = snapshot.data.docs[index]
                          .data();
                      if (doc['status'] == "pending") {
                        return buildItem(
                            new CustomOrder(
                                doc
                            ),
                            index, snapshot.data.docs[index].reference);
                      } else {
                        return SizedBox(height: 0,);
                      }
                    },
                  )
                      : Center(child: Text("No data found")));
            }),
      ]),
    );
  }


  Widget buildItem(CustomOrder item, int index, DocumentReference docRef) {
    return ListItemWidget(
      item: item,
      // onIconClicked: () => null,
      onItemClicked: (item) {
        // showDialog(
        //     context: context,
        //     builder: (BuildContext context) {
        //       return ViewOrder(order: item, docRef: docRef,);
        //     });
        scheduleAlarm();
      },
    );
  }

  void scheduleAlarm() async {
    DateTime scheduleAlarmDateTime;
    final now = DateTime.now();
    DateTime _alarmTime = DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute);
    if (_alarmTime.isAfter(DateTime.now()))
      scheduleAlarmDateTime = _alarmTime.add(Duration(seconds: 10));
    else
      scheduleAlarmDateTime = _alarmTime.add(Duration(days: 1, seconds: 10));
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'alarm_notif',
      'alarm_notif',
      'Channel for Alarm notification',
      icon: 'codex_logo',
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
      largeIcon: DrawableResourceAndroidBitmap('codex_logo'),
    );

    var iOSPlatformChannelSpecifics = IOSNotificationDetails(
        sound: 'a_long_cold_sting.wav',
        presentAlert: true,
        presentBadge: true,
        presentSound: true);
    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.schedule(0, 'Office', "Usama",
        DateTime.now(), platformChannelSpecifics);
  }
  Future<void> _showGroupedNotifications() async {
    const String groupKey = 'com.android.example.WORK_EMAIL';
    const String groupChannelId = 'grouped channel id';
    const String groupChannelName = 'grouped channel name';
    const String groupChannelDescription = 'grouped channel description';
    // example based on https://developer.android.com/training/notify-user/group.html
    const AndroidNotificationDetails firstNotificationAndroidSpecifics =
    AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey,
      sound: RawResourceAndroidNotificationSound('a_long_cold_sting'),
    );
    const NotificationDetails firstNotificationPlatformSpecifics = NotificationDetails(android: firstNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(1, 'Alex Faarborg',
        'You will not believe...', firstNotificationPlatformSpecifics);
    const AndroidNotificationDetails secondNotificationAndroidSpecifics =
    AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        importance: Importance.max,
        priority: Priority.high,
        groupKey: groupKey,
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting'));
    const NotificationDetails secondNotificationPlatformSpecifics =
    NotificationDetails(android: secondNotificationAndroidSpecifics);
    await flutterLocalNotificationsPlugin.show(
        2,
        'Jeff Chang',
        'Please join us to celebrate the...',
        secondNotificationPlatformSpecifics);

    // Create the summary notification to support older devices that pre-date
    /// Android 7.0 (API level 24).
    ///
    /// Recommended to create this regardless as the behaviour may vary as
    /// mentioned in https://developer.android.com/training/notify-user/group
    const List<String> lines = <String>[
      'Alex Faarborg  Check this out',
      'Jeff Chang    Launch Party'
    ];
    const InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
        lines,
        contentTitle: '2 messages',
        summaryText: 'janedoe@example.com');
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
        groupChannelId, groupChannelName, groupChannelDescription,
        styleInformation: inboxStyleInformation,
        groupKey: groupKey,
        setAsGroupSummary: true,
        sound: RawResourceAndroidNotificationSound('a_long_cold_sting')
    );
    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        3, 'Attention', 'Two messages', platformChannelSpecifics);
  }

  // Future<void> _scheduleDailyTenAMNotification() async {
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //       0,
  //       'daily scheduled notification title',
  //       'daily scheduled notification body',
  //       _nextInstanceOfTenAM(),
  //
  //       const NotificationDetails(
  //         android: AndroidNotificationDetails(
  //             'daily notification channel id',
  //             'daily notification channel name',
  //             'daily notification description',
  //             sound: RawResourceAndroidNotificationSound('a_long_cold_sting')),
  //       ),
  //       androidAllowWhileIdle: true,
  //       uiLocalNotificationDateInterpretation:
  //       UILocalNotificationDateInterpretation.absoluteTime,
  //       matchDateTimeComponents: DateTimeComponents.time);
  // }


  // tz.TZDateTime _nextInstanceOfTenAM() {
  //   final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  //   tz.TZDateTime scheduledDate =
  //   tz.TZDateTime(tz.local, now.year, now.month, now.day, 6);
  //   if (scheduledDate.isBefore(now)) {
  //     scheduledDate = scheduledDate.add(const Duration(days: 1));
  //   }
  //   return scheduledDate;
  // }
}
