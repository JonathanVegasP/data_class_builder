import 'package:analyzer/dart/element/element.dart';
import '../models/data_element.dart';
import 'type_builder.dart';
import '../../../extensions/dart_type_extensions.dart';

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

        buffer.write('$name,');

        break;
      }

      if (shouldDeclareNull) buffer.write('null,');
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
