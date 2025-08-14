import 'package:url_launcher/url_launcher.dart';

Future<void> openUrl(String url) async {
  final uri = Uri.parse(url);
  if (!await launchUrl(uri, mode: LaunchMode.platformDefault)) {
    throw 'Could not launch $url';
  }
}

Future<void> openEmail(String email) => openUrl('mailto:$email');
Future<void> openTel(String tel) => openUrl('tel:$tel');
