import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../models/data_class_element.dart';
import 'type_builder.dart';

class DurationTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataClassElement element}) {
    // TODO: implement declaration
    throw UnimplementedError();
  }

  @override
  String fromJson({required DataClassElement element, DartType? type}) {
    final buffer = StringBuffer();
    final variable = element.name;
    final name = type!.element!.name;
    final nullSafety = element.nullSafety;

    if (type.isNullableType) {
      buffer.write(
          '$variable != null ? $name(microseconds: $variable as int) : null, ');
    } else if (nullSafety) {
      buffer.write('Duration(microseconds: $variable as int), ');
    } else {
      buffer.write(
          '$variable != null ? $name(microseconds: $variable as int) : null, ');
    }

    return buffer.toString();
  }

  @override
  String toJson({required DataClassElement element, DartType? type}) {
    final buffer = StringBuffer();
    final name = element.name;
    final nullSafety = element.nullSafety;

    if (type!.isNullableType) {
      buffer.write('$name?.inMicroseconds, ');
    } else if (nullSafety) {
      buffer.write('$name.inMicroseconds, ');
    } else {
      buffer.write('$name?.inMicroseconds, ');
    }

    return buffer.toString();
  }
}
