import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'live_streaming_event.dart';
part 'live_streaming_state.dart';

class LiveStreamingBloc extends Bloc<LiveStreamingEvent, LiveStreamingState> {
  LiveStreamingBloc() : super(LiveStreamingInitial()) {
    on<LiveStreamingEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
