import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intelli_hire/features/candidate/new%20assess/presentation/widgets/small_circle_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:record/record.dart';

import '../../../../../core/utils/app_font.dart';
import '../controller/assessment_session_cubit.dart';
import 'audio_waveform_widget.dart';
import 'big_circle_button.dart';

/// Owns AudioRecorder + AudioPlayer hardware resources.
/// StatefulWidget is required because these objects have lifecycle (dispose).
class RecordingControlsWidget extends StatefulWidget {
  const RecordingControlsWidget({super.key});

  @override
  State<RecordingControlsWidget> createState() =>
      _RecordingControlsWidgetState();
}

class _RecordingControlsWidgetState extends State<RecordingControlsWidget> {
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();
  Timer? _timer;
  int _recordDuration = 0;

  @override
  void dispose() {
    _recorder.dispose;
    _timer?.cancel(); // 🌟 تأمين التايمر();
    _player.dispose();
    super.dispose();
  }

  String _formatNumber(int number) {
    String numberStr = number.toString();
    if (number < 10) {
      numberStr = '0$numberStr';
    }
    return numberStr;
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _recordDuration = 0); // تصفير العداد قبل ما يبدأ

    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() => _recordDuration++);
    });
  }

  // 🌟 دالة إيقاف التايمر
  void _stopTimer() {
    _timer?.cancel();
  }

  Future<void> _startRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final hasPermission = await _recorder.hasPermission();
    if (!hasPermission) return;

    final dir = await getTemporaryDirectory();
    final questionId = cubit.state.currentQuestion?.id ?? 'q';
    final path = '${dir.path}/recording_$questionId.m4a';

    await _recorder.start(
      RecordConfig(
        encoder: AudioEncoder.aacEld,
        bitRate: 128000,
        sampleRate: 44100,
        // تفعيل دول بيحسن جودة الصوت جداً وبيشيل الوش
        echoCancel: true,
        noiseSuppress: true,
        autoGain: true,
      ),
      path: path,
    );
    _startTimer(); // 🌟 تشغيل التايمر
    cubit.onRecordingStarted();
  }

  Future<void> _stopRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final path = await _recorder.stop();
    _stopTimer(); // 🌟 إيقاف التايمر
    if (path != null) cubit.onRecordingStopped(path);
  }

  Future<void> _playRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final path = cubit.state.recordingPath;
    if (path.isEmpty) return;

    cubit.onPlaybackStarted();
    await _player.play(DeviceFileSource(path));
    _startTimer(); // 🌟 تشغيل التايمر
    _player.onPlayerComplete.listen((_) {
      _stopTimer(); // 🌟 إيقاف التايمر
      if (mounted) cubit.onPlaybackStopped();
    });
  }

  Future<void> _stopPlayback(BuildContext context) async {
    await _player.stop();
    _stopTimer(); // 🌟 إيقاف التايمر
    if (mounted) context.read<AssessmentSessionCubit>().onPlaybackStopped();
  }

  Future<void> _deleteRecording(BuildContext context) async {
    final cubit = context.read<AssessmentSessionCubit>();
    final path = cubit.state.recordingPath;
    if (path.isNotEmpty) {
      final file = File(path);
      if (await file.exists()) await file.delete();
    }
    _stopTimer(); // 🌟 تأكيد الإيقاف
    setState(() => _recordDuration = 0); // 🌟 تصفير العداد
    cubit.onRecordingDeleted();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AssessmentSessionCubit, AssessmentSessionState>(
      buildWhen: (prev, curr) => prev.recordingState != curr.recordingState,
      builder: (context, state) {
        final rs = state.recordingState;
        // 🌟 حساب الدقائق والثواني
        final minutes = _formatNumber(_recordDuration ~/ 60);
        final seconds = _formatNumber(_recordDuration % 60);

        return Column(
          children: [
            // Waveform (shown while recording or recorded)
            if (rs == RecordingState.recording ||
                rs == RecordingState.recorded ||
                rs == RecordingState.playing)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$minutes:$seconds',
                      style: const TextStyle(
                        fontSize: 16,
                        fontFamily: AppFont.interBold,
                        color: Color(0xFF134CC7),
                        fontFeatures: [FontFeature.tabularFigures()],
                      ),
                    ),
                    const SizedBox(width: 12),
                    AudioWaveformWidget(
                      isAnimating: rs == RecordingState.recording,
                      color: const Color(0xFF134CC7),
                    ),

                  ],
                ),
              ),

            // Controls row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (rs == RecordingState.idle) ...[
                  // Big record button
                  BigCircleButton(
                    color: const Color(0xFF134CC7),
                    icon: Icons.mic_rounded,
                    label: 'Tap to Record',
                    onTap: () => _startRecording(context),
                  ),
                ]
                else if (rs == RecordingState.recording) ...[
                  // Delete (enabled when recording: cancel)
                  SmallCircleButton(
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFEF4444),
                    onTap: () {
                      _recorder.stop(); // وقف التسجيل الأول
                      _deleteRecording(context);
                    },
                  ),
                  const SizedBox(width: 24),
                  // Stop button
                  BigCircleButton(
                    color: const Color(0xFFEF4444),
                    icon: Icons.stop_rounded,
                    label: 'Stop',
                    onTap: () => _stopRecording(context),
                  ),
                ]
                else if (rs == RecordingState.recorded) ...[
                  // Delete
                  SmallCircleButton(
                    icon: Icons.delete_outline_rounded,
                    color: const Color(0xFFEF4444),
                    onTap: () => _deleteRecording(context),
                  ),
                  const SizedBox(width: 24),
                  // Play
                  BigCircleButton(
                    color: const Color(0xFF134CC7),
                    icon: Icons.play_arrow_rounded,
                    label: 'Play Answer',
                    onTap: () => _playRecording(context),
                  ),
                  const SizedBox(width: 24),
                  // Re-record
                  SmallCircleButton(
                    icon: Icons.mic_rounded,
                    color: const Color(0xFF64748B),
                    onTap: () => _startRecording(context),
                  ),
                ]
                else if (rs == RecordingState.playing) ...[
                  // Stop playback
                  BigCircleButton(
                    color: const Color(0xFF134CC7),
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


