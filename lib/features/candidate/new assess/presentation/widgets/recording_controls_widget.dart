import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import '../controller/assessment_session_cubit.dart';
import 'audio_waveform_widget.dart';

/// Owns AudioRecorder + AudioPlayer hardware resources.
/// StatefulWidget is required because these objects have lifecycle (dispose).
class RecordingControlsWidget extends StatefulWidget {
  const RecordingControlsWidget({super.key});

  @override
  State<RecordingControlsWidget> createState() => _RecordingControlsWidgetState();
}

class _RecordingControlsWidgetState extends State<RecordingControlsWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  @override
  void dispose() {
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _startRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    final questionId = cubit.state.currentQuestion?.id ?? 'q';
    final path = '${dir.path}/recording_$questionId.m4a';

    await _recorder.start(
      RecordConfig(encoder: AudioEncoder.aacLc, bitRate: 128000, sampleRate: 44100),
      path: path,
    );
    cubit.onRecordingStarted();
  }

  Future<void> _stopRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final path = await _recorder.stop();
    if (path != null) cubit.onRecordingStopped(path);
  }

  Future<void> _playRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final path = cubit.state.recordingPath;
    if (path.isEmpty) return;

    cubit.onPlaybackStarted();
    await _player.play(DeviceFileSource(path));
    _player.onPlayerComplete.listen((_) {
      if (mounted) cubit.onPlaybackStopped();
    });
  }

  Future<void> _stopPlayback(BuildContext context) async {
    await _player.stop();
    if (mounted) context.read<AssessmentSessionCubit>().onPlaybackStopped();
  }

  Future<void> _deleteRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final path = cubit.state.recordingPath;
    if (path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
    cubit.onRecordingDeleted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessmentSessionCubit, AssessmentSessionState>(
      buildWhen: (prev, curr) => prev.recordingState != curr.recordingState,
      builder: (context, state) {
        final rs = state.recordingState;

        return Column(
          children: [
            // Waveform (shown while recording or recorded)
            if (rs == RecordingState.recording || rs == RecordingState.recorded || rs == RecordingState.playing)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: AudioWaveformWidget(
                  isAnimating: rs == RecordingState.recording,
                  color: rs == RecordingState.recording
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF3B82F6),
                ),
              ),

            // Controls row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (rs == RecordingState.idle) ...[
                  // Big record button
                  _BigCircleButton(
                    color: const Color(0xFFEF4444),
                    icon: Icons.mic_rounded,
                    label: 'Tap to Record',
                    onTap: () => _startRecording(context),
                  ),
                ] else if (rs == RecordingState.recording) ...[
                  // Delete (enabled when recording: cancel)
                  _SmallCircleButton(
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFEF4444),
                    onTap: () => _deleteRecording(context),
                  ),
                  const SizedBox(width: 24),
                  // Stop button
                  _BigCircleButton(
                    color: const Color(0xFFEF4444),
                    icon: Icons.stop_rounded,
                    label: 'Stop',
                    onTap: () => _stopRecording(context),
                  ),
                ] else if (rs == RecordingState.recorded) ...[
                  // Delete
                  _SmallCircleButton(
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFEF4444),
                    onTap: () => _deleteRecording(context),
                  ),
                  const SizedBox(width: 24),
                  // Play
                  _BigCircleButton(
                    color: const Color(0xFF3B82F6),
                    icon: Icons.play_arrow_rounded,
                    label: 'Play Answer',
                    onTap: () => _playRecording(context),
                  ),
                  const SizedBox(width: 24),
                  // Re-record
                  _SmallCircleButton(
                    icon: Icons.mic_rounded,
                    color: const Color(0xFF64748B),
                    onTap: () => _startRecording(context),
                  ),
                ] else if (rs == RecordingState.playing) ...[
                  // Stop playback
                  _BigCircleButton(
                    color: const Color(0xFF3B82F6),
                    icon: Icons.pause_rounded,
                    label: 'Pause',
                    onTap: () => _stopPlayback(context),
                  ),
                ],
              ],
            ),
          ],
        );
      },
    );
  }
}

class _BigCircleButton extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _BigCircleButton({
    required this.color,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 36),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF64748B),
              fontFamily: 'Inter_Regular',
            )),
      ],
    );
  }
}

class _SmallCircleButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _SmallCircleButton({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: color, size: 24),
      ),
    );
  }
}
