// Bloc Event
abstract class NavEvent {}

class NavChanged extends NavEvent {
  final int index;
  NavChanged(this.index);
}