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
  newImage,
  myDiaries,
  newADailyEvent,
  weTalkedAbout,
  resultingAmount,
  type,
  from,
  to,
  showroom,
  outgoingCall,
  visitCustomer,
  editADailyEvent,
  delete,
  areYouSureYouWantToDelete,
  yes,
  no,
  weNeedPermissionForYourLocation,
  weNeedYouToEnableYourLocation,
  youMustChooseAValue,
  pressForALongTimeToDeleteIt,
  ok,
  weNeedPermissionForYour,
  weNeedYouToEnableYour,
  yourNameOrPasswordIsNotCorrect,
  weCantGetPermissionForYou,
  edit,
  win,
  view,
  editACallLog,
  chooseAUser,
  chooseImages,
  captureAnImage,
  itsMyPrivateImages,
  determineThePeriodOfTime,
  filterIsAppliedOnlyToAPageAllPending,
  me,
  theCustomerYouWantIsNotFound,
  amountOfQuotation,
  youAreNotConnectedToTheInternet,
  youWereUnableToAddOrEditAnyRequest,
  currentDataMayHaveBeenChanged,
  statistics,
  reports,
  thereAreNoData,
  monthlySalesReportFromRequests,
  month,
  count,
  total,
  detail,
  filterBy,
  theFilterAppliesOnlyMonthly,
  monthlySalesReportFromMyDiaries,
  duration,
  withZeroValues,
  thisWillApplyToTheDetailsAsWell,
  thisProcessIsSpecificOnlyToTheAdministrator
}

String languageApp = 'en-US';
//String languageApp = 'ar-AR';

String _textEN(item t) {
  switch (t) {
    case item.thisProcessIsSpecificOnlyToTheAdministrator:
      return 'This process is specific only to the administrator';
      break;
    case item.thisWillApplyToTheDetailsAsWell:
      return 'This will apply to the details as well';
      break;
    case item.withZeroValues:
      return 'With zero values';
      break;
    case item.duration:
      return 'Duration';
      break;
    case item.monthlySalesReportFromMyDiaries:
      return 'Monthly sales report from my diaries';
      break;
    case item.theFilterAppliesOnlyMonthly:
      return 'The filter applies only monthly';
      break;
    case item.filterBy:
      return 'Filter by';
      break;
    case item.detail:
      return 'Detail';
      break;
    case item.total:
      return 'Total';
      break;
    case item.count:
      return 'Count';
      break;
    case item.month:
      return 'Month';
      break;
    case item.monthlySalesReportFromRequests:
      return 'Monthly sales report from requests';
      break;
    case item.thereAreNoData:
      return 'There are no data';
      break;
    case item.reports:
      return 'Reports';
      break;
    case item.statistics:
      return 'Statistics';
      break;
    case item.currentDataMayHaveBeenChanged:
      return 'Current data may have been changed';
      break;
    case item.youWereUnableToAddOrEditAnyRequest:
      return 'You were unable to add or edit any request';
      break;
    case item.youAreNotConnectedToTheInternet:
      return 'You are not connected to the Internet';
      break;
    case item.amountOfQuotation:
      return 'Amount of quotation';
      break;
    case item.theCustomerYouWantIsNotFound:
      return 'The customer you want is not found';
      break;
    case item.me:
      return 'Me';
      break;
    case item.filterIsAppliedOnlyToAPageAllPending:
      return 'Filter is applied only to a page (All - Pending)';
      break;
    case item.determineThePeriodOfTime:
      return 'Determine the period of time';
      break;
    case item.itsMyPrivateImages:
      return 'It\'s my private images';
      break;
    case item.captureAnImage:
      return 'Capture an image';
      break;
    case item.chooseImages:
      return 'Choose images';
      break;
    case item.chooseAUser:
      return 'Choose a user';
      break;
    case item.editACallLog:
      return 'Edit a call log';
      break;
    case item.view:
      return 'View';
      break;
    case item.win:
      return 'Win';
      break;
    case item.edit:
      return 'Edit';
      break;
    case item.weCantGetPermissionForYou:
      return 'we can\'t get permission for you';
      break;
    case item.yourNameOrPasswordIsNotCorrect:
      return 'Your name or password is not correct';
      break;
    case item.weNeedYouToEnableYour:
      return 'We need you to enable your';
      break;
    case item.weNeedPermissionForYour:
      return 'We need permission for your';
      break;
    case item.ok:
      return 'Ok';
      break;
    case item.pressForALongTimeToDeleteIt:
      return 'Press for a long time to delete it';
      break;
    case item.youMustChooseAValue:
      return 'You must choose a value';
      break;
    case item.weNeedYouToEnableYourLocation:
      return 'We need you to enable your location';
      break;
    case item.weNeedPermissionForYourLocation:
      return 'We need permission for your location';
      break;
    case item.no:
      return 'No';
      break;
    case item.yes:
      return 'Yes';
      break;
    case item.areYouSureYouWantToDelete:
      return 'Are you sure you want to delete';
      break;
    case item.delete:
      return 'Delete';
      break;
    case item.editADailyEvent:
      return 'Edit a daily event';
      break;
    case item.visitCustomer:
      return 'Visit customer';
      break;
    case item.outgoingCall:
      return 'Outgoing call';
      break;
    case item.showroom:
      return 'Showroom';
      break;
    case item.to:
      return 'To';
      break;
    case item.from:
      return 'From';
      break;
    case item.type:
      return 'Type';
      break;
    case item.resultingAmount:
      return 'Resulting amount';
      break;
    case item.weTalkedAbout:
      return 'We talked about';
      break;
    case item.newADailyEvent:
      return 'new a daily event';
      break;
    case item.myDiaries:
      return 'My diaries';
      break;
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
      return 'View location';
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
      return 'Caller log';
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
    case item.thisProcessIsSpecificOnlyToTheAdministrator:
      return 'هذا العملية خاصة فقط بالمسؤول';
      break;
    case item.thisWillApplyToTheDetailsAsWell:
      return 'سيتم تطبيق هذا على التفاصيل أيضا';
      break;
    case item.withZeroValues:
      return 'مع القيم صفر';
      break;
    case item.duration:
      return 'المدة الزمنية';
      break;
    case item.monthlySalesReportFromMyDiaries:
      return 'تقرير المبيعات الشهري من يومياتي';
      break;
    case item.theFilterAppliesOnlyMonthly:
      return 'التصفية تطبق  شهريا فقط';
      break;
    case item.filterBy:
      return 'تصفية حسب';
      break;
    case item.detail:
      return 'التفاصيل';
      break;
    case item.total:
      return 'المجموع';
      break;
    case item.count:
      return 'العدد';
      break;
    case item.month:
      return 'الشهر';
      break;
    case item.monthlySalesReportFromRequests:
      return 'تقرير المبيعات الشهري من الطلبات';
      break;
    case item.thereAreNoData:
      return 'لا يوجد بيانات';
      break;
    case item.reports:
      return 'تقارير';
      break;
    case item.statistics:
      return 'احصائيات';
      break;
    case item.currentDataMayHaveBeenChanged:
      return 'البيانات الحالية قد تكون تغيرت';
      break;
    case item.youWereUnableToAddOrEditAnyRequest:
      return 'لم تتمكن من إضافة أو تعديل أي طلب';
      break;
    case item.youAreNotConnectedToTheInternet:
      return 'أنت غير متصل بالإنترنت';
      break;
    case item.amountOfQuotation:
      return 'مبلغ عرض الأسعار';
      break;
    case item.theCustomerYouWantIsNotFound:
      return 'لم يتم العثور على الزبون الذي تريده';
      break;
    case item.me:
      return 'أنا';
      break;
    case item.filterIsAppliedOnlyToAPageAllPending:
      return 'يتم تطبيق التصفية فقط على صفحة (الكل - المعلق)';
      break;
    case item.determineThePeriodOfTime:
      return 'تحديد الفترة الزمنية';
      break;
    case item.itsMyPrivateImages:
      return 'انها صورتي الخاصة';
      break;
    case item.captureAnImage:
      return 'التقاط صورة';
      break;
    case item.chooseImages:
      return 'اختر الصور';
      break;
    case item.chooseAUser:
      return 'اختيار مستخدم';
      break;
    case item.editACallLog:
      return 'تعديل سجل الاتصال';
      break;
    case item.view:
      return 'عرض';
      break;
    case item.win:
      return 'فوز';
      break;
    case item.edit:
      return 'تعديل';
      break;
    case item.weCantGetPermissionForYou:
      return 'لا يمكننا الحصول على إذن لك';
      break;
    case item.yourNameOrPasswordIsNotCorrect:
      return 'اسمك أو كلمة المرور غير صحيح';
      break;
    case item.weNeedYouToEnableYour:
      return 'نحن بحاجة منك تمكين';
      break;
    case item.weNeedPermissionForYour:
      return 'نحن بحاجة إلى إذن';
      break;
    case item.ok:
      return 'حسناً';
      break;
    case item.pressForALongTimeToDeleteIt:
      return 'اضغط لفترة طويلة لحذفها';
      break;
    case item.youMustChooseAValue:
      return 'يجب عليك اختيار قيمة';
      break;
    case item.weNeedYouToEnableYourLocation:
      return 'نحن بحاجة منك تمكين موقعك';
      break;
    case item.weNeedPermissionForYourLocation:
      return 'نحن بحاجة إلى إذن لموقعك';
      break;
    case item.no:
      return 'لا';
      break;
    case item.yes:
      return 'نعم';
      break;
    case item.areYouSureYouWantToDelete:
      return 'هل أنت متأكد أنك تريد حذف';
      break;
    case item.delete:
      return 'حذف';
      break;
    case item.editADailyEvent:
      return 'تعديل الحدث اليومي';
      break;
    case item.visitCustomer:
      return 'زيارة الزبون';
      break;
    case item.outgoingCall:
      return 'مكالمة صادرة';
      break;
    case item.showroom:
      return 'صالة عرض';
      break;
    case item.to:
      return 'إلى';
      break;
    case item.from:
      return 'من';
      break;
    case item.type:
      return 'النوع';
      break;
    case item.resultingAmount:
      return 'المبلغ الناتج';
      break;
    case item.weTalkedAbout:
      return 'تحدثنا عن';
      break;
    case item.newADailyEvent:
      return 'حدث يومي جديد';
      break;
    case item.myDiaries:
      return 'يومياتي';
      break;
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
