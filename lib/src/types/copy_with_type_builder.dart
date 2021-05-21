import 'package:source_helper/source_helper.dart';

import '../models/data_class_element.dart';
import 'type_builder.dart';

class CopyWithTypeBuilder implements TypeBuilder {
  @override
  String declaration(
      {required DataClassElement element, bool isClass = false}) {
    final buffer = StringBuffer();
    final name = isClass ? '_${element.name}' : element.name;
    final fields = element.fields;
    final nullSafety = element.nullSafety;

    if (fields.isEmpty) return '';

    if (isClass) {
      buffer.writeln('@override');
    }

    buffer.write('$name copyWith({');

    for (final field in fields) {
      final name = isClass ? '${field.name} = data' : field.name;
      final type = field.type;
      String typeDeclaration;

      if (isClass) {
        typeDeclaration = 'dynamic';
      } else if (type.isNullableType) {
        typeDeclaration = type.toString();
      } else if (nullSafety) {
        typeDeclaration = '$type?';
      } else {
        typeDeclaration = type.getDisplayString(withNullability: nullSafety);
      }

      buffer.write('$typeDeclaration $name, ');
    }

    if (isClass) {
      buffer.writeln('}) {');
      buffer.write('return $name(');

      for (final field in fields) {
        final name = field.name;

        if (field.isNamed) {
          buffer.write('$name: ');
        }

        buffer.write('$name == data ? this.$name : $name, ');
      }

      buffer.writeln(');');
      buffer.writeln('}');
    } else {
      buffer.writeln('});');
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
