import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'video_chat_event.dart';
part 'video_chat_state.dart';

class VideoChatBloc extends Bloc<VideoChatEvent, VideoChatState> {
  VideoChatBloc() : super(VideoChatInitial()) {
    on<VideoChatEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
