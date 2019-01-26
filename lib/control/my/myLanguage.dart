import 'package:flutter/material.dart';
import 'package:retailapp/control/my/mySharedPreferences.dart';

enum myLanguageItem {
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
  thisProcessIsSpecificOnlyToTheAdministrator,
  date,
  customer,
  pleaseUpdateYourApp,
  fromCurrentVersion,
  toTheNewVersion,
  whatsNew,
  whatsNewInThisVersion
}

class MyLanguage {
  static String languageApp = 'en-US';
//String languageApp = 'ar-AR';

  static String _textEN(myLanguageItem t) {
    switch (t) {
      case myLanguageItem.whatsNewInThisVersion:
        return 'What\'s new in this version';
        break;
      case myLanguageItem.whatsNew:
        return 'What\'s new';
        break;
      case myLanguageItem.toTheNewVersion:
        return 'To the new version';
        break;
      case myLanguageItem.fromCurrentVersion:
        return 'From current version';
        break;
      case myLanguageItem.pleaseUpdateYourApp:
        return 'Please update your app';
        break;
      case myLanguageItem.customer:
        return 'Customer';
        break;
      case myLanguageItem.date:
        return 'Date';
        break;
      case myLanguageItem.thisProcessIsSpecificOnlyToTheAdministrator:
        return 'This process is specific only to the administrator';
        break;
      case myLanguageItem.thisWillApplyToTheDetailsAsWell:
        return 'This will apply to the details as well';
        break;
      case myLanguageItem.withZeroValues:
        return 'With zero values';
        break;
      case myLanguageItem.duration:
        return 'Duration';
        break;
      case myLanguageItem.monthlySalesReportFromMyDiaries:
        return 'Monthly sales report from my diaries';
        break;
      case myLanguageItem.theFilterAppliesOnlyMonthly:
        return 'The filter applies only monthly';
        break;
      case myLanguageItem.filterBy:
        return 'Filter by';
        break;
      case myLanguageItem.detail:
        return 'Detail';
        break;
      case myLanguageItem.total:
        return 'Total';
        break;
      case myLanguageItem.count:
        return 'Count';
        break;
      case myLanguageItem.month:
        return 'Month';
        break;
      case myLanguageItem.monthlySalesReportFromRequests:
        return 'Monthly sales report from requests';
        break;
      case myLanguageItem.thereAreNoData:
        return 'There are no data';
        break;
      case myLanguageItem.reports:
        return 'Reports';
        break;
      case myLanguageItem.statistics:
        return 'Statistics';
        break;
      case myLanguageItem.currentDataMayHaveBeenChanged:
        return 'Current data may have been changed';
        break;
      case myLanguageItem.youWereUnableToAddOrEditAnyRequest:
        return 'You were unable to add or edit any request';
        break;
      case myLanguageItem.youAreNotConnectedToTheInternet:
        return 'You are not connected to the Internet';
        break;
      case myLanguageItem.amountOfQuotation:
        return 'Amount of quotation';
        break;
      case myLanguageItem.theCustomerYouWantIsNotFound:
        return 'The customer you want is not found';
        break;
      case myLanguageItem.me:
        return 'Me';
        break;
      case myLanguageItem.filterIsAppliedOnlyToAPageAllPending:
        return 'Filter is applied only to a page (All - Pending)';
        break;
      case myLanguageItem.determineThePeriodOfTime:
        return 'Determine the period of time';
        break;
      case myLanguageItem.itsMyPrivateImages:
        return 'It\'s my private images';
        break;
      case myLanguageItem.captureAnImage:
        return 'Capture an image';
        break;
      case myLanguageItem.chooseImages:
        return 'Choose images';
        break;
      case myLanguageItem.chooseAUser:
        return 'Choose a user';
        break;
      case myLanguageItem.editACallLog:
        return 'Edit a call log';
        break;
      case myLanguageItem.view:
        return 'View';
        break;
      case myLanguageItem.win:
        return 'Win';
        break;
      case myLanguageItem.edit:
        return 'Edit';
        break;
      case myLanguageItem.weCantGetPermissionForYou:
        return 'we can\'t get permission for you';
        break;
      case myLanguageItem.yourNameOrPasswordIsNotCorrect:
        return 'Your name or password is not correct';
        break;
      case myLanguageItem.weNeedYouToEnableYour:
        return 'We need you to enable your';
        break;
      case myLanguageItem.weNeedPermissionForYour:
        return 'We need permission for your';
        break;
      case myLanguageItem.ok:
        return 'Ok';
        break;
      case myLanguageItem.pressForALongTimeToDeleteIt:
        return 'Press for a long time to delete it';
        break;
      case myLanguageItem.youMustChooseAValue:
        return 'You must choose a value';
        break;
      case myLanguageItem.weNeedYouToEnableYourLocation:
        return 'We need you to enable your location';
        break;
      case myLanguageItem.weNeedPermissionForYourLocation:
        return 'We need permission for your location';
        break;
      case myLanguageItem.no:
        return 'No';
        break;
      case myLanguageItem.yes:
        return 'Yes';
        break;
      case myLanguageItem.areYouSureYouWantToDelete:
        return 'Are you sure you want to delete';
        break;
      case myLanguageItem.delete:
        return 'Delete';
        break;
      case myLanguageItem.editADailyEvent:
        return 'Edit a daily event';
        break;
      case myLanguageItem.visitCustomer:
        return 'Visit customer';
        break;
      case myLanguageItem.outgoingCall:
        return 'Outgoing call';
        break;
      case myLanguageItem.showroom:
        return 'Showroom';
        break;
      case myLanguageItem.to:
        return 'To';
        break;
      case myLanguageItem.from:
        return 'From';
        break;
      case myLanguageItem.type:
        return 'Type';
        break;
      case myLanguageItem.resultingAmount:
        return 'Resulting amount';
        break;
      case myLanguageItem.weTalkedAbout:
        return 'We talked about';
        break;
      case myLanguageItem.newADailyEvent:
        return 'new a daily event';
        break;
      case myLanguageItem.myDiaries:
        return 'My diaries';
        break;
      case myLanguageItem.newImage:
        return 'New image';
        break;
      case myLanguageItem.images:
        return 'Images';
        break;
      case myLanguageItem.timelineImages:
        return 'Timeline images';
        break;
      case myLanguageItem.timelineNotes:
        return 'Timeline notes';
        break;
      case myLanguageItem.amount:
        return 'Amount';
        break;
      case myLanguageItem.requestCompleted:
        return 'Request completed';
        break;
      case myLanguageItem.filterRequests:
        return 'Filter requests';
        break;
      case myLanguageItem.editRequest:
        return 'Edit Request';
        break;
      case myLanguageItem.notes:
        return 'Notes';
        break;
      case myLanguageItem.chooseARequestType:
        return 'Choose a request type';
        break;
      case myLanguageItem.chooseASalseman:
        return 'Choose a salseman';
        break;
      case myLanguageItem.target:
        return 'Target';
        break;
      case myLanguageItem.chooseAnAppointment:
        return 'choose an appointment';
        break;
      case myLanguageItem.appointment:
        return 'Appointment';
        break;
      case myLanguageItem.subject:
        return 'Subject';
        break;
      case myLanguageItem.chooseAnEmployee:
        return 'Choose an employee';
        break;
      case myLanguageItem.chooseACustomer:
        return 'Choose a customer';
        break;
      case myLanguageItem.newRequest:
        return 'New Request';
        break;
      case myLanguageItem.pending:
        return 'Pending';
        break;
      case myLanguageItem.all:
        return 'All';
        break;
      case myLanguageItem.tomorrow:
        return 'Tomorrow';
        break;
      case myLanguageItem.requests:
        return 'Requests';
        break;
      case myLanguageItem.viewLocation:
        return 'View location';
        break;
      case myLanguageItem.location:
        return 'Location';
        break;
      case myLanguageItem.setLocationFromTheMap:
        return 'Set location from the map';
        break;
      case myLanguageItem.detectLocation:
        return 'Detect Location';
        break;
      case myLanguageItem.typeToFindWhatYouWant:
        return 'Type to find what you want';
        break;
      case myLanguageItem.editContact:
        return 'Edit Contact';
        break;
      case myLanguageItem.newContact:
        return 'New Contact';
        break;
      case myLanguageItem.save:
        return 'Save';
        break;
      case myLanguageItem.note:
        return 'Note';
        break;
      case myLanguageItem.email:
        return 'Email';
        break;
      case myLanguageItem.address:
        return 'Address';
        break;
      case myLanguageItem.phones:
        return 'Phones';
        break;
      case myLanguageItem.name:
        return 'Name';
        break;
      case myLanguageItem.contacts:
        return 'Contacts';
        break;
      case myLanguageItem.search:
        return 'Search';
        break;
      case myLanguageItem.cancel:
        return 'Cancel';
        break;
      case myLanguageItem.toDate:
        return 'To date';
        break;
      case myLanguageItem.fromDate:
        return 'From date';
        break;
      case myLanguageItem.filterSettings:
        return 'Filter Settings';
        break;
      case myLanguageItem.clickOnTheFilterButtonToLoadData:
        return 'Click on the filter button to load data';
        break;
      case myLanguageItem.loading:
        return 'Loading';
        break;
      case myLanguageItem.old:
        return 'Old';
        break;
      case myLanguageItem.lastWeek:
        return 'Last Week';
        break;
      case myLanguageItem.thisWeek:
        return 'This week';
        break;
      case myLanguageItem.interval:
        return 'Interval';
        break;
      case myLanguageItem.week:
        return 'Week';
        break;
      case myLanguageItem.yesterday:
        return 'Yesterday';
        break;
      case myLanguageItem.today:
        return 'Today';
        break;
      case myLanguageItem.callerLog:
        return 'Caller log';
        break;
      case myLanguageItem.youMustInsertText:
        return 'You must insert text';
        break;
      case myLanguageItem.theDataIsIncorrect:
        return 'The data is incorrect';
        break;
      case myLanguageItem.textToBeImplemented:
        return 'Text to be implemented';
        break;
      case myLanguageItem.saveSuccessfully:
        return 'Save successfully';
        break;
      case myLanguageItem.yourAccountWasSuccessfullyCreated:
        return 'Your account was successfully created';
        break;
      case myLanguageItem.welcome:
        return 'Welcome';
        break;
      case myLanguageItem.emailIsInvalid:
        return 'Email is invalid';
        break;
      case myLanguageItem.passwordMustBe8CharactersOrMore:
        return 'Password must be 8 characters or more';
        break;
      case myLanguageItem.youMustInsertYourPassword:
        return 'You must insert your password';
        break;
      case myLanguageItem.youMustInsertYourName:
        return 'You must insert your name';
        break;
      case myLanguageItem.createAnAccount:
        return 'Create an account';
        break;
      case myLanguageItem.smartSecurity:
        return 'Smart Security';
        break;
      case myLanguageItem.login:
        return 'Login';
        break;
      case myLanguageItem.yourPassword:
        return 'Your password';
        break;
      case myLanguageItem.yourName:
        return 'Your name';
        break;

      default:
        {
          return 'textEN';
        }
        break;
    }
  }

  static String _textAR(myLanguageItem t) {
    switch (t) {
      case myLanguageItem.whatsNewInThisVersion:
        return 'ما هو الجديد في هذا الإصدار';
        break;
      case myLanguageItem.whatsNew:
        return 'ما الجديد';
        break;
      case myLanguageItem.toTheNewVersion:
        return 'إلى الإصدار الجديد';
        break;
      case myLanguageItem.fromCurrentVersion:
        return 'من الإصدار الحالي';
        break;
      case myLanguageItem.pleaseUpdateYourApp:
        return 'نرجو منك تحديث تطبيقك';
        break;
      case myLanguageItem.customer:
        return 'الزبون';
        break;
      case myLanguageItem.date:
        return 'التاريخ';
        break;
      case myLanguageItem.thisProcessIsSpecificOnlyToTheAdministrator:
        return 'هذا العملية خاصة فقط بالمسؤول';
        break;
      case myLanguageItem.thisWillApplyToTheDetailsAsWell:
        return 'سيتم تطبيق هذا على التفاصيل أيضا';
        break;
      case myLanguageItem.withZeroValues:
        return 'مع القيم صفر';
        break;
      case myLanguageItem.duration:
        return 'المدة الزمنية';
        break;
      case myLanguageItem.monthlySalesReportFromMyDiaries:
        return 'تقرير المبيعات الشهري من يومياتي';
        break;
      case myLanguageItem.theFilterAppliesOnlyMonthly:
        return 'التصفية تطبق  شهريا فقط';
        break;
      case myLanguageItem.filterBy:
        return 'تصفية حسب';
        break;
      case myLanguageItem.detail:
        return 'التفاصيل';
        break;
      case myLanguageItem.total:
        return 'المجموع';
        break;
      case myLanguageItem.count:
        return 'العدد';
        break;
      case myLanguageItem.month:
        return 'الشهر';
        break;
      case myLanguageItem.monthlySalesReportFromRequests:
        return 'تقرير المبيعات الشهري من الطلبات';
        break;
      case myLanguageItem.thereAreNoData:
        return 'لا يوجد بيانات';
        break;
      case myLanguageItem.reports:
        return 'تقارير';
        break;
      case myLanguageItem.statistics:
        return 'احصائيات';
        break;
      case myLanguageItem.currentDataMayHaveBeenChanged:
        return 'البيانات الحالية قد تكون تغيرت';
        break;
      case myLanguageItem.youWereUnableToAddOrEditAnyRequest:
        return 'لم تتمكن من إضافة أو تعديل أي طلب';
        break;
      case myLanguageItem.youAreNotConnectedToTheInternet:
        return 'أنت غير متصل بالإنترنت';
        break;
      case myLanguageItem.amountOfQuotation:
        return 'مبلغ عرض الأسعار';
        break;
      case myLanguageItem.theCustomerYouWantIsNotFound:
        return 'لم يتم العثور على الزبون الذي تريده';
        break;
      case myLanguageItem.me:
        return 'أنا';
        break;
      case myLanguageItem.filterIsAppliedOnlyToAPageAllPending:
        return 'يتم تطبيق التصفية فقط على صفحة (الكل - المعلق)';
        break;
      case myLanguageItem.determineThePeriodOfTime:
        return 'تحديد الفترة الزمنية';
        break;
      case myLanguageItem.itsMyPrivateImages:
        return 'انها صورتي الخاصة';
        break;
      case myLanguageItem.captureAnImage:
        return 'التقاط صورة';
        break;
      case myLanguageItem.chooseImages:
        return 'اختر الصور';
        break;
      case myLanguageItem.chooseAUser:
        return 'اختيار مستخدم';
        break;
      case myLanguageItem.editACallLog:
        return 'تعديل سجل الاتصال';
        break;
      case myLanguageItem.view:
        return 'عرض';
        break;
      case myLanguageItem.win:
        return 'فوز';
        break;
      case myLanguageItem.edit:
        return 'تعديل';
        break;
      case myLanguageItem.weCantGetPermissionForYou:
        return 'لا يمكننا الحصول على إذن لك';
        break;
      case myLanguageItem.yourNameOrPasswordIsNotCorrect:
        return 'اسمك أو كلمة المرور غير صحيح';
        break;
      case myLanguageItem.weNeedYouToEnableYour:
        return 'نحن بحاجة منك تمكين';
        break;
      case myLanguageItem.weNeedPermissionForYour:
        return 'نحن بحاجة إلى إذن';
        break;
      case myLanguageItem.ok:
        return 'حسناً';
        break;
      case myLanguageItem.pressForALongTimeToDeleteIt:
        return 'اضغط لفترة طويلة لحذفها';
        break;
      case myLanguageItem.youMustChooseAValue:
        return 'يجب عليك اختيار قيمة';
        break;
      case myLanguageItem.weNeedYouToEnableYourLocation:
        return 'نحن بحاجة منك تمكين موقعك';
        break;
      case myLanguageItem.weNeedPermissionForYourLocation:
        return 'نحن بحاجة إلى إذن لموقعك';
        break;
      case myLanguageItem.no:
        return 'لا';
        break;
      case myLanguageItem.yes:
        return 'نعم';
        break;
      case myLanguageItem.areYouSureYouWantToDelete:
        return 'هل أنت متأكد أنك تريد حذف';
        break;
      case myLanguageItem.delete:
        return 'حذف';
        break;
      case myLanguageItem.editADailyEvent:
        return 'تعديل الحدث اليومي';
        break;
      case myLanguageItem.visitCustomer:
        return 'زيارة الزبون';
        break;
      case myLanguageItem.outgoingCall:
        return 'مكالمة صادرة';
        break;
      case myLanguageItem.showroom:
        return 'صالة عرض';
        break;
      case myLanguageItem.to:
        return 'إلى';
        break;
      case myLanguageItem.from:
        return 'من';
        break;
      case myLanguageItem.type:
        return 'النوع';
        break;
      case myLanguageItem.resultingAmount:
        return 'المبلغ الناتج';
        break;
      case myLanguageItem.weTalkedAbout:
        return 'تحدثنا عن';
        break;
      case myLanguageItem.newADailyEvent:
        return 'حدث يومي جديد';
        break;
      case myLanguageItem.myDiaries:
        return 'يومياتي';
        break;
      case myLanguageItem.newImage:
        return 'صورة جديدة';
        break;
      case myLanguageItem.images:
        return 'الصور';
        break;
      case myLanguageItem.timelineImages:
        return 'صور الجدول الزمني';
        break;
      case myLanguageItem.timelineNotes:
        return 'ملاحظات الجدول الزمني';
        break;
      case myLanguageItem.amount:
        return 'المبلغ';
        break;
      case myLanguageItem.requestCompleted:
        return 'اكتمال الطلب';
        break;
      case myLanguageItem.filterRequests:
        return 'تصفية الطلبات';
        break;
      case myLanguageItem.editRequest:
        return 'تعديل الطلب';
        break;
      case myLanguageItem.notes:
        return 'الملاحظات';
        break;
      case myLanguageItem.chooseARequestType:
        return 'اختيار نوع الطلب';
        break;
      case myLanguageItem.chooseASalseman:
        return 'اختيار مندوب مبيعات';
        break;
      case myLanguageItem.target:
        return 'الهدف';
        break;
      case myLanguageItem.chooseAnAppointment:
        return 'اختر موعد';
        break;
      case myLanguageItem.appointment:
        return 'الموعد';
        break;
      case myLanguageItem.subject:
        return 'الموضوع';
        break;
      case myLanguageItem.chooseAnEmployee:
        return 'اختيار موظف';
        break;
      case myLanguageItem.chooseACustomer:
        return 'اختيار زبون';
        break;
      case myLanguageItem.newRequest:
        return 'طلب جديد';
        break;
      case myLanguageItem.pending:
        return 'قيد الانتظار';
        break;
      case myLanguageItem.all:
        return 'الكل';
        break;
      case myLanguageItem.tomorrow:
        return 'غدا';
        break;
      case myLanguageItem.requests:
        return 'الطلبات';
        break;
      case myLanguageItem.viewLocation:
        return 'عرض الموقع';
        break;
      case myLanguageItem.location:
        return 'الموقع';
        break;
      case myLanguageItem.setLocationFromTheMap:
        return 'تعيين الموقع من الخريطة';
        break;
      case myLanguageItem.detectLocation:
        return 'تحديد الموقع';
        break;
      case myLanguageItem.typeToFindWhatYouWant:
        return 'اكتب للعثور على ما تريد';
        break;
      case myLanguageItem.editContact:
        return 'تعديل الاتصال';
        break;
      case myLanguageItem.newContact:
        return 'جهة اتصال جديدة';
        break;
      case myLanguageItem.save:
        return 'حفظ';
        break;
      case myLanguageItem.note:
        return 'الملاحظة';
        break;
      case myLanguageItem.email:
        return 'البريد الإلكتروني';
        break;
      case myLanguageItem.address:
        return 'العنوان';
        break;
      case myLanguageItem.phones:
        return 'الهواتف';
        break;
      case myLanguageItem.name:
        return 'الاسم';
        break;
      case myLanguageItem.contacts:
        return 'جهات الاتصال';
        break;
      case myLanguageItem.search:
        return 'بحث';
        break;
      case myLanguageItem.cancel:
        return 'إلغاء';
        break;
      case myLanguageItem.toDate:
        return 'إلى التاريخ';
        break;
      case myLanguageItem.fromDate:
        return 'من التاريخ';
        break;
      case myLanguageItem.filterSettings:
        return 'إعدادات تصفية';
        break;
      case myLanguageItem.clickOnTheFilterButtonToLoadData:
        return 'انقر على زر التصفية لتحميل البيانات';
        break;
      case myLanguageItem.loading:
        return 'جار التحميل';
        break;
      case myLanguageItem.old:
        return 'قديم';
        break;
      case myLanguageItem.lastWeek:
        return 'الاسبوع الماضي';
        break;
      case myLanguageItem.thisWeek:
        return 'هذا الاسبوع';
        break;
      case myLanguageItem.interval:
        return 'فترة';
        break;
      case myLanguageItem.week:
        return 'أسبوع';
        break;
      case myLanguageItem.yesterday:
        return 'في الامس';
        break;
      case myLanguageItem.today:
        return 'اليوم';
        break;
      case myLanguageItem.callerLog:
        return 'سجل الاتصالات';
        break;
      case myLanguageItem.youMustInsertText:
        return 'يجب عليك إدخال النص';
        break;
      case myLanguageItem.theDataIsIncorrect:
        return 'البيانات غير صحيحة';
        break;
      case myLanguageItem.textToBeImplemented:
        return 'نص المطلوب تنفيذه';
        break;
      case myLanguageItem.saveSuccessfully:
        return 'تم الحفظ بنجاح';
        break;
      case myLanguageItem.yourAccountWasSuccessfullyCreated:
        return 'تم إنشاء حسابك بنجاح';
        break;
      case myLanguageItem.welcome:
        return 'أهلا بك';
        break;
      case myLanguageItem.emailIsInvalid:
        return 'البريد الالكتروني غير صحيح';
        break;
      case myLanguageItem.passwordMustBe8CharactersOrMore:
        return 'كلمة المرور يجب أن تكون 8 أحرف أو أكثر';
        break;
      case myLanguageItem.youMustInsertYourPassword:
        return 'يجب عليك إدخال كلمة المرور الخاصة بك';
        break;
      case myLanguageItem.youMustInsertYourName:
        return 'يجب عليك إدخال اسمك';
        break;
      case myLanguageItem.createAnAccount:
        return 'إنشاء حساب';
        break;
      case myLanguageItem.smartSecurity:
        return 'سمارت سكرتي';
        break;
      case myLanguageItem.login:
        return 'تسجيل الدخول';
        break;
      case myLanguageItem.yourPassword:
        return 'كلمة السر خاصتك';
        break;
      case myLanguageItem.yourName:
        return 'اسمك';
        break;

      default:
        {
          return 'textAR';
        }
        break;
    }
  }

  static String text(myLanguageItem t) {
    if (languageApp == 'en-US')
      return _textEN(t);
    else if (languageApp == 'ar-AR') return _textAR(t);

    return _textEN(t);
  }

  static String text2(myLanguageItem t, myLanguageItem t1) {
    if (languageApp == 'en-US')
      return _textEN(t) + ' ' + _textEN(t).toLowerCase();
    else if (languageApp == 'ar-AR')
      return _textAR(t) + ' ' + _textAR(t).toLowerCase();

    return _textEN(t) + ' ' + _textAR(t).toLowerCase();
  }

  static TextDirection rtl() {
    if (languageApp == 'en-US')
      return TextDirection.ltr;
    else if (languageApp == 'ar-AR') return TextDirection.rtl;

    return TextDirection.ltr;
  }

  static void setLanguageEN() {
    languageApp = 'en-US';
    MySharedPreferences.setLanguageApp('en-US');
  }

  static void setLanguageAR() {
    languageApp = 'ar-AR';
    setLanguageApp('ar-AR');
  }

  static void setLanguage(String v) {
    languageApp = v;
  }

  static void setLanguageApp(String v) {
    languageApp = v;
    MySharedPreferences.setLanguageApp(v);
  }
}
