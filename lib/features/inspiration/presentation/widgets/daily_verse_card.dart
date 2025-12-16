import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';

class DailyVerseCard extends StatelessWidget {
  const DailyVerseCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Use cardColor or a specific surface color from the scheme
    final cardColor = theme.cardColor; 
    final primaryColor = theme.colorScheme.primary;

    const String verseText = "Mira que te mando que te esfuerces y seas valiente; no temas ni desmayes, porque Jehová tu Dios estará contigo en dondequiera que vayas.";
    const String reference = "Josué 1:9";

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero, // Controlled by parent
      color: cardColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header: "Maná del Día" + Quote Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Maná del Día",
                  style: theme.textTheme.titleSmall?.copyWith(
                    color: primaryColor,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                Icon(Icons.format_quote_rounded, color: primaryColor.withOpacity(0.5)),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Verse Text
            Text(
              verseText,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontStyle: FontStyle.italic,
                height: 1.5,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
            
            const SizedBox(height: 12),
            
            // Reference
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                "- $reference",
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1),
            
            // Actions (Minimalist)
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () {
                    Clipboard.setData(const ClipboardData(text: '$verseText - $reference'));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Copiado'), duration: Duration(milliseconds: 800)),
                    );
                  },
                  icon: const Icon(Icons.copy, size: 18),
                  label: const Text("Copiar"),
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onSurfaceVariant),
                ),
                TextButton.icon(
                  onPressed: () {
                    Share.share('$verseText - $reference\n\nCompartido desde Redil App');
                  },
                  icon: const Icon(Icons.share, size: 18),
                  label: const Text("Compartir"),
                  style: TextButton.styleFrom(foregroundColor: theme.colorScheme.onSurfaceVariant),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
