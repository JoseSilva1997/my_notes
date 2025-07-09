class LogUtil {
  static final LogUtil _instance = LogUtil._internal();

  factory LogUtil() {
    return _instance;
  }

  LogUtil._internal();

  void log(String message) {
    // Here you can implement your logging logic, e.g., print to console or write to a file
    print('[MYAPP] $message');
  }
}