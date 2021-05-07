import 'package:analyzer/dart/element/element.dart';

import '../resources/builder_utilities.dart';

extension CopyWithBuilder on StringBuffer {
  void writeCopyWith(
      String name, List<ParameterElement> fields, bool nullSafety) {
    write('$name copyWith({');

    for (final field in fields) {
      String type;
      final name = field.name;
      final declaration = field.type;

      if (nullSafety) {
        type = BuilderUtilities.isNullable(declaration)
            ? '$declaration'
            : '$declaration?';
      } else {
        type = declaration.getDisplayString(withNullability: nullSafety);
      }

      write('$type $name, ');
    }

    writeln('}) {');

    write('return $name(');

    for (final field in fields) {
      final name = field.name;
      if (field.isNamed) {
        write('$name: $name ?? this.$name, ');
      } else {
        write('$name ?? this.$name, ');
      }
    }

    writeln(');');

    writeln('}');
  }
}
