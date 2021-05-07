import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:data_class/data_class.dart';
import 'package:source_gen/source_gen.dart';

import 'resources/builder_utilities.dart';

class DataClassBuilder extends GeneratorForAnnotation<DataClass> {
  const DataClassBuilder();

  @override
  Future<String> generateForAnnotatedElement(
      Element element, ConstantReader annotation, BuildStep buildStep) {
    return BuilderUtilities.checkElement(element)
        .then((element) => element.toDataClass());
  }
}
