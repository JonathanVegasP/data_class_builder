import '../models/data_element.dart';
import 'type_builder.dart';

class HashCodeTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    final buffer = StringBuffer();
    final fields = element.fields;

    if (fields.isEmpty) return '';

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

  @override
  String fromJson({required DataElement element}) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  String toJson({required DataElement element}) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
