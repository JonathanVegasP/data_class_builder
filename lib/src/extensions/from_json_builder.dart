import 'package:analyzer/dart/element/element.dart';

import '../resources/builder_utilities.dart';

extension FromJsonBuilder on StringBuffer {
  void writeFromJson(
      String name, List<ParameterElement> fields, bool nullSafety) {
    writeln('factory _$name.fromJson(Map<String,dynamic> json) {');

    write('return _$name(');

    for (final field in fields) {
      final name = field.name;
      final type = field.type;
      final el = type.element;

      if (BuilderUtilities.hasFromJson(el)) {
        var declaration = '';
        if (nullSafety) {
          if (BuilderUtilities.isNullable(type)) {
            declaration =
                "json['$name'] != null ? ${el!.name}.fromJson(json['$name'] as Map<String,dynamic>) : null, ";
          } else {
            declaration =
                "${el!.name}.fromJson(json['$name'] as Map<String,dynamic>), ";
          }
        } else {
          declaration =
              "json['$name'] != null ? ${el!.name}.fromJson(json['$name'] as Map<String,dynamic>) : null, ";
        }

        if (field.isNamed) {
          write('$name: $declaration');
        } else {
          write(declaration);
        }
      } else {
        if (field.isNamed) {
          write("$name: json['$name'] as ${field.type.getDisplayString(withNullability: nullSafety)}, ");
        } else {
          write("json['$name'] as ${field.type.getDisplayString(withNullability: nullSafety)}, ");
        }
      }
    }

    writeln(');');

    writeln('}');
  }
}
