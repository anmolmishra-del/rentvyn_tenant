import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rentvyn_tenant/features/roommate/cubit/service.dart';
import 'package:rentvyn_tenant/features/roommate/state/state.dart';


class RoommateCubit extends Cubit<RoommateState> {
  RoommateCubit() : super(RoommateInitial());

Future<void> loadRoommates(int roomId) async {
  try {
    print("Loading roommates for roomId: $roomId");

    emit(RoommateLoading());

    final roommates = await RoommateService.getRoommates(roomId);

    print("Loaded ${roommates.length} roommates");

    emit(RoommateLoaded(roommates));
  } catch (e) {
    print("Roommate Error => $e");
    emit(RoommateError(e.toString()));
  }
}
}