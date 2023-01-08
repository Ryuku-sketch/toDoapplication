
import 'package:logger/logger.dart';

class LoggerManager extends Logger {

  // Singleton Structure to keep cache usage limited
  static final LoggerManager _instance = LoggerManager._internal();
  factory LoggerManager(){
    return _instance;
  }
  LoggerManager._internal();



  
}

