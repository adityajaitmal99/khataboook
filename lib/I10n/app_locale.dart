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
  static const String signInWithGoogle = 'signInWithGoogle';

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
  static const String viewReports = 'viewReports'; // keep this for Parties screen
  static const String remind = 'remind';
  static const String filter = 'filter';
  static const String totalBalance = 'totalBalance';
  static const String noCustomers = 'noCustomers';
  static const String recentTransactions = 'recentTransactions';

  // Bills Screen Keys (Billing-related texts)
  static const String monthlySales = 'monthlySales';
  static const String monthlyPurchases = 'monthlyPurchases';
  static const String todayIn = 'todayIn';
  static const String todayOut = 'todayOut';
  static const String sale = 'sale';
  static const String purchase = 'purchase';
  static const String expense = 'expense';
  static const String addBill = 'addBill';
  static const String searchForTransactions = 'searchForTransactions';
  static const String noBillsAvailable = 'noBillsAvailable';

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

  // New Keys for Items Screen
  static const String stockManagement = 'stockManagement';
  static const String addProduct = 'addProduct';
  static const String salePrice = 'salePrice';
  static const String purchasePrice = 'purchasePrice';
  static const String openingStock = 'openingStock';
  static const String lowStockAlert = 'lowStockAlert';
  static const String date = 'date';
  static const String stock = 'stock';
  static const String inStockStatus = 'inStockStatus'; // Renamed from 'in'
  static const String outOfStockStatus = 'outOfStockStatus'; // Renamed from 'out'
  static const String increaseStock = 'increaseStock';
  static const String decreaseStock = 'decreaseStock';
  static const String searchItems = 'searchItems'; // Added this key
  static const String viewItemsReports = 'viewItemsReports'; // Renamed from 'viewReports'

  // New Keys for More Screen
  static const String aboutUs = 'aboutUs';
  static const String termsConditions = 'termsConditions';
  static const String privacyPolicy = 'privacyPolicy';
  static const String faq = 'faq';
  static const String support = 'support';
  static const String contactUs = 'contactUs';

  static const String address = 'address';
  static const String enterAddress = 'enterAddress';
  static const String addressRequired = 'addressRequired';
  static const String mobileNumber = 'mobileNumber';
  static const String partyName = 'partyName';
  static const String  addParty = 'addParty';

  static const String  nameRequired = 'Please Enter party name';
  static const String  phoneRequired = 'Please Enter phone number';
  static const String  invalidPhone = 'Mobile number is not valid';
  static const String selectContact = 'selectContact';
  static const String searchContacts = 'searchContacts';
  static const String noContactsFound = 'noContactsFound';
  static const String noPhoneNumber = 'noPhoneNumber';
  static const String permissionDenied = 'permissionDenied';
  //you gave screen
  static const String youGaveTo = 'youGaveTo';
  static const String enterAmount = 'enterAmount';
  static const String enterDetails = 'enterDetails';
  static const String attachBills = 'attachBills';
  static const String save = 'save';
  static const String pleaseEnterAmount = 'pleaseEnterAmount';
  static const String cameraPermissionDenied = 'cameraPermissionDenied';
  static const String youGot = 'You Got';
  //pdf screen
  static const String generateInvoice = 'generateInvoice';
  static const String supplierDetails = 'supplierDetails';
  static const String supplierName = 'supplierName';
  static const String supplierAddress = 'supplierAddress';
  static const String customerDetails = 'customerDetails';
  static const String customerName = 'customerName';
  static const String customerPhone = 'customerPhone';
  static const String itemDetails = 'itemDetails';
  static const String addItem = 'addItem';
  static const String itemDescription = 'itemDescription';
  static const String quantity = 'quantity';
  static const String unitPrice = 'unitPrice';
  static const String addedItems = 'addedItems';
  static const String price = 'price';
  static const String generatePdf = 'generatePdf';
  static const String pleaseEnter = 'pleaseEnter';
  static const String invoiceDescription = 'invoiceDescription';

  //addditem
  static const String uploadPhoto = 'uploadPhoto';
  static const String itemName = 'itemName';
  static const String saveItem = 'saveItem';
  static const String camera_permission_required = 'camera_permission_required';
  static const String please_fill_fields = 'please_fill_fields';
  static const String enterItemName = 'enterItemName';
  static const String capturePhoto = 'capturePhoto';

  /// English Translations (Default Language)
  static const Map<String, String> EN = {
    // Common
    title: 'Softgrid Billing-App',
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
    signInWithGoogle: 'Sign in with Google',

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
    viewReports: 'VIEW REPORTS', // Keep for Parties Screen
    remind: 'REMIND',
    filter: 'Filter',
    totalBalance: 'Total Balance',
    recentTransactions: 'Recent Transactions',
    noCustomers: 'No Customers',

    // Bills, Items, More
    bills: 'Bills',
    items: 'Items',
    more: 'More',

    // Billing Screen
    monthlySales: 'Monthly Sales',
    monthlyPurchases: 'Monthly Purchases',
    todayIn: "Today's IN",
    todayOut: "Today's OUT",
    sale: 'Sale',
    purchase: 'Purchase',
    expense: 'Expense',
    addBill: 'Add Bill',
    searchForTransactions: 'Search for transactions',
    noBillsAvailable: 'No bills available',

    // Settings, Profile, Notifications
    settings: 'Settings',
    profile: 'Profile',
    notifications: 'Notifications',
    language: 'Language',
    logout: 'Logout',
    updateProfile: 'Update Profile',
    changePassword: 'Change Password',

    // Items Screen
    stockManagement: 'Stock Management',
    addProduct: 'Add Product',
    salePrice: 'Sale Price',
    purchasePrice: 'Purchase Price',
    openingStock: 'Opening Stock',
    lowStockAlert: 'Low Stock Alert',
    date: 'Date',
    stock: 'Stock',
    inStockStatus: 'In Stock', // Renamed from 'in'
    outOfStockStatus: 'Out of Stock', // Renamed from 'out'
    increaseStock: 'Increase Stock',
    decreaseStock: 'Decrease Stock',
    searchItems: 'Search Items', // Added this key
    viewItemsReports: 'View Reports', // Renamed from 'viewReports'

    // More Screen
    aboutUs: 'About Us',
    termsConditions: 'Terms & Conditions',
    privacyPolicy: 'Privacy Policy',
    faq: 'FAQ',
    support: 'Support',
    contactUs: 'Contact Us',

    address: 'Address',
    enterAddress: 'Enter Address',
    addressRequired: 'Address is required',
    mobileNumber: 'Mobile Number',
    partyName: 'Party Name',
    addParty: 'Add Party',
    phoneRequired: 'Please Enter phone number',
    invalidPhone: 'Mobile number is not valid',
    nameRequired: 'Please Enter party name',

    selectContact: 'Select Contact',
    searchContacts: 'Search Contacts',
    noContactsFound: 'No Contacts Found',
    noPhoneNumber: 'No Phone Number',
    permissionDenied: 'Permission denied to access contacts',
    //transaction detail screen
    'transactionDetails': 'Transaction Details',
    'youGave': 'YOU GAVE ₹',
    'youGot': 'YOU GOT ₹',
    'attachments': 'Attachments',
    'downloadPdf': 'Download PDF',
    'makePayment': 'Make Payment',
    'sendReminder': 'Send Reminder',
    'sendMessage': 'Send Message',
    'addNote': 'Add Note',
    'enterAmount': 'Enter Amount',
    'enterDescription': 'Enter Description',
    'attachBill': 'Attach Bill',
    'selectDate': 'Select Date',
    'save': 'Save',
    'cancel': 'Cancel',
    'Transactions:-': 'Transactions:-',
    //you gave screen
    youGaveTo: 'You gave ₹ to',

    enterDetails: 'Enter details (Items, bill no., quantity, etc.)',
    attachBills: 'Attach bills',

    pleaseEnterAmount: 'Please enter an amount!',
    cameraPermissionDenied: 'Camera permission denied',

    //pdf screen
    generateInvoice: 'Generate Invoice',
    supplierDetails: 'Supplier Details',
    supplierName: 'Supplier Name',
    supplierAddress: 'Supplier Address',
    customerDetails: 'Customer Details',
    customerName: 'Customer Name',
    customerPhone: 'Customer Phone',
    itemDetails: 'Item Details',
    addItem: 'Add Item',
    itemDescription: 'Item Description',
    quantity: 'Quantity',
    unitPrice: 'Unit Price',
    addedItems: 'Added Items',
    price: 'Price',
    generatePdf: 'Generate PDF',
    pleaseEnter: 'Please enter',
    invoiceDescription: 'Invoice Description',

    //addd item
    uploadPhoto: 'Upload Photo',
    saveItem: 'Save Item',
    itemName: 'Item Name',
    camera_permission_required: 'Camera permission is required',
    please_fill_fields: 'Please fill in all required fields',
    enterItemName: 'Enter item name',
    capturePhoto: 'Capture Photo',
  };

  /// Marathi Translations
  static const Map<String, String> MR = {
    // Common
    title: 'सॉफ्टग्रिड बिलिंग-ॲप मध्ये स्वागत आहे',
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
    signInWithGoogle: 'गुगलने साइन इन करा',

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
    viewReports: 'अहवाल पाहा', // Keep for Parties Screen
    remind: 'आठवण द्या',
    filter: 'फिल्टर',
    totalBalance: 'एकूण शिल्लक',
    recentTransactions: 'अलीकडील व्यवहार',
    noCustomers: 'कोणतेही ग्राहक नाहीत',

    // Bills, Items, More
    bills: 'बिल्स',
    items: 'आयटम्स',
    more: 'अधिक',

    // Billing Screen
    monthlySales: 'मासिक विक्री',
    monthlyPurchases: 'मासिक खरेदी',
    todayIn: 'आजचे प्राप्त',
    todayOut: 'आजचे बाह्य',
    sale: 'विक्री',
    purchase: 'खरेदी',
    expense: 'खर्च',
    addBill: 'बिल जोडा',
    searchForTransactions: 'व्यवहार शोधा',
    noBillsAvailable: 'कोणतेही बिल उपलब्ध नाहीत',

    // Settings, Profile, Notifications
    settings: 'सेटिंग्ज',
    profile: 'प्रोफाइल',
    notifications: 'सूचना',
    language: 'भाषा',
    logout: 'लॉगआउट',
    updateProfile: 'प्रोफाइल अपडेट करा',
    changePassword: 'पासवर्ड बदलें',

    // Items Screen
    stockManagement: 'स्टॉक व्यवस्थापन',
    addProduct: 'उत्पादन जोडा',
    salePrice: 'विक्री किंमत',
    purchasePrice: 'खरेदी किंमत',
    openingStock: 'उद्घाटन स्टॉक',
    lowStockAlert: 'कमी स्टॉक अलर्ट',
    date: 'तारीख',
    stock: 'स्टॉक',
    inStockStatus: 'स्टॉक मध्ये', // Renamed from 'in'
    outOfStockStatus: 'स्टॉक नाही', // Renamed from 'out'
    increaseStock: 'स्टॉक वाढवा',
    decreaseStock: 'स्टॉक कमी करा',
    searchItems: 'आयटम शोधा', // Added this key
    viewItemsReports: 'अहवाल पाहा', // Renamed from 'viewReports'

    // More Screen
    aboutUs: 'आमच्याबद्दल',
    termsConditions: 'शर्ती आणि अटी',
    privacyPolicy: 'गोपनीयता धोरण',
    faq: 'वारंवार विचारलेले प्रश्न',
    support: 'समर्थन',
    contactUs: 'आमच्याशी संपर्क करा',

    // Add new address translations
    address: 'पत्ता',
    enterAddress: 'पत्ता टाका',
    addressRequired: 'पत्ता आवश्यक आहे',
    mobileNumber: 'मोबाइल नंबर',
    partyName: 'ग्राहक नाव',
    addParty: 'ग्राहक जोडा',
    phoneRequired: 'कृपया फोन नंबर प्रविष्ट करा',
    invalidPhone: 'मोबाइल नंबर वैध नाही',
    nameRequired: 'कृपया पक्षाचे नाव प्रविष्ट करा',



    //transaction detail screen
    'transactionDetails': 'व्यवहार तपशील',
    'youGave': 'तुम्ही दिले ₹',
    'youGot': 'तुम्हाला मिळाले ₹',
    'attachments': 'जोडपत्रे',
    'downloadPdf': 'पीडीएफ डाउनलोड करा',
    'makePayment': 'पैसे भरा',
    'sendReminder': 'स्मरणपत्र पाठवा',
    'sendMessage': 'संदेश पाठवा',
    'addNote': 'नोट जोडा',
    'enterAmount': 'रक्कम टाका',
    'enterDescription': 'वर्णन टाका',
    'attachBill': 'बिल जोडा',
    'selectDate': 'तारीख निवडा',
    'save': 'जतन करा',
    'cancel': 'रद्द करा',
    'Transactions:-': 'व्यवहार:-',

    selectContact: 'संपर्क निवडा',
    searchContacts: 'संपर्क शोधा',
    noContactsFound: 'कोणतेही संपर्क सापडले नाहीत',
    noPhoneNumber: 'फोन नंबर नाही',
    permissionDenied: 'संपर्क अॅक्सेस करण्यासाठी परवानगी नाकारली',

    //yougave screen
    youGaveTo: 'तुम्ही दिले ₹',
    youGot: 'तुम्हाला मिळाले ₹',

    enterDetails: 'तपशील टाका (वस्तू, बिल क्र., संख्या, इ.)',
    attachBills: 'बिल जोडा',

    pleaseEnterAmount: 'कृपया रक्कम टाका!',
    cameraPermissionDenied: 'कॅमेरा परवानगी नाकारली',
    //pdf screen
    generateInvoice: 'चलन तयार करा',
    supplierDetails: 'पुरवठादार तपशील',
    supplierName: 'पुरवठादाराचे नाव',
    supplierAddress: 'पुरवठादाराचा पत्ता',
    customerDetails: 'ग्राहक तपशील',
    customerName: 'ग्राहकाचे नाव',
    customerPhone: 'ग्राहक फोन',
    itemDetails: 'वस्तू तपशील',
    addItem: 'वस्तू जोडा',
    itemDescription: 'वस्तू वर्णन',
    quantity: 'संख्या',
    unitPrice: 'एकक किंमत',
    addedItems: 'जोडलेल्या वस्तू',
    price: 'किंमत',
    generatePdf: 'पीडीएफ तयार करा',
    pleaseEnter: 'कृपया प्रविष्ट करा',
    invoiceDescription: 'चलन वर्णन',
    //add item
    uploadPhoto: 'फोटो अपलोड करा',
    saveItem: 'वस्तू जतन करा',
    itemName: 'वस्तूचे नाव',
    camera_permission_required: 'कॅमेरा परवानगी आवश्यक आहे',
    please_fill_fields: 'कृपया सर्व आवश्यक माहिती भरा',
    enterItemName: 'वस्तूचे नाव टाका',
    capturePhoto: 'फोटो काढा',

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
