import 'package:validators/validators.dart';

class Validator {
  // String validateName(String value) {
  //   String pattern = r'(^[a-zA-Z0-9]*$)';
  //   RegExp regExp = new RegExp(pattern);
  //   if (value.length == 0) {
  //     return "Name is Required";
  //   } else if (!regExp.hasMatch(value)) {
  //     return "Name must be a-z and A-Z";
  //   }
  //   return null;
  // }

  // String validateMobile(String value) {
  //   String pattern = r'(^[0-9]*$)';
  //   RegExp regExp = new RegExp(pattern);
  //   if (value.length == 0) {
  //     return "Mobile is Required";
  //   } else if (value.length != 10) {
  //     return "Mobile number must 10 digits";
  //   } else if (!regExp.hasMatch(value)) {
  //     return "Mobile Number must be digits";
  //   }
  //   return null;
  // }

  String validatePasswordLength(String value) {
    if (value.length == 0) {
      return "رمز عبور نمیتواند خالی باشد";
    } else if (value.length < 8) {
      return "رمز عبور باید بیشتر از ۸ کاراکتر باشد";
    }
    return null;
  }

  String validatePasswordoldchangeLength(String value) {
    if (value.length == 0) {
      return "رمز عبور نمیتواند خالی باشد";
    } else if (value.length < 8) {
      return "رمز عبور باید بیشتر از ۸ کاراکتر باشد";
    }
    return null;
  }

  String validatePasswordnewchangeLength(String value) {
    if (value.length == 0) {
      return "رمز عبور نمیتواند خالی باشد";
    } else if (value.length < 8) {
      return "رمز عبور باید بیشتر از ۸ کاراکتر باشد";
    }
    return null;
  }

  String validateUserName(String value) {
    String pattern = r'(^[a-zA-Z0-9]*$)';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      return "نام کاربری نمیتواند خالی باشد";
    } else if (!regExp.hasMatch(value)) {
      return "نام کاربری باید شامل حروف لاتین و عدد باشد";
    }
    return null;
  }

  String validateEmail(String value) {
    if (value.length == 0) {
      return "ایمیل نمیتواند خالی باشد";
    } else if (!isEmail(value)) {
      return "ایمیل شما نامعتبر است";
    } else {
      return null;
    }
  }

  String validatedropdown(String value) {
    if (value == null) {
      return "نوع آزمون مورد نظر را انتخاب کنید";
    }
    return null;
  }

  String validatetitle(String value) {
    if (value.length == 0) {
      return "لطفا یک عنوان برای آزمون انتخاب کنید";
    }
    return null;
  }

  String validatedescription(String value) {
    if (value.length == 0) {
      return "لظفا یک توضیحی درباره آزمون خود شرح دهید";
    }
    return null;
  }
}
