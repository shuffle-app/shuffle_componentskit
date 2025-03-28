String? websiteValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (RegExp(r'^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$').hasMatch(value)) {
    return null;
  } else if (value.split('.').length < 2 || (value.split('.').lastOrNull ?? '').length < 2) {
    return 'Please enter a valid website';
  }
  return null;
}

String? bookingWebsiteValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (RegExp(r'^([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,}$').hasMatch(value)) {
    return null;
  } else if (value.split('.').length < 2 || (value.split('.').lastOrNull ?? '').length < 2) {
    return 'Please enter a valid website';
  }
  return null;
}

String? emailValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (!value.contains('@')) {
    return 'Please enter a valid email';
  } else if (!value.contains('.')) {
    return 'Please enter a valid email';
  } else if (value.split('.').length < 2 || (value.split('.').last.length < 2)) {
    return 'Please enter a valid email';
  }
  return null;
}

String? phoneNumberValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (value.length < 10) {
    return 'Please enter a valid phone number';
  }
  return null;
}

String? titleValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (value.length < 3) {
    return 'Please enter a valid title';
  }
  return null;
}

String? upsalesValidator(String? value) {
  if (value == null || value.trim().isEmpty) {
    return null;
  } else if (value.trim().length < 3) {
    return 'Please enter a valid title';
  } else if (RegExp(r'^[\s@#\$%\^&\*\(\)\[\]\{\};:,.<>?\\|`~!]+$').hasMatch(value)) {
    return 'Please enter a valid title';
  }
  return null;
}

String? descriptionValidator(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  } else if (value.length < 20) {
    return 'At least 20 characters';
  }
  return null;
}
