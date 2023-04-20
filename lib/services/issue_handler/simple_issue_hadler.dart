import 'package:flutter/material.dart';

generalErrorCatch(error) {
  switch (error) {
    case NoSuchMethodError:
      break;
    case TypeError:
      break;
    default:
      throw error;
  }
}
