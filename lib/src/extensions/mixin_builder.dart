import 'package:analyzer/dart/element/element.dart';

import '../extensions/copy_with_builder.dart';
import '../extensions/equals_builder.dart';
import '../extensions/hash_code_builder.dart';
import '../extensions/methods_builder.dart';
import '../extensions/to_json_builder.dart';
import '../extensions/to_string_builder.dart';
import '../models/data_class_element.dart';

extension MixinBuilder on StringBuffer {
  Future<void> writeMixin(DataClassElement element) async {
    final name = element.name;
    final fields = element.fields;
    final nullSafety = element.nullSafety;
    final methods = element.methods;

    writeln('mixin _\$$name {');

    _writeFieldsMethods(name, fields, nullSafety);

    writeln();

    writeToJson(fields, nullSafety);

    writeln();

    await writeMethods(methods);

    writeToString(name, fields);

    writeln('}');
  }

  void _writeFieldsMethods(
      String name, List<ParameterElement> fields, bool nullSafety) {
    if (fields.isEmpty) return;

    for (final field in fields) {
      writeln(
          '${field.type.getDisplayString(withNullability: nullSafety)} get ${field.name};');
    }

    writeln();

    writeHashCode(fields);

    writeln();

    writeEquals(name, fields);

    writeln();

    writeCopyWith(name, fields, nullSafety);
  }
}
