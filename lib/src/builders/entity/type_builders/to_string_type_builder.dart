import 'package:data_builder/src/builders/entity/models/entity_element.dart';

import 'type_builder.dart';

class ToStringTypeBuilder with TypeBuilder {
  @override
  String declaration(EntityElement element) {
    final buffer = StringBuffer();
    final name = element.name;
    final fields = element.fields;

    buffer.writeln('@override');
    buffer.writeln('String toString() {');
    buffer.writeln("return '''$name {");

    for (final field in fields) {
      final name = field.name;

      buffer.writeln('  $name: \$$name, ');
    }

    buffer.writeln("}''';");
    buffer.writeln('}');

    return buffer.toString();
  }
}
