import 'package:flutter_sms/flutter_sms.dart';

void sendTextMessage(String message, List<String> recipients) async {
  String result = await sendSMS(message: message, recipients: recipients);
  print(result); // You can change this to show the result in your UI
}
