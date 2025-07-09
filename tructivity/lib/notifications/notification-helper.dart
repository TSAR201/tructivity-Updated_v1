import 'package:awesome_notifications/awesome_notifications.dart';

Future<void> createNotification({
  required int id,
  required String title,
  required String body,
  required DateTime datetime,
}) async {
  await AwesomeNotifications().createNotification(
    content: NotificationContent(
        id: id,
        channelKey: 'scheduled_channel',
        title: title,
        body: body,
        notificationLayout: NotificationLayout.BigText),
    schedule: NotificationCalendar(
      year: datetime.year,
      month: datetime.month,
      day: datetime.day,
      hour: datetime.hour,
      minute: datetime.minute,
      second: 0,
      millisecond: 0,
      repeats: true,
    ),

    // actionButtons: [
    //   NotificationActionButton(
    //     label: 'Mark Completed',
    //     enabled: true,
    //     showInCompactView: false,
    //     buttonType: ActionButtonType.Default,
    //     key: 'mark_completed',
    //   )
    // ],
  );
}

Future<void> cancelNotification({required int id}) async {
  await AwesomeNotifications().cancelSchedule(id);
}
