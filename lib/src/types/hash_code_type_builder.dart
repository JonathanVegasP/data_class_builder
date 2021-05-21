import '../models/data_class_element.dart';
import 'type_builder.dart';

class HashCodeTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataClassElement element}) {
    final buffer = StringBuffer();
    final fields = element.fields;

    if (fields.isEmpty) return '';

    buffer.writeln('@override');
    buffer.writeln('int get hashCode {');
    buffer.writeln('return (\$JenkinsHashBuilder()');

    for (final field in fields) {
      final name = field.name;

      buffer.write('..hash = $name.hashCode');
    }

    buffer.writeln(').hash;');
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
