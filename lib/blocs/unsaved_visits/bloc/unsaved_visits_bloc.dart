import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'unsaved_visits_event.dart';
part 'unsaved_visits_state.dart';

class UnsavedVisitsBloc extends Bloc<UnsavedVisitsEvent, UnsavedVisitsState> {
  UnsavedVisitsBloc() : super(UnsavedVisitsInitial()) {
    on<UnsavedVisitsEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
