import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'visit_history_event.dart';
part 'visit_history_state.dart';

class VisitHistoryBloc extends Bloc<VisitHistoryEvent, VisitHistoryState> {
  VisitHistoryBloc() : super(VisitHistoryInitial()) {
    on<VisitHistoryEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
