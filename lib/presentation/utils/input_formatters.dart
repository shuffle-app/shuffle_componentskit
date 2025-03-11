import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

final dateInputFormatter = MaskTextInputFormatter(
  mask: '##.##.####',
  filter: {
    '#': RegExp(r'[0-9]'),
  },
);

final americanInputFormatter = MaskTextInputFormatter(
  mask: '# ### ### ## ###',
  filter: {
    '#': RegExp(r'[0-9]'),
  },
);

final phuketInternationalFormatter = MaskTextInputFormatter(
  mask: '66 ## ### ####',
  filter: {
    '#': RegExp(r'[0-9]'),
  },
);
