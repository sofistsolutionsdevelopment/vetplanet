import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class HostelMessaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =  "AAAA4rTHq88:APA91bH00yZ7aw4T-9975ULCcRT8Tk-iaX2LIf2oqwThYjM8zsTJcPrx73ma68rDWfWi--rUfb8ktxPB_ymDBmPA-jqenbuUljT-Q_Il_YwwLHAjSuSZhk5qDaP_i4blIRAdPcvuQdVm";

  static Future<Response> sendToAll({
    @required String title,
    @required String body,
  }) =>
      sendToTopic(title: title, body: body, topic: 'all');

  static Future<Response> sendToTopic(
      {@required String title,
        @required String body,
        @required String topic}) =>
      sendTo(title: title, body: body, fcmToken: '/topics/$topic');

  static Future<Response> sendTo({
    @required String title,
    @required String body,
    @required String fcmToken,
  }) =>
      client.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: json.encode({
          'notification': {'body': '$body', 'title': '$title'},
          'priority': 'high',
          'data': {
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done',
          },
          'to': '$fcmToken',
        }),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'key=$serverKey',
        },
      );


}
