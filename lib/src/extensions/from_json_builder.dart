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
      final types = BuilderUtilities.getTypeArgumentsFromList(type);

      if (BuilderUtilities.isClass(el)) {
        if (field.isNamed) write('$name: ');

        if (nullSafety) {
          if (BuilderUtilities.isNullable(type)) {
            write(
                "json['$name'] != null ? ${el!.name}.fromJson(json['$name'] as Map<String,dynamic>) : null, ");
          } else {
            write(
                "${el!.name}.fromJson(json['$name'] as Map<String,dynamic>), ");
          }
        } else {
          write(
              "json['$name'] != null ? ${el!.name}.fromJson(json['$name'] as Map<String,dynamic>) : null, ");
        }
      } else if (types.isNotEmpty) {
        if (field.isNamed) write('$name: ');

        if (nullSafety) {
          final isNull = BuilderUtilities.isNullable(type);

          if (isNull) {
            write("(json['$name'] as List<dynamic>?)?.map((e) => ");
          } else {
            write("(json['$name'] as List<dynamic>).map((e) => ");
          }

          for (final type in types) {
            final el = type.element;
            if (BuilderUtilities.isClass(el)) {
              if (BuilderUtilities.isNullable(type)) {
                write(
                    'e != null ? ${el!.name}.fromJson(e as Map<String,dynamic>) : null');
              } else {
                write('${el!.name}.fromJson(e as Map<String,dynamic>)');
              }
            } else {
              if (BuilderUtilities.isNullable(type)) {
                write('(e as List<dynamic>?)?.map((e) => ');
              } else {
                write('(e as List<dynamic>).map((e) => ');
              }
            }
          }

          for (final _ in types) {
            write(').toList()');
          }

          if (isNull) {
            write(', ');
          } else {
            write(', ');
          }
        } else {
          write("(json['$name'] as List<dynamic>)?.map((e) => ");

          for (final type in types) {
            final el = type.element;

            if (BuilderUtilities.isClass(el)) {
              write(
                  'e != null ? ${el!.name}.fromJson(e as Map<String,dynamic>) : null');
            } else {
              write('(e as List<dynamic>)?.map((e) => ');
            }
          }

          for (final _ in types) {
            write(')?.toList()');
          }

          write(', ');
        }
      } else {
        if (field.isNamed) {
          write(
              "$name: json['$name'] as ${type.getDisplayString(withNullability: nullSafety)}, ");
        } else {
          write(
              "json['$name'] as ${type.getDisplayString(withNullability: nullSafety)}, ");
        }
      }
    }

    writeln(');');

    writeln('}');
  }
}
