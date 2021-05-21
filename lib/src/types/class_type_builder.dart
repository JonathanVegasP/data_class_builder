import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../models/data_class_element.dart';
import 'class_constructor_type_builder.dart';
import 'class_fields_type_builder.dart';
import 'copy_with_type_builder.dart';
import 'type_builder.dart';

class ClassTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataClassElement element}) {
    final buffer = StringBuffer();
    final name = element.name;
    final fields = ClassFieldsTypeBuilder();
    final constructor = ClassConstructorTypeBuilder();
    final copyWith = CopyWithTypeBuilder();

    buffer.writeln('class _$name extends $name {');
    buffer.writeln(fields.declaration(element: element));
    buffer.writeln(constructor.declaration(element: element));
    buffer.writeln(constructor.fromJson(element: element));
    buffer.writeln(copyWith.declaration(element: element, isClass: true));
    buffer.write(constructor.toJson(element: element));
    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  String fromJson({required DataClassElement element, DartType? type}) {
    final buffer = StringBuffer();
    final nullSafety = element.nullSafety;
    final name = type!.element!.name;
    final variable = element.name;
    final typeDeclaration = 'Map<String, dynamic>';

    if (type.isNullableType) {
      buffer.write(
          '$variable != null ? $name.fromJson($variable as $typeDeclaration) : null, ');
    } else if (nullSafety) {
      buffer.write('$name.fromJson($variable as $typeDeclaration), ');
    } else {
      buffer.write(
          '$variable != null ? $name.fromJson($variable as $typeDeclaration) : null, ');
    }

    return buffer.toString();
  }

  @override
  String toJson({required DataClassElement element, DartType? type}) {
    final buffer = StringBuffer();
    final name = element.name;
    final nullSafety = element.nullSafety;

    if (type!.isNullableType) {
      buffer.write('$name?.toJson(), ');
    } else if (nullSafety) {
      buffer.write('$name.toJson(), ');
    } else {
      buffer.write('$name?.toJson(), ');
    }

    return buffer.toString();
  }
}
