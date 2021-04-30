import 'dart:typed_data';

import 'package:audio_service/audio_service.dart';
import 'package:just_audio/just_audio.dart';

/// this functions must be top-level
void audioPlayerTaskEntryPoint() async {
  AudioServiceBackground.run(() => _AudioPlayerTask());
}

class _AudioPlayerTask extends BackgroundAudioTask {
  final AudioPlayer _audioPlayer = AudioPlayer();
  AudioProcessingState? _skipState;

  @override
  Future<void> onStart(Map<String, dynamic>? params) async {
    return super.onStart(params);
  }

  AudioProcessingState _getProcessingState() {
    if (_skipState != null) return _skipState!;
    switch (_audioPlayer.processingState) {
      case ProcessingState.idle:
        return AudioProcessingState.stopped;
      case ProcessingState.loading:
        return AudioProcessingState.connecting;
      case ProcessingState.buffering:
        return AudioProcessingState.buffering;
      case ProcessingState.ready:
        return AudioProcessingState.ready;
      case ProcessingState.completed:
        return AudioProcessingState.completed;
      default:
        throw Exception("Invalid state: ${_audioPlayer.processingState}");
    }
  }

  @override
  Future onCustomAction(String name, arguments) async {
    switch (name) {
      case 'setURL':
        final String url = arguments['url'];
        await _audioPlayer.setUrl(url);
        break;

      case 'setByteData':
        final Uint8List assetByteData = arguments!['assetByteData'];
        await _audioPlayer.setAudioSource(_AudioByteDataSource(assetByteData));
        break;

      case 'ready':
        final String title = arguments['title'];
        final String subtitle = arguments['subtitle'];

        final MediaItem _mediaItem = MediaItem(
          id: title,
          album: subtitle,
          title: title,
          duration: _audioPlayer.duration,
        );

        await AudioServiceBackground.setMediaItem(_mediaItem);

        _audioPlayer.playerStateStream.listen((playerState) {
          AudioServiceBackground.setState(
            playing: playerState.playing,
            processingState: _getProcessingState(),
            position: _audioPlayer.position,
            bufferedPosition: _audioPlayer.bufferedPosition,
            speed: _audioPlayer.speed,
            controls: [
              MediaControl.rewind,
              playerState.playing ? MediaControl.pause : MediaControl.play,
              MediaControl.fastForward,
            ],
          );
        });

        _audioPlayer.processingStateStream.listen((state) {
          switch (state) {
            case ProcessingState.completed:
              // In this example, the service stops when reaching the end.
              //   onStop();
              onPause();
              onSeekTo(Duration.zero);
              break;
            case ProcessingState.ready:
              _skipState = null;
              break;
            default:
              break;
          }
        });
    }

    return super.onCustomAction(name, arguments);
  }

  @override
  Future<void> onSetRepeatMode(AudioServiceRepeatMode repeatMode) {
    LoopMode _mode =
        repeatMode == AudioServiceRepeatMode.one ? LoopMode.one : LoopMode.off;
    _audioPlayer.setLoopMode(_mode);
    return super.onSetRepeatMode(repeatMode);
  }

  @override
  Future<void> onPlay() async {
     _audioPlayer.play();
  }

  @override
  Future<void> onPause() async {
    _audioPlayer.pause();
  }

  @override
  Future<void> onSeekTo(Duration position) async {
    await _audioPlayer.seek(position);
  }

  @override
  Future<void> onRewind()async {
    await _audioPlayer.seek(_audioPlayer.position-Duration(seconds: 5));

    return super.onRewind();
  }

  @override
  Future<void> onFastForward() async{
    await _audioPlayer.seek(_audioPlayer.position+Duration(seconds: 5));

    return super.onFastForward();
  }
}

class _AudioByteDataSource extends StreamAudioSource {
  _AudioByteDataSource(this.audioByteData) : super("tag");

  final Uint8List audioByteData;

  @override
  Future<StreamAudioResponse> request([int? start, int? end]) async {
    start = start ?? 0;
    end = end ?? audioByteData.length;
    return StreamAudioResponse(
      sourceLength: audioByteData.length,
      contentLength: audioByteData.length,
      offset: 0,
      contentType: 'audio/mp3',
      stream: Stream.value(
          List<int>.from(audioByteData.skip(start).take(end - start))),
    );
  }
}
