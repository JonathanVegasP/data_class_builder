import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../../../extensions/dart_type_extensions.dart';
import '../models/data_element.dart';
import 'collection_type_builder.dart';
import 'type_builder.dart';

class ToEntityTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    if (!element.entity!.isClass) {
      throw 'DataBuilder: The entity must be a valid class';
    }

    final entity = element.entity!.element as ClassElement;

    if (entity.unnamedConstructor == null) {
      throw 'DataBuilder: The entity must has an unnamed constructor';
    }

    final entityType = entity.thisType.getDisplayString(withNullability: false);
    final fields = entity.unnamedConstructor!.parameters;
    final elementFields = element.fields;
    final buffer = StringBuffer();
    final collectionTypeBuilder = CollectionTypeBuilder();

    buffer.writeln('@override');
    buffer.writeln('$entityType toEntity() {');

    buffer.writeln('return $entityType(');

    for (final field in fields) {
      final name = field.name;
      var shouldDeclareNull = false;
      for (final elementField in elementFields) {
        if (elementField.name != name) {
          if (field.isPositional) {
            shouldDeclareNull = true;
          } else {
            shouldDeclareNull = false;
          }
          continue;
        }

        shouldDeclareNull = false;

        if (field.isNamed) {
          buffer.write('$name: ');
        }

        final type = elementField.type;

        final collectionTypes = type.collectionTypes;

        final newElement = DataElement(
          name: name,
          nullSafety: element.nullSafety,
          isConst: element.isConst,
          fields: element.fields,
          entity: element.entity,
        );

        if (collectionTypes.isNotEmpty && collectionTypes.last.hasToEntity) {
          buffer.write(collectionTypeBuilder.toJson(
            element: newElement,
            collectionTypes: collectionTypes,
            type: type,
            toEntity: true,
          ));
        } else if (type.hasToEntity) {
          buffer.write('$name.toEntity(),');
        } else {
          buffer.write('$name,');
        }

        break;
      }

      if (shouldDeclareNull) buffer.write('null,');
    }

    buffer.writeln(');');

    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  String fromJson({required DataElement element, DartType? type}) {
    final buffer = StringBuffer();
    final nullSafety = element.nullSafety;
    final name = type!.element!.name;
    final variable = element.name;

    if (type.isNullableType) {
      buffer.write(
          '$variable != null ? $name.fromEntity($variable) : null, ');
    } else if (nullSafety) {
      buffer.write('$name.fromEntity($variable), ');
    } else {
      buffer.write(
          '$variable != null ? $name.fromEntity($variable) : null, ');
    }

    return buffer.toString();
  }

  @override
  String toJson({required DataElement element, DartType? type}) {
    final buffer = StringBuffer();
    final name = element.name;
    final nullSafety = element.nullSafety;

    if (type!.isNullableType) {
      buffer.write('$name?.toEntity(), ');
    } else if (nullSafety) {
      buffer.write('$name.toEntity(), ');
    } else {
      buffer.write('$name?.toEntity(), ');
    }

    return buffer.toString();
  }
}
