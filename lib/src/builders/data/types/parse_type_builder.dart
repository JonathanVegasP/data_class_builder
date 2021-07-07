import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../models/data_element.dart';
import 'type_builder.dart';

class ParseTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element, DartType? type}) {
    final buffer = StringBuffer();
    final variable = element.name;
    final variableDeclaration = variable.contains('.') | variable.contains('[')
        ? "'\${$variable}'"
        : "'\$$variable'";
    final name = type!.element!.name;
    final nullSafety = element.nullSafety;

    if (type.isNullableType) {
      buffer.write(
          '$variable != null ? $name.parse($variableDeclaration) : null, ');
    } else if (nullSafety) {
      buffer.write('$name.parse($variableDeclaration), ');
    } else {
      buffer.write(
          '$variable != null ? $name.parse($variableDeclaration) : null, ');
    }

    return buffer.toString();
  }

  @override
  String fromJson({required DataElement element}) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  String toJson({required DataElement element}) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
