import '../models/data_class_element.dart';
import 'type_builder.dart';

class EqualsTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataClassElement element}) {
    final buffer = StringBuffer();
    final name = element.name;
    final fields = element.fields;

    if (fields.isEmpty) return '';

    buffer.writeln('@override');
    buffer.writeln('bool operator ==(Object other) {');
    buffer.writeln('if(identical(this, other)) return true;');
    buffer.writeln();
    buffer.write('return other is $name');

    for (final field in fields) {
      final name = field.name;

      buffer.write(' && other.$name == $name');
    }

    buffer.writeln(';');
    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  String fromJson({required DataClassElement element}) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  String toJson({required DataClassElement element}) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
