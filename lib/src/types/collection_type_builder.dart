import 'package:analyzer/dart/element/type.dart';
import 'package:source_helper/source_helper.dart';

import '../extensions/dart_type_extensions.dart';
import '../models/data_class_element.dart';
import 'big_int_type_builder.dart';
import 'class_type_builder.dart';
import 'date_time_type_builder.dart';
import 'duration_type_builder.dart';
import 'enum_type_builder.dart';
import 'parse_type_builder.dart';
import 'type_builder.dart';
import 'uri_type_builder.dart';

class CollectionTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataClassElement element}) {
    // TODO: implement declaration
    throw UnimplementedError();
  }

  @override
  String fromJson({
    required DataClassElement element,
    DartType? type,
    List<DartType>? collectionTypes,
  }) {
    final buffer = StringBuffer();
    final variable = element.name;
    final nullSafety = element.nullSafety;
    final fields = element.fields;
    final isConst = element.isConst;
    final args = 'e';
    final _class = ClassTypeBuilder();
    final _enum = EnumTypeBuilder();
    final parseType = ParseTypeBuilder();
    final durationType = DurationTypeBuilder();

    if (type!.hasFromJson) {
      buffer.write(_class.fromJson(element: element, type: type));
    } else if (type.isEnum) {
      buffer.write(_enum.fromJson(element: element, type: type));
    } else if (type.isParseType) {
      buffer.write(parseType.declaration(element: element, type: type));
    } else if (type.isDuration) {
      buffer.write(durationType.fromJson(element: element, type: type));
    } else if (type.isDartCoreList) {
      if (type.isNullableType) {
        buffer.write('($variable as List<dynamic>?)?.map(($args) => ');
      } else if (nullSafety) {
        buffer.write('($variable as List<dynamic>).map(($args) => ');
      } else {
        buffer.write('($variable as List<dynamic>)?.map(($args) => ');
      }

      final newType = collectionTypes![0];
      final newCollectionTypes = collectionTypes.sublist(1);
      final newElement = DataClassElement(
        name: args,
        nullSafety: nullSafety,
        isConst: isConst,
        fields: fields,
      );

      buffer.write(fromJson(
        element: newElement,
        type: newType,
        collectionTypes: newCollectionTypes,
      ));
    } else if (type.isDartCoreMap) {
      if (type.isNullableType) {
        buffer.write(
            '($variable as Map<String, dynamic>?)?.map((k, $args) => MapEntry(k, ');
      } else if (nullSafety) {
        buffer.write(
            '($variable as Map<String, dynamic>).map((k, $args) => MapEntry(k, ');
      } else {
        buffer.write(
            '($variable as Map<String, dynamic>)?.map((k, $args) => MapEntry(k, ');
      }

      final newType = collectionTypes![1];

      if (!collectionTypes[0].isDartCoreString) {
        throw 'The map must be declared as: Map<String, ${newType.getDisplayString(withNullability: nullSafety)}>';
      }

      final newCollectionTypes = collectionTypes.sublist(2);
      final newElement = DataClassElement(
        name: args,
        nullSafety: nullSafety,
        isConst: isConst,
        fields: fields,
      );

      buffer.write(fromJson(
        element: newElement,
        type: newType,
        collectionTypes: newCollectionTypes,
      ));
    }

    if (type.isDartCoreList) {
      if (nullSafety) {
        buffer.write(').toList(), ');
      } else {
        buffer.write(')?.toList(), ');
      }
    } else if (type.isDartCoreMap) {
      buffer.write('),), ');
    }

    return buffer.toString();
  }

  @override
  String toJson({
    required DataClassElement element,
    DartType? type,
    List<DartType>? collectionTypes,
  }) {
    final buffer = StringBuffer();
    final name = element.name;
    final nullSafety = element.nullSafety;
    final fields = element.fields;
    final isConst = element.isConst;
    final args = 'e';
    final _class = ClassTypeBuilder();
    final _enum = EnumTypeBuilder();
    final uriType = UriTypeBuilder();
    final bigIntType = BigIntTypeBuilder();
    final dateTimeType = DateTimeTypeBuilder();
    final durationType = DurationTypeBuilder();

    if (type!.isClass) {
      buffer.write(_class.toJson(element: element, type: type));
    } else if (type.isEnum) {
      buffer.write(_enum.toJson(element: element, type: type));
    } else if (type.isUri) {
      buffer.write(uriType.toJson(element: element, type: type));
    } else if (type.isBigInt) {
      buffer.write(bigIntType.toJson(element: element, type: type));
    } else if (type.isDateTime) {
      buffer.write(dateTimeType.toJson(element: element, type: type));
    } else if (type.isDuration) {
      buffer.write(durationType.toJson(element: element, type: type));
    } else if (type.isDartCoreList) {
      if (type.isNullableType) {
        buffer.write('$name?.map(($args) => ');
      } else if (nullSafety) {
        buffer.write('$name.map(($args) => ');
      } else {
        buffer.write('$name?.map(($args) => ');
      }

      final newType = collectionTypes![0];
      final newCollectionTypes = collectionTypes.sublist(1);
      final newElement = DataClassElement(
        name: args,
        nullSafety: nullSafety,
        isConst: isConst,
        fields: fields,
      );

      buffer.write(toJson(
        element: newElement,
        type: newType,
        collectionTypes: newCollectionTypes,
      ));
    } else if (type.isDartCoreMap) {
      if (type.isNullableType) {
        buffer.write('$name?.map((k, $args) => MapEntry(k, ');
      } else if (nullSafety) {
        buffer.write('$name.map((k, $args) => MapEntry(k, ');
      } else {
        buffer.write('$name?.map((k, $args) => MapEntry(k, ');
      }

      if (!collectionTypes![0].isDartCoreString) {
        throw 'The key of a Map in the data class must be String';
      }

      final newType = collectionTypes[1];
      final newCollectionTypes = collectionTypes.sublist(2);
      final newElement = DataClassElement(
        name: args,
        nullSafety: nullSafety,
        isConst: isConst,
        fields: fields,
      );

      buffer.write(toJson(
        element: newElement,
        type: newType,
        collectionTypes: newCollectionTypes,
      ));
    }

    if (type.isDartCoreList) {
      if (nullSafety) {
        buffer.write(').toList(), ');
      } else {
        buffer.write(')?.toList(), ');
      }
    } else if (type.isDartCoreMap) {
      buffer.write('),), ');
    }

    return buffer.toString();
  }
}
