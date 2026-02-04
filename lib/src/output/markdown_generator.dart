import '../models/annotation.dart';

class MarkdownGenerator {
  String generate(List<Annotation> annotations) {
    // If empty
    if (annotations.isEmpty) {
      return 'No annotations.';
    }

    final buffer = StringBuffer();
    buffer.writeln('## UI Feedback (${annotations.length} annotations)');
    buffer.writeln();

    for (int i = 0; i < annotations.length; i++) {
      final a = annotations[i];
      final w = a.widgetData;

      buffer.writeln('### #${i + 1} ${w.type}');

      // Location
      String loc = '${w.file}:${w.line}';
      if (w.column != null) loc += ':${w.column}';
      buffer.writeln('- 📍 $loc');

      if (w.key != null) {
        buffer.writeln('- 🔑 Key: ${w.key}');
      }
      if (w.size != null) {
        buffer.writeln(
            '- 📐 Size: ${w.size!.width.toInt()}×${w.size!.height.toInt()}');
      }
      if (w.textContent != null) {
        buffer.writeln('- 🔤 Content: "${w.textContent}"');
      }

      // Properties - show top 5 or all?
      // Doc says "main properties (max 5)"
      final importantProps = w.properties.entries.take(5);
      for (final prop in importantProps) {
        buffer.writeln('- 🎨 ${prop.key}: ${prop.value}');
      }

      if (w.parentChain.isNotEmpty) {
        buffer.writeln('- 🌳 Parent: ${w.parentChain.join(' > ')}');
      }

      // Inner widget info
      if (w.childWidgets.isNotEmpty) {
        buffer.writeln('- 🔽 Contains:');
        for (final child in w.childWidgets) {
          buffer.writeln('  - ${child.type} (${child.file}:${child.line})');
        }
      }

      buffer.writeln('- 💬 "${a.note}"');
      buffer.writeln();
    }

    return buffer.toString();
  }
}
