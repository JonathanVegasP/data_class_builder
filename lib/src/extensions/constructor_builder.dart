import 'package:analyzer/dart/element/element.dart';

import '../exceptions/data_class_exceptions.dart';
import '../resources/builder_utilities.dart';

extension ConstructorBuilder on StringBuffer {
  void writeConstructor(String name, bool isConst,
      List<ParameterElement> fields, bool nullSafety) {
    if (isConst) {
      write('const ');
    }

    write('_$name(');

    var hasNamed = false;

    var hasOptional = false;

    for (final field in fields) {
      if (field.isRequiredPositional) {
        write('this.${field.name}, ');
      } else if (field.isNamed) {
        if (!hasNamed) {
          hasNamed = true;

          write('{');
        }

        var prefix = '';

        if (nullSafety) {
          final type = field.type;

          if (!BuilderUtilities.isNullable(type) && field.isOptionalNamed) {
            throw DataClassException
                .cannotDeclareNonNullableNamedParameterWithoutRequired(
              '$type ${field.name}',
            );
          }

          prefix = 'required ';
        }

        write('${prefix}this.${field.name}, ');
      } else {
        final type = field.type;

        if (nullSafety && !BuilderUtilities.isNullable(type)) {
          throw DataClassException.cannotDeclareOptionalParameterNonNullable(
            '$type ${field.name}',
          );
        }

        if (!hasOptional) {
          hasOptional = true;

          write('[');
        }

        write('this.${field.name}, ');
      }
    }

    if (hasNamed) {
      writeln('});');
    } else if (hasOptional) {
      writeln(']);');
    } else {
      writeln(');');
    }
  }
}
