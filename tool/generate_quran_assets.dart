// Dart script to convert Tanzil-format Quran text into per-surah JSON assets.
//
// Input format (tanzil.net quran-uthmani.txt): each line is:
//   SURA|AYA|TEXT
// Example:
//   1|1|بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ
//   1|2|الْحَمْدُ لِلَّهِ رَبِّ الْعَالَمِينَ
//
// Usage:
//   dart run tool/generate_quran_assets.dart /path/to/quran-uthmani.txt assets/quran/uthmani
//
import 'dart:convert';
import 'dart:io';

Future<void> main(List<String> args) async {
  if (args.length != 2) {
    stderr.writeln('Usage: dart run tool/generate_quran_assets.dart <tanzil_txt> <out_dir>');
    exit(64);
  }
  final input = File(args[0]);
  final outDir = Directory(args[1]);

  if (!await input.exists()) {
    stderr.writeln('Input file not found: ${input.path}');
    exit(66);
  }
  if (!await outDir.exists()) {
    await outDir.create(recursive: true);
  }

  final Map<int, List<Map<String, dynamic>>> chapters = {};

  final lines = await input.readAsLines();
  for (final raw in lines) {
    final line = raw.trim();
    if (line.isEmpty) continue;
    final parts = line.split('|');
    if (parts.length < 3) continue;
    final sura = int.tryParse(parts[0]);
    final aya = int.tryParse(parts[1]);
    final text = parts.sublist(2).join('|'); // preserve any pipes in text
    if (sura == null || aya == null) continue;
    chapters.putIfAbsent(sura, () => []);
    chapters[sura]!.add({
      'chapter': sura,
      'verse': aya,
      'text': text,
    });
  }

  for (final entry in chapters.entries) {
    final sura = entry.key;
    final verses = entry.value..sort((a, b) => (a['verse'] as int).compareTo(b['verse'] as int));
    final jsonMap = {'chapter': verses};
    final outFile = File('${outDir.path}/surah_$sura.json');
    await outFile.writeAsString(const JsonEncoder.withIndent('  ').convert(jsonMap));
    stdout.writeln('Wrote ${outFile.path} (${verses.length} verses)');
  }

  stdout.writeln('Done. Generated ${chapters.length} surah files in ${outDir.path}');
}

