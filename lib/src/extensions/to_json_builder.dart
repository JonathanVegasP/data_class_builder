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

      if (BuilderUtilities.hasToJson(el)) {
        if (nullSafety) {
          if (BuilderUtilities.isNullable(type)) {
            write("'$name': $name?.toJson(), ");
          } else {
            write("'$name': $name.toJson(), ");
          }
        } else {
          write("'$name': $name?.toJson(), ");
        }
      } else {
        write("'$name': $name, ");
      }
    }

    writeln('};');

    writeln('}');
  }
}
