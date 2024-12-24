class AppLocale {
  // Common text keys
  static const String title = 'title';
  static const String welcomeText = 'welcomeText';
  static const String getStarted = 'getStarted';
  static const String fastestAndSecure = 'fastestAndSecure';

  // Login page text keys
  static const String phoneNumber = 'phoneNumber';
  static const String getOtp = 'getOtp';
  static const String enterOtp = 'enterOtp';
  static const String otpSent = 'otpSent';
  static const String verifyOtp = 'verifyOtp';
  static const String resendOtp = 'resendOtp';

  // OTP Page keys
  static const String otpPageTitle = 'otpPageTitle';
  static const String otpVerificationSuccess = 'otpVerificationSuccess';

  // Parties Screen Keys
  static const String parties = 'parties';
  static const String customers = 'customers';
  static const String suppliers = 'suppliers';
  static const String searchCustomer = 'searchCustomer';
  static const String cashbook = 'cashbook';
  static const String addCustomer = 'addCustomer';
  static const String youWillGive = 'youWillGive';
  static const String youWillGet = 'youWillGet';
  static const String qrCollections = 'qrCollections';
  static const String viewReports = 'viewReports';
  static const String remind = 'remind';
  static const String filter = 'filter';
  static const String totalBalance = 'totalBalance';
  static const String noCustomers = 'nocustomer';
  static const String recentTransactions = 'recentTransactions';

  // Additional Keys for Bills, Items, and More screens
  static const String bills = 'bills';
  static const String items = 'items';
  static const String more = 'more';

  // New Keys for Settings, Profile, and Notifications
  static const String settings = 'settings';
  static const String profile = 'profile';
  static const String notifications = 'notifications';
  static const String language = 'language';
  static const String logout = 'logout';
  static const String updateProfile = 'updateProfile';
  static const String changePassword = 'changePassword';

  /// English Translations (Default Language)
  static const Map<String, String> EN = {
    // Common
    title: 'Welcome to Khatabook',
    welcomeText: 'Track your daily expenses easily.',
    getStarted: 'Get Started',
    fastestAndSecure: 'Fastest and Secure',

    // Login & OTP
    phoneNumber: 'Phone Number',
    getOtp: 'Get OTP',
    enterOtp: 'Enter OTP',
    otpSent: 'We have sent a 6-digit OTP to your registered phone number.',
    verifyOtp: 'Verify OTP',
    resendOtp: 'Resend OTP',
    otpPageTitle: 'OTP Verification',
    otpVerificationSuccess: 'OTP verified successfully!',

    // Parties Screen
    parties: 'Parties',
    customers: 'Customers',
    suppliers: 'Suppliers',
    searchCustomer: 'Search Customer',
    cashbook: 'Cashbook',
    addCustomer: 'Add Customer',
    youWillGive: 'You will give',
    youWillGet: 'You will get',
    qrCollections: 'QR Collections',
    viewReports: 'VIEW REPORTS',
    remind: 'REMIND',
    filter: 'Filter',
    totalBalance: 'Total Balance',
    recentTransactions: 'Recent Transactions',

    // Bills, Items, More
    bills: 'Bills',
    items: 'Items',
    more: 'More',

    // Settings, Profile, Notifications
    settings: 'Settings',
    profile: 'Profile',
    notifications: 'Notifications',
    language: 'Language',
    logout: 'Logout',
    updateProfile: 'Update Profile',
    changePassword: 'Change Password',
  };

  /// Marathi Translations
  static const Map<String, String> MR = {
    // Common
    title: 'खाताबूक मध्ये स्वागत आहे',
    welcomeText: 'तुमच्या दैनिक खर्चाचे सहजपणे ट्रॅक करा.',
    getStarted: 'सुरू करा',
    fastestAndSecure: 'सर्वात वेगवान आणि सुरक्षित',

    // Login & OTP
    phoneNumber: 'फोन नंबर',
    getOtp: 'OTP मिळवा',
    enterOtp: 'OTP टाका',
    otpSent: 'आम्ही तुमच्या नोंदणीकृत फोन नंबरवर 6-अंकी OTP पाठवला आहे.',
    verifyOtp: 'OTP पडताळा करा',
    resendOtp: 'OTP पुन्हा पाठवा',
    otpPageTitle: 'OTP पडताळणी',
    otpVerificationSuccess: 'OTP यशस्वीरित्या पडताळला गेला!',

    // Parties Screen
    parties: 'पक्ष',
    customers: 'ग्राहक',
    suppliers: 'पुरवठादार',
    searchCustomer: 'ग्राहक शोधा',
    cashbook: 'कॅशबुक',
    addCustomer: 'ग्राहक जोडा',
    youWillGive: 'तुम्ही देणार',
    youWillGet: 'तुम्हाला मिळणार',
    qrCollections: 'QR संग्रह',
    viewReports: 'अहवाल पाहा',
    remind: 'आठवण द्या',
    filter: 'फिल्टर',
    totalBalance: 'एकूण शिल्लक',
    recentTransactions: 'अलीकडील व्यवहार',
    noCustomers: 'ग्राहक नाहीत',

    // Bills, Items, More
    bills: 'बिल्स',
    items: 'आयटम्स',
    more: 'अधिक',

    // Settings, Profile, Notifications
    settings: 'सेटिंग्ज',
    profile: 'प्रोफाइल',
    notifications: 'सूचनाएँ',
    language: 'भाषा',
    logout: 'लॉगआउट',
    updateProfile: 'प्रोफाइल अपडेट करा',
    changePassword: 'पासवर्ड बदलें',
  };

  /// Get localized text based on the current language
  static String getText(String key, String languageCode) {
    final Map<String, String> locale = getLocale(languageCode);
    return locale[key] ?? EN[key] ?? key; // Fallback logic: If key is not found in the selected language, fallback to English.
  }

  /// Get locale map based on the language code
  static Map<String, String> getLocale(String languageCode) {
    switch (languageCode) {
      case 'mr':
        return MR; // Marathi locale
      default:
        return EN; // Default to English locale
    }
  }

  /// Helper method to get translated text by language code
  static String getTextByLocale(String key, String languageCode) {
    return getText(key, languageCode);
  }
}
