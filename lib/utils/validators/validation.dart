class AppValidator {

  static String? validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the full name';
    }
    return null;
  }

  static String? validateImage(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please select an image';
    }
    return null;
  }

  static String? validateDateOfBirth(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the date of birth';
    }
    return null;
  }

  static String? validateIdentification(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the identification number';
    }
    return null;
  }

  static String? validateImageUrl(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter the image URL';
    }
    return null;
  }

  // Method to validate the first name
  static String? validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your first name';
    }
    // Validate if the value contains only characters (letters)
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'First name must contain only letters';
    }
    return null; // Return null if validation succeeds
  }

// Method to validate the last name
  static String? validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your last name';
    }
    // Validate if the value contains only characters (letters)
    if (!RegExp(r'^[a-zA-Z]+$').hasMatch(value)) {
      return 'Last name must contain only letters';
    }
    return null; // Return null if validation succeeds
  }
  // Method to validate the username
  static String? validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a username';
    }
    // Validate username format (e.g., alphanumeric characters, length)
    // Example validation: Username must be at least 4 characters long
    if (value.length < 4) {
      return 'Username must be at least 4 characters long';
    }
    if (value.length > 10) {
      return 'Username must less than 10 characters long';
    }
    // Additional validation logic can be added here
    return null; // Return null if validation succeeds
  }
  static String? validateEmail(String? value) {
    // Check if email value is null or empty
    if (value == null || value.isEmpty) {
      return 'Email is required.';
    }

    // Regular expression for email validation
    final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    // Check if email value matches the email regular expression
    if (!emailRegExp.hasMatch(value)) {
      return 'Invalid email address.';
    }

    return null;
  }

  static String? validatePassword(String? value) {
    // Check if password value is null or empty
    if (value == null || value.isEmpty) {
      return 'Password is required.';
    }

    // Check for minimum password length
    if (value.length < 6) {
      return 'Password must be at least 6 characters long.';
    }

    // Check for uppercase letters
    if (!value.contains(RegExp(r'[A-Z]'))) {
      return 'Password must contain at least one uppercase letter.';
    }

    // Check for numbers
    if (!value.contains(RegExp(r'[0-9]'))) {
      return 'Password must contain at least one number.';
    }

    // Check for special characters
    if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      return 'Password must contain at least one special character.';
    }

    return null;
  }

  static String? validatePhoneNumber(String? value) {
    // Check if phone number value is null or empty
    if (value == null || value.isEmpty) {
      return 'Phone number is required.';
    }

    // Regular expression for phone number validation (assuming a 10-digit Maroc phone number format)
    final phoneRegExp = RegExp(r'^\d{10}$');

    // Check if phone number value matches the phone number regular expression
    if (!phoneRegExp.hasMatch(value)) {
      return 'Invalid phone number format (10 digits required).';
    }

    return null;
  }

  // New method to validate empty text
  static String? validateEmptyText(String fieldName, String? value) {
    if (value == null || value.isEmpty) {
      return '$fieldName is required.';
    }
    return null;
  }

}