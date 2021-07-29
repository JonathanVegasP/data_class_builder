import 'package:analyzer/dart/element/type.dart';
import 'package:data_builder/src/builders/data/types/to_entity_type_builder.dart';
import 'package:source_helper/source_helper.dart';

import '../models/data_element.dart';
import 'class_constructor_type_builder.dart';
import 'class_fields_type_builder.dart';
import 'copy_with_type_builder.dart';
import 'from_entity_type_builder.dart';
import 'type_builder.dart';

class ClassTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    final buffer = StringBuffer();
    final name = element.name;
    final fields = ClassFieldsTypeBuilder();
    final constructor = ClassConstructorTypeBuilder();
    final copyWith = CopyWithTypeBuilder();
    final entity = FromEntityTypeBuilder();
    final toEntity = ToEntityTypeBuilder();

    buffer.writeln('class _$name extends $name {');
    buffer.writeln(fields.declaration(element: element));
    buffer.writeln(constructor.declaration(element: element));
    buffer.writeln(constructor.fromJson(element: element));
    buffer.writeln(copyWith.declaration(element: element, isClass: true));

    if (element.entity != null) {
      buffer.writeln(entity.declaration(element: element));
      buffer.writeln(toEntity.declaration(element: element));
    }

    buffer.write(constructor.toJson(element: element));
    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  String fromJson({required DataElement element, DartType? type}) {
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
  String toJson({required DataElement element, DartType? type}) {
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
