import 'package:analyzer/dart/element/element.dart';

extension EqualsBuilder on StringBuffer {
  void writeEquals(String name, List<ParameterElement> fields) {
    writeln('@override');

    writeln('bool operator ==(Object other) {');

    writeln('if(identical(other, this)) return true;');

    writeln();

    write('return other is $name');

    for (final field in fields) {
      final name = field.name;

      write(' && other.$name == $name');
    }

    writeln(';');

    writeln('}');
  }
}
