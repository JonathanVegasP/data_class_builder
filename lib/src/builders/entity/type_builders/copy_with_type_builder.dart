import '../models/entity_element.dart';
import 'type_builder.dart';
import 'package:source_helper/source_helper.dart';

class CopyWithTypeBuilder with TypeBuilder {
  @override
  String declaration(EntityElement element) {
    final buffer = StringBuffer();
    final name = element.name;
    final fields = element.parameterFields;
    final nullSafety = element.nullSafety;

    buffer.write('$name copyWith({');

    for (final field in fields) {
      final name = field.name;
      final type = field.type;
      late final String typeDeclaration;

      if (type.isNullableType) {
        typeDeclaration = type.toString();
      } else if (nullSafety) {
        typeDeclaration = '$type?';
      } else {
        typeDeclaration = type.getDisplayString(withNullability: nullSafety);
      }

      buffer.write('$typeDeclaration $name, ');
    }

    buffer.writeln('}) {');
    buffer.write('return $name(');

    for (final field in fields) {
      final name = field.name;

      if (field.isNamed) {
        buffer.write('$name: ');
      }

      buffer.write('$name ?? this.$name, ');
    }

    buffer.writeln(');');
    buffer.writeln('}');

    return buffer.toString();
  }
}
