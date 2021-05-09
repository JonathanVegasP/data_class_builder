import 'package:analyzer/dart/element/element.dart';

import '../resources/builder_utilities.dart';

extension ToJsonBuilder on StringBuffer {
  void writeToJson(List<ParameterElement> fields, bool nullSafety) {
    writeln('Map<String,dynamic> toJson() {');

    write('return {');

    for (final field in fields) {
      final name = field.name;
      final type = field.type;
      final el = type.element;
      final types = BuilderUtilities.getTypeArgumentsFromList(type);

      if (BuilderUtilities.isClass(el)) {
        if (nullSafety) {
          if (BuilderUtilities.isNullable(type)) {
            write("'$name': $name?.toJson(), ");
          } else {
            write("'$name': $name.toJson(), ");
          }
        } else {
          write("'$name': $name?.toJson(), ");
        }
      } else if (types.isNotEmpty) {
        write("'$name': $name");
        if (nullSafety) {
          final isNull = BuilderUtilities.isNullable(type);
          if (isNull) {
            write('?.map((e) => ');
          } else {
            write('.map((e) => ');
          }

          for (final type in types) {
            if (BuilderUtilities.isClass(type.element)) {
              if (BuilderUtilities.isNullable(type)) {
                write('e?.toJson()');
              } else {
                write('e.toJson()');
              }
            } else {
              if (BuilderUtilities.isNullable(type)) {
                write('e?.map((e) => ');
              } else {
                write('e.map((e) => ');
              }
            }
          }

          for (final _ in types) {
            write(').toList()');
          }

          write(', ');
        } else {
          write('?.map((e) => ');

          for (final type in types) {
            if (BuilderUtilities.isClass(type.element)) {
              write('e?.toJson()');
            } else {
              write('e?.map((e) => ');
            }
          }

          for (final _ in types) {
            write(')?.toList()');
          }

          write(', ');
        }
      } else {
        write("'$name': $name, ");
      }
    }

    writeln('};');

    writeln('}');
  }
}
