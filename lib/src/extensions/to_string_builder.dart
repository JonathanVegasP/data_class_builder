import 'package:analyzer/dart/element/element.dart';

extension ToStringBuilder on StringBuffer {
  void writeToString(String name, List<ParameterElement> fields) {
    writeln('@override');
    writeln('String toString() {');

    writeln("return '''$name {");

    for (final field in fields) {
      final name = field.name;
      writeln('  $name: \$$name, ');
    }

    writeln("}''';");

    writeln('}');
  }
}
