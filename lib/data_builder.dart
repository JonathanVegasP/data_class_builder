library data_builder.builder;

import 'package:build/build.dart';
import 'package:source_gen/source_gen.dart';

import 'src/builders/data_class_builder.dart';

Builder dataClassBuilder(BuilderOptions options) =>
    PartBuilder(const [DataClassBuilder()], '.data.dart');
