import 'package:analyzer/dart/element/element.dart';

import '../extensions/constructor_builder.dart';
import '../extensions/from_json_builder.dart';
import '../models/data_class_element.dart';

extension ClassBuilder on StringBuffer {
  void writeClass(DataClassElement element) {
    final name = element.name;
    final fields = element.fields;
    final isConst = element.isConst;
    final nullSafety = element.nullSafety;

    writeln('class _$name with _\$$name implements $name {');

    _writeFields(fields, nullSafety);

    writeln();

    writeConstructor(
      name,
      isConst,
      fields,
      nullSafety,
    );

    writeln();

    writeFromJson(name, fields, nullSafety);

    writeln('}');
  }

  void _writeFields(List<ParameterElement> fields, bool nullSafety) {
    for (final field in fields) {
      writeln('@override');
      writeln(
          'final ${field.type.getDisplayString(withNullability: nullSafety)} ${field.name};');
    }
  }
}
