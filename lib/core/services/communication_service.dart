import 'package:injectable/injectable.dart';
import 'package:url_launcher/url_launcher.dart';

@lazySingleton
class CommunicationService {
  Future<void> openWhatsApp(String phoneNumber, {String? message}) async {
    // Sanitization: Remove non-numeric characters except +
    final sanitizedNumber = phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
    
    // Construct URL
    // If number doesn't start with +, we might need country code, but 
    // for now we trust the input or the user's contact list format.
    // WhatsApp usually prefers full international format.
    
    final uri = Uri.parse(
      'https://wa.me/$sanitizedNumber?text=${Uri.encodeComponent(message ?? '')}'
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp for $sanitizedNumber';
    }
  }
}
