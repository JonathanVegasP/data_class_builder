import '../models/data_class_element.dart';

mixin TypeBuilder {
  String toJson({required DataClassElement element});

  String fromJson({required DataClassElement element});

  String declaration({required DataClassElement element});
}
