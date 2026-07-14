import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_te.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hi'),
    Locale('te')
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @monthlyRentDue.
  ///
  /// In en, this message translates to:
  /// **'MONTHLY RENT DUE'**
  String get monthlyRentDue;

  /// No description provided for @payNow.
  ///
  /// In en, this message translates to:
  /// **'Pay Now'**
  String get payNow;

  /// No description provided for @securityDeposit.
  ///
  /// In en, this message translates to:
  /// **'Security Deposit'**
  String get securityDeposit;

  /// No description provided for @roomNumber.
  ///
  /// In en, this message translates to:
  /// **'Room No.'**
  String get roomNumber;

  /// No description provided for @introducingAutoPay.
  ///
  /// In en, this message translates to:
  /// **'Introducing Auto-Pay! 🚀'**
  String get introducingAutoPay;

  /// No description provided for @autoPayDescription.
  ///
  /// In en, this message translates to:
  /// **'Link UPI/Card for automatic monthly rent & double cashback rewards.'**
  String get autoPayDescription;

  /// No description provided for @profileStayOverview.
  ///
  /// In en, this message translates to:
  /// **'Profile & Stay Overview'**
  String get profileStayOverview;

  /// No description provided for @identityVerification.
  ///
  /// In en, this message translates to:
  /// **'Identity Verification'**
  String get identityVerification;

  /// No description provided for @identityVerifiedMessage.
  ///
  /// In en, this message translates to:
  /// **'Your identity has been verified successfully.'**
  String get identityVerifiedMessage;

  /// No description provided for @identityPendingMessage.
  ///
  /// In en, this message translates to:
  /// **'Your identity verification is pending.'**
  String get identityPendingMessage;

  /// No description provided for @stayStatus.
  ///
  /// In en, this message translates to:
  /// **'Stay Status'**
  String get stayStatus;

  /// No description provided for @activeStayMessage.
  ///
  /// In en, this message translates to:
  /// **'Active contract. No notice period raised.'**
  String get activeStayMessage;

  /// No description provided for @inactiveStayMessage.
  ///
  /// In en, this message translates to:
  /// **'Your stay is currently inactive.'**
  String get inactiveStayMessage;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @activeStay.
  ///
  /// In en, this message translates to:
  /// **'Active Stay'**
  String get activeStay;

  /// No description provided for @inactive.
  ///
  /// In en, this message translates to:
  /// **'Inactive'**
  String get inactive;

  /// No description provided for @noNewNotifications.
  ///
  /// In en, this message translates to:
  /// **'No new notifications'**
  String get noNewNotifications;

  /// No description provided for @rentvynPg.
  ///
  /// In en, this message translates to:
  /// **'Rentvyn PG'**
  String get rentvynPg;

  /// No description provided for @room.
  ///
  /// In en, this message translates to:
  /// **'Room'**
  String get room;

  /// No description provided for @city.
  ///
  /// In en, this message translates to:
  /// **'City'**
  String get city;

  /// No description provided for @tenant.
  ///
  /// In en, this message translates to:
  /// **'Tenant'**
  String get tenant;

  /// No description provided for @dueOn.
  ///
  /// In en, this message translates to:
  /// **'Due on'**
  String get dueOn;

  /// No description provided for @everyMonth.
  ///
  /// In en, this message translates to:
  /// **'of every month'**
  String get everyMonth;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @unverified.
  ///
  /// In en, this message translates to:
  /// **'Unverified'**
  String get unverified;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @altPhone.
  ///
  /// In en, this message translates to:
  /// **'Alt. Phone'**
  String get altPhone;

  /// No description provided for @gender.
  ///
  /// In en, this message translates to:
  /// **'Gender'**
  String get gender;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @cityState.
  ///
  /// In en, this message translates to:
  /// **'City / State'**
  String get cityState;

  /// No description provided for @zipcode.
  ///
  /// In en, this message translates to:
  /// **'Zipcode'**
  String get zipcode;

  /// No description provided for @roomRentDetails.
  ///
  /// In en, this message translates to:
  /// **'Room & Rent Details'**
  String get roomRentDetails;

  /// No description provided for @roomNo.
  ///
  /// In en, this message translates to:
  /// **'Room No'**
  String get roomNo;

  /// No description provided for @monthlyRent.
  ///
  /// In en, this message translates to:
  /// **'Monthly Rent'**
  String get monthlyRent;

  /// No description provided for @joinDate.
  ///
  /// In en, this message translates to:
  /// **'Join Date'**
  String get joinDate;

  /// No description provided for @emergencyContact.
  ///
  /// In en, this message translates to:
  /// **'Emergency Contact'**
  String get emergencyContact;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @relationship.
  ///
  /// In en, this message translates to:
  /// **'Relationship'**
  String get relationship;

  /// No description provided for @rentalAgreement.
  ///
  /// In en, this message translates to:
  /// **'Rental Agreement'**
  String get rentalAgreement;

  /// No description provided for @rentalAgreementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'ID, monthly rent, download PDF'**
  String get rentalAgreementSubtitle;

  /// No description provided for @policeVerification.
  ///
  /// In en, this message translates to:
  /// **'Police Verification (BG Check)'**
  String get policeVerification;

  /// No description provided for @policeVerificationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'e-KYC verification status & details'**
  String get policeVerificationSubtitle;

  /// No description provided for @roommateDetails.
  ///
  /// In en, this message translates to:
  /// **'Roommate Details'**
  String get roommateDetails;

  /// No description provided for @roommateDetailsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Occupants in your room'**
  String get roommateDetailsSubtitle;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @languageSubtitle.
  ///
  /// In en, this message translates to:
  /// **'English / Telugu / Hindi'**
  String get languageSubtitle;

  /// No description provided for @raiseComplaint.
  ///
  /// In en, this message translates to:
  /// **'Raise Complaint'**
  String get raiseComplaint;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @complaintCategory.
  ///
  /// In en, this message translates to:
  /// **'Complaint Category'**
  String get complaintCategory;

  /// No description provided for @selectPriority.
  ///
  /// In en, this message translates to:
  /// **'Select Priority'**
  String get selectPriority;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @submitComplaint.
  ///
  /// In en, this message translates to:
  /// **'Submit Complaint'**
  String get submitComplaint;

  /// No description provided for @complaintSubmittedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint Submitted Successfully'**
  String get complaintSubmittedSuccessfully;

  /// No description provided for @pleaseDescribeIssue.
  ///
  /// In en, this message translates to:
  /// **'Please describe your issue'**
  String get pleaseDescribeIssue;

  /// No description provided for @complaintFormInfo.
  ///
  /// In en, this message translates to:
  /// **'Fill out this form to submit your issue. Our management team will check it and update the status.'**
  String get complaintFormInfo;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Briefly explain the issue (e.g. WiFi not working since morning, leaking faucet in washroom...)'**
  String get descriptionHint;

  /// No description provided for @low.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// No description provided for @normal.
  ///
  /// In en, this message translates to:
  /// **'Normal'**
  String get normal;

  /// No description provided for @supportTickets.
  ///
  /// In en, this message translates to:
  /// **'Support Tickets'**
  String get supportTickets;

  /// No description provided for @raiseTicket.
  ///
  /// In en, this message translates to:
  /// **'Raise Ticket'**
  String get raiseTicket;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// No description provided for @open.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get open;

  /// No description provided for @inProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get inProgress;

  /// No description provided for @resolved.
  ///
  /// In en, this message translates to:
  /// **'Resolved'**
  String get resolved;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @noTicketsFound.
  ///
  /// In en, this message translates to:
  /// **'No Tickets Found'**
  String get noTicketsFound;

  /// No description provided for @noTicketsMessage.
  ///
  /// In en, this message translates to:
  /// **'You haven\'t raised any support tickets yet. Tap the button below to report an issue.'**
  String get noTicketsMessage;

  /// No description provided for @noTicketsFilterMessage.
  ///
  /// In en, this message translates to:
  /// **'No tickets match the selected status filter.'**
  String get noTicketsFilterMessage;

  /// No description provided for @viewAllTickets.
  ///
  /// In en, this message translates to:
  /// **'View All Tickets'**
  String get viewAllTickets;

  /// No description provided for @complaint.
  ///
  /// In en, this message translates to:
  /// **'Complaint'**
  String get complaint;

  /// No description provided for @createdOn.
  ///
  /// In en, this message translates to:
  /// **'Created on'**
  String get createdOn;

  /// No description provided for @ticketActions.
  ///
  /// In en, this message translates to:
  /// **'Ticket Actions'**
  String get ticketActions;

  /// No description provided for @editComplaint.
  ///
  /// In en, this message translates to:
  /// **'Edit Complaint'**
  String get editComplaint;

  /// No description provided for @editComplaintSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Modify your issue description'**
  String get editComplaintSubtitle;

  /// No description provided for @deleteComplaint.
  ///
  /// In en, this message translates to:
  /// **'Delete Complaint'**
  String get deleteComplaint;

  /// No description provided for @deleteComplaintSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Permanently remove this ticket'**
  String get deleteComplaintSubtitle;

  /// No description provided for @ticketId.
  ///
  /// In en, this message translates to:
  /// **'Ticket ID'**
  String get ticketId;

  /// No description provided for @priority.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// No description provided for @enterUpdatedDescription.
  ///
  /// In en, this message translates to:
  /// **'Enter updated description...'**
  String get enterUpdatedDescription;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @saveChanges.
  ///
  /// In en, this message translates to:
  /// **'Save Changes'**
  String get saveChanges;

  /// No description provided for @complaintUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint updated successfully'**
  String get complaintUpdatedSuccessfully;

  /// No description provided for @failedToUpdateComplaint.
  ///
  /// In en, this message translates to:
  /// **'Failed to update complaint'**
  String get failedToUpdateComplaint;

  /// No description provided for @deleteComplaintTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete Complaint?'**
  String get deleteComplaintTitle;

  /// No description provided for @deleteComplaintMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this complaint? This action cannot be undone.'**
  String get deleteComplaintMessage;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @complaintDeletedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Complaint deleted successfully'**
  String get complaintDeletedSuccessfully;

  /// No description provided for @failedToDeleteComplaint.
  ///
  /// In en, this message translates to:
  /// **'Failed to delete complaint'**
  String get failedToDeleteComplaint;

  /// No description provided for @high.
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;
  
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'hi', 'te'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'hi': return AppLocalizationsHi();
    case 'te': return AppLocalizationsTe();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
