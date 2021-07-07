import '../models/entity_element.dart';
import 'type_builder.dart';

class EqualsTypeBuilder with TypeBuilder {
  @override
  String declaration(EntityElement element) {
    final name = element.name;
    final fields = element.fields;
    final buffer = StringBuffer();

    buffer.writeln('@override');
    buffer.writeln('bool operator ==(Object other) {');
    buffer.writeln('if (identical(this,other)) return true;');
    buffer.writeln();
    buffer.write('return other is $name');
    for (final field in fields) {
      final name = field.name;
      buffer.write('&& other.$name == $name');
    }
    buffer.writeln(';');
    buffer.writeln('}');

    return buffer.toString();
  }
}
