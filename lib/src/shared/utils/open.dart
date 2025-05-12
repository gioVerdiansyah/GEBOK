import 'package:url_launcher/url_launcher.dart';

void openWhatsApp({required String phoneNumber, String? message}) async {
  Uri url;

  if (message != null && message.isNotEmpty) {
    url = Uri.parse("https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}");
  } else {
    url = Uri.parse("https://wa.me/$phoneNumber");
  }

  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $url';
  }
}

void openEmail({
  required String email,
  String? subject,
  String? body,
}) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    query: {
      if (subject != null && subject.isNotEmpty) 'subject': subject,
      if (body != null && body.isNotEmpty) 'body': body,
    }.entries.map((entry) => '${entry.key}=${Uri.encodeComponent(entry.value)}').join('&'),
  );

  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch $emailUri';
  }
}
