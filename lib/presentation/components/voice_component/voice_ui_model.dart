import 'package:just_audio/just_audio.dart' as ap;
import 'package:shuffle_components_kit/presentation/components/components.dart';

class VoiceUiModel {
  final String? path;
  final int? duration;
  final List<double>? amplitudes;
  final ap.AudioSource? source;
  final UiProfileModel? user;
  final UiPlaceModel? placeUiModel;
  final UiEventModel? eventUiModel;

  const VoiceUiModel({
    this.path,
    this.duration,
    this.amplitudes,
    this.source,
    this.user,
    this.eventUiModel,
    this.placeUiModel,
  });

  @override
  String toString() {
    return 'VoiceUiModel{path: $path, duration: $duration, amplitudes: $amplitudes, source: $source}';
  }
}
