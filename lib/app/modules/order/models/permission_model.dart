import 'package:equatable/equatable.dart';

class Permission extends Equatable {
  bool? read;
  bool? write;
  bool? delete;
  dynamic action;

  Permission(
      {this.action,
      this.read = false,
      this.write = false,
      this.delete = false});

  @override
  List<Object?> get props => [read, write, delete];
}
