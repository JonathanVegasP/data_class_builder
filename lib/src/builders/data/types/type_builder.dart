import '../models/data_element.dart';

mixin TypeBuilder {
  String toJson({required DataElement element});

  String fromJson({required DataElement element});

  String declaration({required DataElement element});
}
