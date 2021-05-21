import '../models/data_class_element.dart';
import 'type_builder.dart';

class ClassFieldsTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataClassElement element}) {
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
