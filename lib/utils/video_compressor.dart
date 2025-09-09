// lib/utils/video_compressor.dart
import 'dart:io';
import 'package:ffmpeg_kit_flutter_new/ffmpeg_kit.dart';
import 'package:path/path.dart' as p;

/// Compresses the given video [input] to H.264 MP4 with a sensible default preset.
/// Returns the output [File]. Throws on failure.
Future<File> compressVideo(
    File input, {
      int targetMaxWidth = 1280,
      int targetFps = 30,
      int crf = 22,
      String preset = 'veryfast', // swap to 'slow' if you prefer smaller files
      int audioBitrateKbps = 128,
    }) async {
  final outPath = p.withoutExtension(input.path) + "_compressed.mp4";

  final cmd = [
    '-y', // overwrite
    '-i', input.path,
    // Video
    '-c:v', 'libx264',
    '-crf', '$crf',
    '-preset', preset,
    '-pix_fmt', 'yuv420p',
    '-vf',
    "scale=w='min($targetMaxWidth,iw)':h=-2:force_original_aspect_ratio=decrease,fps=$targetFps",
    // Audio
    '-c:a', 'aac',
    '-b:a', '${audioBitrateKbps}k',
    // Progressive start
    '-movflags', '+faststart',
    outPath,
  ].join(' ');

  final session = await FFmpegKit.execute(cmd);
  final rc = await session.getReturnCode();
  if (rc?.isValueSuccess() == true) {
    return File(outPath);
  } else {
    final logs = await session.getAllLogsAsString();
    throw Exception('Video compression failed (rc=$rc)\n$logs');
  }
}
