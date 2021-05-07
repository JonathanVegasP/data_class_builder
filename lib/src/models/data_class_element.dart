import 'package:analyzer/dart/element/element.dart';

import '../extensions/class_builder.dart';
import '../extensions/mixin_builder.dart';

class DataClassElement {
  final String name;
  final bool nullSafety;
  final List<ParameterElement> fields;
  final List<MethodElement> methods;
  final bool isConst;

  DataClassElement({
    required this.isConst,
    required this.name,
    required this.nullSafety,
    required this.fields,
    required this.methods,
  });

  Future<String> toDataClass() async {
    final buffer = StringBuffer();

    await buffer.writeMixin(this);

    buffer.writeln();

    buffer.writeClass(this);

    return '$buffer';
  }
}
