import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../models/data_class_element.dart';
import 'type_builder.dart';

class BigIntTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataClassElement element}) {
    // TODO: implement declaration
    throw UnimplementedError();
  }

  @override
  String fromJson({required DataClassElement element}) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  String toJson({required DataClassElement element, DartType? type}) {
    final buffer = StringBuffer();
    final name = element.name;
    final nullSafety = element.nullSafety;

    if (type!.isNullableType) {
      buffer.write('$name?.toInt(), ');
    } else if (nullSafety) {
      buffer.write('$name.toInt(), ');
    } else {
      buffer.write('$name?.toInt(), ');
    }

    return buffer.toString();
  }
}
