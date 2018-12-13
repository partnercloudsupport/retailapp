import 'package:flutter/material.dart';
import 'package:retailapp/control/my/mySharedPreferences.dart'
    as mySharedPreferences;

enum item {
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
  viewLocation,
  requests,
  tomorrow,
  all,
  pending,
  newRequest,
  chooseACustomer,
  chooseAnEmployee,
  subject,
  appointment,
  chooseAnAppointment,
  target,
  chooseASalseman,
  chooseARequestType,
  notes,
  editRequest,
  filterRequests,
  requestCompleted,
  amount,
  timelineNotes,
  timelineImages,
  images,
  newImage
}
String languageApp = 'en-US';
//String languageApp = 'ar-AR';

String _textEN(item t) {
  switch (t) {
    case item.newImage:
      return 'New image';
      break;
    case item.images:
      return 'Images';
      break;
    case item.timelineImages:
      return 'Timeline images';
      break;
    case item.timelineNotes:
      return 'Timeline notes';
      break;
    case item.amount:
      return 'Amount';
      break;
    case item.requestCompleted:
      return 'Request completed';
      break;
    case item.filterRequests:
      return 'Filter requests';
      break;
    case item.editRequest:
      return 'Edit Request';
      break;
    case item.notes:
      return 'Notes';
      break;
    case item.chooseARequestType:
      return 'Choose a request type';
      break;
    case item.chooseASalseman:
      return 'Choose a salseman';
      break;
    case item.target:
      return 'Target';
      break;
    case item.chooseAnAppointment:
      return 'choose an appointment';
      break;
    case item.appointment:
      return 'Appointment';
      break;
    case item.subject:
      return 'Subject';
      break;
    case item.chooseAnEmployee:
      return 'Choose an employee';
      break;
    case item.chooseACustomer:
      return 'Choose a customer';
      break;
    case item.newRequest:
      return 'New Request';
      break;
    case item.pending:
      return 'Pending';
      break;
    case item.all:
      return 'All';
      break;
    case item.tomorrow:
      return 'Tomorrow';
      break;
    case item.requests:
      return 'Requests';
      break;
    case item.viewLocation:
      return 'view location';
      break;
    case item.location:
      return 'Location';
      break;
    case item.setLocationFromTheMap:
      return 'Set location from the map';
      break;
    case item.detectLocation:
      return 'Detect Location';
      break;
    case item.typeToFindWhatYouWant:
      return 'Type to find what you want';
      break;
    case item.editContact:
      return 'Edit Contact';
      break;
    case item.newContact:
      return 'New Contact';
      break;
    case item.save:
      return 'Save';
      break;
    case item.note:
      return 'Note';
      break;
    case item.email:
      return 'Email';
      break;
    case item.address:
      return 'Address';
      break;
    case item.phones:
      return 'Phones';
      break;
    case item.name:
      return 'Name';
      break;
    case item.contacts:
      return 'Contacts';
      break;
    case item.search:
      return 'Search';
      break;
    case item.cancel:
      return 'Cancel';
      break;
    case item.toDate:
      return 'To date';
      break;
    case item.fromDate:
      return 'From date';
      break;
    case item.filterSettings:
      return 'Filter Settings';
      break;
    case item.clickOnTheFilterButtonToLoadData:
      return 'Click on the filter button to load data';
      break;
    case item.loading:
      return 'Loading';
      break;
    case item.old:
      return 'Old';
      break;
    case item.lastWeek:
      return 'Last Week';
      break;
    case item.thisWeek:
      return 'This week';
      break;
    case item.interval:
      return 'Interval';
      break;
    case item.week:
      return 'Week';
      break;
    case item.yesterday:
      return 'Yesterday';
      break;
    case item.today:
      return 'Today';
      break;
    case item.callerLog:
      return 'Caller Log';
      break;
    case item.youMustInsertText:
      return 'You must insert text';
      break;
    case item.theDataIsIncorrect:
      return 'The data is incorrect';
      break;
    case item.textToBeImplemented:
      return 'Text to be implemented';
      break;
    case item.saveSuccessfully:
      return 'Save successfully';
      break;
    case item.yourAccountWasSuccessfullyCreated:
      return 'Your account was successfully created';
      break;
    case item.welcome:
      return 'Welcome';
      break;
    case item.emailIsInvalid:
      return 'Email is invalid';
      break;
    case item.passwordMustBe8CharactersOrMore:
      return 'Password must be 8 characters or more';
      break;
    case item.youMustInsertYourPassword:
      return 'You must insert your password';
      break;
    case item.youMustInsertYourName:
      return 'You must insert your name';
      break;
    case item.createAnAccount:
      return 'Create an account';
      break;
    case item.smartSecurity:
      return 'Smart Security';
      break;
    case item.login:
      return 'Login';
      break;
    case item.yourPassword:
      return 'Your password';
      break;
    case item.yourName:
      return 'Your name';
      break;

    default:
      {
        return 'textEN';
      }
      break;
  }
}

String _textAR(item t) {
  switch (t) {
    case item.newImage:
      return 'صورة جديدة';
      break;
    case item.images:
      return 'الصور';
      break;
    case item.timelineImages:
      return 'صور الجدول الزمني';
      break;
    case item.timelineNotes:
      return 'ملاحظات الجدول الزمني';
      break;
    case item.amount:
      return 'المبلغ';
      break;
    case item.requestCompleted:
      return 'اكتمال الطلب';
      break;
    case item.filterRequests:
      return 'تصفية الطلبات';
      break;
    case item.editRequest:
      return 'تعديل الطلب';
      break;
    case item.notes:
      return 'الملاحظات';
      break;
    case item.chooseARequestType:
      return 'اختيار نوع الطلب';
      break;
    case item.chooseASalseman:
      return 'اختيار مندوب مبيعات';
      break;
    case item.target:
      return 'الهدف';
      break;
    case item.chooseAnAppointment:
      return 'اختر موعد';
      break;
    case item.appointment:
      return 'الموعد';
      break;
    case item.subject:
      return 'الموضوع';
      break;
    case item.chooseAnEmployee:
      return 'اختيار موظف';
      break;
    case item.chooseACustomer:
      return 'اختيار زبون';
      break;
    case item.newRequest:
      return 'طلب جديد';
      break;
    case item.pending:
      return 'قيد الانتظار';
      break;
    case item.all:
      return 'الكل';
      break;
    case item.tomorrow:
      return 'غدا';
      break;
    case item.requests:
      return 'الطلبات';
      break;
    case item.viewLocation:
      return 'عرض الموقع';
      break;
    case item.location:
      return 'الموقع';
      break;
    case item.setLocationFromTheMap:
      return 'تعيين الموقع من الخريطة';
      break;
    case item.detectLocation:
      return 'تحديد الموقع';
      break;
    case item.typeToFindWhatYouWant:
      return 'اكتب للعثور على ما تريد';
      break;
    case item.editContact:
      return 'تعديل الاتصال';
      break;
    case item.newContact:
      return 'جهة اتصال جديدة';
      break;
    case item.save:
      return 'حفظ';
      break;
    case item.note:
      return 'الملاحظة';
      break;
    case item.email:
      return 'البريد الإلكتروني';
      break;
    case item.address:
      return 'العنوان';
      break;
    case item.phones:
      return 'الهواتف';
      break;
    case item.name:
      return 'الاسم';
      break;
    case item.contacts:
      return 'جهات الاتصال';
      break;
    case item.search:
      return 'بحث';
      break;
    case item.cancel:
      return 'إلغاء';
      break;
    case item.toDate:
      return 'إلى التاريخ';
      break;
    case item.fromDate:
      return 'من التاريخ';
      break;
    case item.filterSettings:
      return 'إعدادات تصفية';
      break;
    case item.clickOnTheFilterButtonToLoadData:
      return 'انقر على زر التصفية لتحميل البيانات';
      break;
    case item.loading:
      return 'جار التحميل';
      break;
    case item.old:
      return 'قديم';
      break;
    case item.lastWeek:
      return 'الاسبوع الماضي';
      break;
    case item.thisWeek:
      return 'هذا الاسبوع';
      break;
    case item.interval:
      return 'فترة';
      break;
    case item.week:
      return 'أسبوع';
      break;
    case item.yesterday:
      return 'في الامس';
      break;
    case item.today:
      return 'اليوم';
      break;
    case item.callerLog:
      return 'سجل الاتصالات';
      break;
    case item.youMustInsertText:
      return 'يجب عليك إدخال النص';
      break;
    case item.theDataIsIncorrect:
      return 'البيانات غير صحيحة';
      break;
    case item.textToBeImplemented:
      return 'نص المطلوب تنفيذه';
      break;
    case item.saveSuccessfully:
      return 'تم الحفظ بنجاح';
      break;
    case item.yourAccountWasSuccessfullyCreated:
      return 'تم إنشاء حسابك بنجاح';
      break;
    case item.welcome:
      return 'أهلا بك';
      break;
    case item.emailIsInvalid:
      return 'البريد الالكتروني غير صحيح';
      break;
    case item.passwordMustBe8CharactersOrMore:
      return 'كلمة المرور يجب أن تكون 8 أحرف أو أكثر';
      break;
    case item.youMustInsertYourPassword:
      return 'يجب عليك إدخال كلمة المرور الخاصة بك';
      break;
    case item.youMustInsertYourName:
      return 'يجب عليك إدخال اسمك';
      break;
    case item.createAnAccount:
      return 'إنشاء حساب';
      break;
    case item.smartSecurity:
      return 'سمارت سكرتي';
      break;
    case item.login:
      return 'تسجيل الدخول';
      break;
    case item.yourPassword:
      return 'كلمة السر خاصتك';
      break;
    case item.yourName:
      return 'اسمك';
      break;

    default:
      {
        return 'textAR';
      }
      break;
  }
}

String text(item t) {
  if (languageApp == 'en-US')
    return _textEN(t);
  else if (languageApp == 'ar-AR') return _textAR(t);

  return _textEN(t);
}

String text2(item t, item t1) {
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
