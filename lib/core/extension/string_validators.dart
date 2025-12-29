extension StringValidator on String? {
  String? validateEmail() {
    if (this == null || this!.isEmpty) {
      return "Please enter your email";
    }

    final emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

    if (!emailRegex.hasMatch(this!)) {
      return "Please enter a valid email";
    }

    return null;
  }
}

extension StringExtension on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
  
  bool get isNotNullOrEmpty => !isNullOrEmpty;
  
  bool get isNullOrBlank => this == null || this!.trim().isEmpty;
  
  bool get isNotNullOrBlank => !isNullOrBlank;
}
