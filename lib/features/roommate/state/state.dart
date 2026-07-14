import 'package:rentvyn_tenant/features/roommate/model/model.dart';


abstract class RoommateState {}

class RoommateInitial extends RoommateState {}

class RoommateLoading extends RoommateState {}

class RoommateLoaded extends RoommateState {
  final List<RoommateModel> roommates;

  RoommateLoaded(this.roommates);
}

class RoommateError extends RoommateState {
  final String message;

  RoommateError(this.message);
}