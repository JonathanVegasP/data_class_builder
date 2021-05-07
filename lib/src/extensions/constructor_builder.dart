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

    final nonNullableRequired = [];
    final nonNullableOptionals = [];

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
            nonNullableRequired.add('required $type ${field.name}');
            continue;
          } else if (field.isRequiredNamed) {
            prefix = 'required ';
          }
        }

        write('${prefix}this.${field.name}, ');
      } else {
        final type = field.type;

        if (nullSafety && !BuilderUtilities.isNullable(type)) {
          nonNullableOptionals.add('$type? ${field.name}');
          continue;
        }

        if (!hasOptional) {
          hasOptional = true;

          write('[');
        }

        write('this.${field.name}, ');
      }
    }

    if (nonNullableRequired.isNotEmpty) {
      throw DataClassException
          .cannotDeclareNonNullableNamedParameterWithoutRequired(
        '{${nonNullableRequired.reduce((value, element) => '$value, $element')}} at $name',
      );
    }

    if (nonNullableOptionals.isNotEmpty) {
      throw DataClassException.cannotDeclareOptionalParameterNonNullable(
        '[${nonNullableOptionals.reduce((value, element) => '$value, $element')}] at $name',
      );
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
