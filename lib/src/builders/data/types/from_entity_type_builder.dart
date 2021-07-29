import 'package:analyzer/dart/element/element.dart';
import 'package:data_builder/src/builders/data/types/collection_type_builder.dart';

import '../../../extensions/dart_type_extensions.dart';
import '../models/data_element.dart';
import 'type_builder.dart';

class FromEntityTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    if (!element.entity!.isClass) {
      throw 'DataBuilder: The entity field must be a valid class';
    }

    final entity = element.entity!.element as ClassElement;

    if (entity.unnamedConstructor == null) {
      throw 'DataBuilder: The entity must have an unnamed constructor';
    }

    final entityType = entity.thisType.getDisplayString(withNullability: false);
    final fields = entity.unnamedConstructor!.parameters;
    final elementFields = element.fields;
    final buffer = StringBuffer();
    final collectionType = CollectionTypeBuilder();
    final name = element.name;

    buffer.writeln('factory _$name.fromEntity($entityType entity) {');

    buffer.writeln('return _$name(');

    for (final field in fields) {
      final name = field.name;

      for (final elementField in elementFields) {
        if (elementField.name != name) continue;

        if (elementField.isNamed) {
          buffer.write('$name: ');
        }

        final type = elementField.type;

        final collectionTypes = type.collectionTypes;

        if (collectionTypes.isNotEmpty && collectionTypes.last.hasFromEntity) {
          final newElement = DataElement(
            name: 'entity.$name',
            nullSafety: element.nullSafety,
            isConst: element.isConst,
            fields: element.fields,
          );

          buffer.write(collectionType.fromJson(
            element: newElement,
            type: type,
            collectionTypes: collectionTypes,
            fromEntity: true,
          ));
        } else if (type.hasFromEntity) {
          buffer.write(
              '${type.getDisplayString(withNullability: element.nullSafety)}.fromEntity(entity.$name),');
        } else {
          buffer.write('entity.$name,');
        }
      }
    }

    buffer.writeln(');');

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
