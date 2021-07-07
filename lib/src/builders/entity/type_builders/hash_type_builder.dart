import 'package:data_builder/src/builders/entity/models/entity_element.dart';

import 'type_builder.dart';

class HashTypeBuilder with TypeBuilder {
  @override
  String declaration(EntityElement element) {
    final buffer = StringBuffer();
    final fields = element.fields;

    buffer.writeln('@override');
    buffer.writeln('int get hashCode {');
    buffer.writeln(r'return ($JenkinsHashBuilder()');

    for (final field in fields) {
      final name = field.name;

      buffer.write('..hash = $name.hashCode');
    }

    buffer.writeln(').hash;');
    buffer.writeln('}');

    return buffer.toString();
  }
}
