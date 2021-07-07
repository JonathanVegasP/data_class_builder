import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../models/data_element.dart';
import 'type_builder.dart';

enum Test { test }

class EnumTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    // TODO: implement declaration
    throw UnimplementedError();
  }

  @override
  String fromJson({required DataElement element, DartType? type}) {
    final buffer = StringBuffer();
    final variable = element.name;
    final name = type!.element!.name;
    final nullSafety = element.nullSafety;

    if (type.isNullableType) {
      buffer.write(
          '$variable != null ? $name.values.firstWhere((value) => value.index == $variable as int) : null, ');
    } else if (nullSafety) {
      buffer.write(
          '$name.values.firstWhere((value) => value.index == $variable as int), ');
    } else {
      buffer.write(
          '$variable != null ? $name.values.firstWhere((value) => value.index == $variable as int) : null, ');
    }

    return buffer.toString();
  }

  @override
  String toJson({required DataElement element, DartType? type}) {
    final buffer = StringBuffer();
    final name = element.name;
    final nullSafety = element.nullSafety;

    if (type!.isNullableType) {
      buffer.write('$name?.index, ');
    } else if (nullSafety) {
      buffer.write('$name.index, ');
    } else {
      buffer.write('$name?.index, ');
    }

    return buffer.toString();
  }
}
