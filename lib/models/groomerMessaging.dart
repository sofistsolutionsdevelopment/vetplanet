import 'dart:convert';
import 'package:http/http.dart';
import 'package:meta/meta.dart';

class GroomerMessaging {
  static final Client client = Client();

  // from 'https://console.firebase.google.com'
  // --> project settings --> cloud messaging --> "Server key"
  static const String serverKey =  "AAAAfegfixY:APA91bFWn6i-sLz3vhmyiy5_qny0upO4aU1gnR1fRgbUbYz2fPzGCyN9gBNPBfaqttSP0bhDFOrf4kCVlBYvfikfKgoIzPMT1dTkWFN_joQzuZk5w1aRTExxyyoICbbxZnz8mAXOH6rp";

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
