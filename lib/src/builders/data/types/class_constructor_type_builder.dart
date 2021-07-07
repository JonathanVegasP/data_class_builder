import 'package:source_helper/source_helper.dart';

import '../../../extensions/dart_type_extensions.dart';
import '../models/data_element.dart';
import 'big_int_type_builder.dart';
import 'class_type_builder.dart';
import 'collection_type_builder.dart';
import 'date_time_type_builder.dart';
import 'duration_type_builder.dart';
import 'enum_type_builder.dart';
import 'parse_type_builder.dart';
import 'type_builder.dart';
import 'uri_type_builder.dart';

class ClassConstructorTypeBuilder implements TypeBuilder {
  @override
  String declaration({required DataElement element}) {
    final buffer = StringBuffer();
    final name = '_${element.name}';
    final fields = element.fields;
    final nullSafety = element.nullSafety;
    var isNamed = false;
    var isOptional = false;

    if (element.isConst) {
      buffer.write('const ');
    }

    buffer.write('$name(');

    for (final field in fields) {
      final name = field.name;

      if (!isNamed && field.isNamed) {
        isNamed = true;
        buffer.write('{');
      }

      if (!isOptional && field.isOptionalPositional) {
        isOptional = true;
        buffer.write('[');
      }

      if (nullSafety && field.isRequiredNamed) {
        buffer.write('required ');
      }

      buffer.write('this.$name, ');
    }

    if (isNamed) {
      buffer.write('}');
    }

    if (isOptional) {
      buffer.write(']');
    }

    buffer.writeln(') : super._();');

    return buffer.toString();
  }

  @override
  String fromJson({required DataElement element}) {
    final buffer = StringBuffer();
    final name = element.name;
    final fields = element.fields;
    final nullSafety = element.nullSafety;
    final isConst = element.isConst;
    final _class = ClassTypeBuilder();
    final _enum = EnumTypeBuilder();
    final parseType = ParseTypeBuilder();
    final durationType = DurationTypeBuilder();
    final collectionType = CollectionTypeBuilder();

    buffer.writeln('factory _$name.fromJson(Map<String, dynamic> json) {');
    buffer.write('return _$name(');

    for (final field in fields) {
      final name = field.name;
      final type = field.type;
      final typeDeclaration =
          type.getDisplayString(withNullability: nullSafety);
      final variable = "json['${field.jsonKey ?? name}']";
      final collectionTypes = type.collectionTypes;
      final element = DataElement(
        name: variable,
        nullSafety: nullSafety,
        isConst: isConst,
        fields: fields,
      );

      if (field.isNamed) {
        buffer.write('$name: ');
      }

      if (type.hasFromJson) {
        buffer.write(_class.fromJson(element: element, type: type));
      } else if (type.isEnum) {
        buffer.write(_enum.fromJson(element: element, type: type));
      } else if (type.isParseType) {
        buffer.write(parseType.declaration(element: element, type: type));
      } else if (type.isDuration) {
        buffer.write(durationType.fromJson(element: element, type: type));
      } else if (collectionTypes.isNotEmpty &&
          (collectionTypes.last.hasFromJson |
              collectionTypes.last.isParseTypeArgument)) {
        buffer.write(collectionType.fromJson(
          element: element,
          collectionTypes: collectionTypes,
          type: type,
        ));
      } else {
        buffer.write('$variable as $typeDeclaration, ');
      }
    }

    buffer.writeln(');');
    buffer.writeln('}');

    return buffer.toString();
  }

  @override
  String toJson({required DataElement element}) {
    final buffer = StringBuffer();
    final fields = element.fields;
    final nullSafety = element.nullSafety;
    final isConst = element.isConst;
    final _class = ClassTypeBuilder();
    final _enum = EnumTypeBuilder();
    final uriType = UriTypeBuilder();
    final bigIntType = BigIntTypeBuilder();
    final dateTimeType = DateTimeTypeBuilder();
    final durationType = DurationTypeBuilder();
    final collectionType = CollectionTypeBuilder();

    buffer.writeln('@override');
    buffer.writeln('Map<String, dynamic> toJson() {');
    buffer.write('return {');

    for (final field in fields) {
      final name = field.name;
      final type = field.type;
      final collectionTypes = type.collectionTypes;
      final element = DataElement(
        name: name,
        nullSafety: nullSafety,
        isConst: isConst,
        fields: fields,
      );

      buffer.write("'${field.jsonKey ?? name}': ");

      if (type.hasToJson) {
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
      } else if (collectionTypes.isNotEmpty &&
          (collectionTypes.last.hasToJson |
              collectionTypes.last.isParseTypeArgument)) {
        buffer.write(collectionType.toJson(
          element: element,
          type: type,
          collectionTypes: collectionTypes,
        ));
      } else {
        buffer.write('$name, ');
      }
    }

    buffer.writeln('};');
    buffer.writeln('}');
    return buffer.toString();
  }
}
