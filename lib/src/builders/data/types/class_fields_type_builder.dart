import '../models/data_element.dart';
import 'type_builder.dart';

class ClassFieldsTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    final buffer = StringBuffer();
    final fields = element.fields;
    final nullSafety = element.nullSafety;

    for (final field in fields) {
      final name = field.name;
      final type = field.type.getDisplayString(withNullability: nullSafety);

      buffer.writeln('@override');
      buffer.writeln('final $type $name;');
    }

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
