library data_class_builder.builder;

import 'package:build/build.dart';
import 'package:data_class_builder/src/data_class_builder.dart';
import 'package:source_gen/source_gen.dart';

Builder dataClassBuilder(BuilderOptions options) => PartBuilder(
      const [DataClassBuilder()],
      '.data.dart',
    );
