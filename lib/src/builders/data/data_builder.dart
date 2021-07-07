import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:data_annotation/data_annotation.dart';
import 'package:source_gen/source_gen.dart';

import 'models/data_element.dart';

class DataBuilder extends GeneratorForAnnotation<DataClass> {
  const DataBuilder();

  @override
  String generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return DataElement.fromElement(element).toDataClassDeclaration();
  }
}
