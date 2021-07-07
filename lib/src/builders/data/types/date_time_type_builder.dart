import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../models/data_element.dart';
import 'type_builder.dart';

class DateTimeTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    // TODO: implement declaration
    throw UnimplementedError();
  }

  @override
  String fromJson({required DataElement element}) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  String toJson({required DataElement element, DartType? type}) {
    final buffer = StringBuffer();
    final name = element.name;
    final nullSafety = element.nullSafety;

    if (type!.isNullableType) {
      buffer.write('$name?.toIso8601String(), ');
    } else if (nullSafety) {
      buffer.write('$name.toIso8601String(), ');
    } else {
      buffer.write('$name?.toIso8601String(), ');
    }

    return buffer.toString();
  }
}
