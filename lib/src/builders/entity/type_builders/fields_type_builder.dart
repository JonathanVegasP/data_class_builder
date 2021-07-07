import 'package:data_builder/src/builders/entity/models/entity_element.dart';

import 'type_builder.dart';

class FieldsTypeBuilder with TypeBuilder {
  @override
  String declaration(EntityElement element) {
    final buffer = StringBuffer();
    final isNullSafety = element.nullSafety;
    final fields = element.fields;

    for (final field in fields) {
      final name = field.name;
      final declaration =
          field.type.getDisplayString(withNullability: isNullSafety);

      buffer.writeln('$declaration get $name;');
    }

    return buffer.toString();
  }
}
