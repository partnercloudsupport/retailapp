import 'package:flutter/material.dart';
import 'package:retailapp/control/my/mySharedPreferences.dart'
    as mySharedPreferences;

enum TextIndex {
  yourName,
  yourPassword,
  login,
  smartSecurity,
  createAnAccount,
  youMustInsertYourName,
  youMustInsertYourPassword,
  passwordMustBe8CharactersOrMore,
  emailIsInvalid,
  welcome,
  yourAccountWasSuccessfullyCreated,
  saveSuccessfully,
  textToBeImplemented,
  theDataIsIncorrect,
  youMustInsertText,
  callerLog,
  today,
  yesterday,
  week,
  interval,
  thisWeek,
  lastWeek,
  old,
  loading,
  clickOnTheFilterButtonToLoadData,
  filterSettings,
  fromDate,
  toDate,
  cancel,
  search,
  contacts,
  name,
  phones,
  address,
  email,
  note,
  save,
  newContact,
  editContact,
  typeToFindWhatYouWant,
  detectLocation,
  setLocationFromTheMap,
  location,
  viewLocation
}

String languageApp = 'en-US';
//String languageApp = 'ar-AR';

String _textEN(TextIndex t) {
  switch (t) {
    case TextIndex.viewLocation:
      return 'view location';
      break;
    case TextIndex.location:
      return 'Location';
      break;
    case TextIndex.setLocationFromTheMap:
      return 'Set location from the map';
      break;
    case TextIndex.detectLocation:
      return 'Detect Location';
      break;
    case TextIndex.typeToFindWhatYouWant:
      return 'Type to find what you want';
      break;
    case TextIndex.editContact:
      return 'Edit Contact';
      break;
    case TextIndex.newContact:
      return 'New Contact';
      break;
    case TextIndex.save:
      return 'Save';
      break;
    case TextIndex.note:
      return 'Note';
      break;
    case TextIndex.email:
      return 'Email';
      break;
    case TextIndex.address:
      return 'Address';
      break;
    case TextIndex.phones:
      return 'Phones';
      break;
    case TextIndex.name:
      return 'Name';
      break;
    case TextIndex.contacts:
      return 'Contacts';
      break;
    case TextIndex.search:
      return 'Search';
      break;
    case TextIndex.cancel:
      return 'Cancel';
      break;
    case TextIndex.toDate:
      return 'To date';
      break;
    case TextIndex.fromDate:
      return 'From date';
      break;
    case TextIndex.filterSettings:
      return 'Filter Settings';
      break;
    case TextIndex.clickOnTheFilterButtonToLoadData:
      return 'Click on the filter button to load data';
      break;
    case TextIndex.loading:
      return 'Loading';
      break;
    case TextIndex.old:
      return 'Old';
      break;
    case TextIndex.lastWeek:
      return 'Last Week';
      break;
    case TextIndex.thisWeek:
      return 'This week';
      break;
    case TextIndex.interval:
      return 'Interval';
      break;
    case TextIndex.week:
      return 'Week';
      break;
    case TextIndex.yesterday:
      return 'Yesterday';
      break;
    case TextIndex.today:
      return 'Today';
      break;
    case TextIndex.callerLog:
      return 'Caller Log';
      break;
    case TextIndex.youMustInsertText:
      return 'You must insert text';
      break;
    case TextIndex.theDataIsIncorrect:
      return 'The data is incorrect';
      break;
    case TextIndex.textToBeImplemented:
      return 'Text to be implemented';
      break;
    case TextIndex.saveSuccessfully:
      return 'Save successfully';
      break;
    case TextIndex.yourAccountWasSuccessfullyCreated:
      return 'Your account was successfully created';
      break;
    case TextIndex.welcome:
      return 'Welcome';
      break;
    case TextIndex.emailIsInvalid:
      return 'Email is invalid';
      break;
    case TextIndex.passwordMustBe8CharactersOrMore:
      return 'Password must be 8 characters or more';
      break;
    case TextIndex.youMustInsertYourPassword:
      return 'You must insert your password';
      break;
    case TextIndex.youMustInsertYourName:
      return 'You must insert your name';
      break;
    case TextIndex.createAnAccount:
      return 'Create an account';
      break;
    case TextIndex.smartSecurity:
      return 'Smart Security';
      break;
    case TextIndex.login:
      return 'Login';
      break;
    case TextIndex.yourPassword:
      return 'Your password';
      break;
    case TextIndex.yourName:
      return 'Your name';
      break;

    default:
      {
        return 'textEN';
      }
      break;
  }
}

String _textAR(TextIndex t) {
  switch (t) {
    case TextIndex.viewLocation:
      return 'عرض الموقع';
      break;
    case TextIndex.location:
      return 'الموقع';
      break;
    case TextIndex.setLocationFromTheMap:
      return 'تعيين الموقع من الخريطة';
      break;
    case TextIndex.detectLocation:
      return 'تحديد الموقع';
      break;
    case TextIndex.typeToFindWhatYouWant:
      return 'اكتب للعثور على ما تريد';
      break;
    case TextIndex.editContact:
      return 'تحرير الاتصال';
      break;
    case TextIndex.newContact:
      return 'جهة اتصال جديدة';
      break;
    case TextIndex.save:
      return 'حفظ';
      break;
    case TextIndex.note:
      return 'الملاحظة';
      break;
    case TextIndex.email:
      return 'البريد الإلكتروني';
      break;
    case TextIndex.address:
      return 'العنوان';
      break;
    case TextIndex.phones:
      return 'الهواتف';
      break;
    case TextIndex.name:
      return 'الاسم';
      break;
    case TextIndex.contacts:
      return 'جهات الاتصال';
      break;
    case TextIndex.search:
      return 'بحث';
      break;
    case TextIndex.cancel:
      return 'إلغاء';
      break;
    case TextIndex.toDate:
      return 'إلى التاريخ';
      break;
    case TextIndex.fromDate:
      return 'من التاريخ';
      break;
    case TextIndex.filterSettings:
      return 'إعدادات تصفية';
      break;
    case TextIndex.clickOnTheFilterButtonToLoadData:
      return 'انقر على زر التصفية لتحميل البيانات';
      break;
    case TextIndex.loading:
      return 'جار التحميل';
      break;
    case TextIndex.old:
      return 'قديم';
      break;
    case TextIndex.lastWeek:
      return 'الاسبوع الماضي';
      break;
    case TextIndex.thisWeek:
      return 'هذا الاسبوع';
      break;
    case TextIndex.interval:
      return 'فترة';
      break;
    case TextIndex.week:
      return 'أسبوع';
      break;
    case TextIndex.yesterday:
      return 'في الامس';
      break;
    case TextIndex.today:
      return 'اليوم';
      break;
    case TextIndex.callerLog:
      return 'سجل الاتصالات';
      break;
    case TextIndex.youMustInsertText:
      return 'يجب عليك إدخال النص';
      break;
    case TextIndex.theDataIsIncorrect:
      return 'البيانات غير صحيحة';
      break;
    case TextIndex.textToBeImplemented:
      return 'نص المطلوب تنفيذه';
      break;
    case TextIndex.saveSuccessfully:
      return 'تم الحفظ بنجاح';
      break;
    case TextIndex.yourAccountWasSuccessfullyCreated:
      return 'تم إنشاء حسابك بنجاح';
      break;
    case TextIndex.welcome:
      return 'أهلا بك';
      break;
    case TextIndex.emailIsInvalid:
      return 'البريد الالكتروني غير صحيح';
      break;
    case TextIndex.passwordMustBe8CharactersOrMore:
      return 'كلمة المرور يجب أن تكون 8 أحرف أو أكثر';
      break;
    case TextIndex.youMustInsertYourPassword:
      return 'يجب عليك إدخال كلمة المرور الخاصة بك';
      break;
    case TextIndex.youMustInsertYourName:
      return 'يجب عليك إدخال اسمك';
      break;
    case TextIndex.createAnAccount:
      return 'إنشاء حساب';
      break;
    case TextIndex.smartSecurity:
      return 'سمارت سكرتي';
      break;
    case TextIndex.login:
      return 'تسجيل الدخول';
      break;
    case TextIndex.yourPassword:
      return 'كلمة السر خاصتك';
      break;
    case TextIndex.yourName:
      return 'اسمك';
      break;

    default:
      {
        return 'textAR';
      }
      break;
  }
}

String text(TextIndex t) {
  if (languageApp == 'en-US')
    return _textEN(t);
  else if (languageApp == 'ar-AR') return _textAR(t);

  return _textEN(t);
}

String text2(TextIndex t, TextIndex t1) {
  if (languageApp == 'en-US')
    return _textEN(t) + ' ' + _textEN(t).toLowerCase();
  else if (languageApp == 'ar-AR')
    return _textAR(t) + ' ' + _textAR(t).toLowerCase();

  return _textEN(t) + ' ' + _textAR(t).toLowerCase();
}

TextDirection rtl() {
  if (languageApp == 'en-US')
    return TextDirection.ltr;
  else if (languageApp == 'ar-AR') return TextDirection.rtl;

  return TextDirection.ltr;
}

void setLanguageEN() {
  languageApp = 'en-US';
  mySharedPreferences.setLanguageApp('en-US');
}

void setLanguageAR() {
  languageApp = 'ar-AR';
  setLanguageApp('ar-AR');
}

void setLanguage(String v) {
  languageApp = v;
}

void setLanguageApp(String v) {
  languageApp = v;
  mySharedPreferences.setLanguageApp(v);
}
