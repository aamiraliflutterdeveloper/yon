import 'package:app/application/core/exceptions/exception.dart';
import 'package:app/application/core/failure/failure.dart';
import 'package:app/common/logger/log.dart';
import 'package:dio/dio.dart';

Exception getException(DioError e) {
  if (e.type == DioErrorType.response) {
    d('This is error message: ' + e.response!.data['response']['message'].toString());
    return ResponseException(msg: e.response!.data['response']['message'].toString() /*'${e.response.statusMessage}\n${_handleError(e.response.statusCode)}'*/);
  } else if (e.type == DioErrorType.connectTimeout) {
    return ConnectTimeoutException();
  } else if (e.type == DioErrorType.receiveTimeout) {
    return ReceiveTimeoutException();
  } else if (e.type == DioErrorType.sendTimeout) {
    return SendTimeoutException();
  } else if (e.type == DioErrorType.other) {
    return OtherException();
  } else {
    return DefaultException();
  }
}

// String _handleError(int statusCode) {
//   switch (statusCode) {
//     case 400:
//       return 'You sent an invalid request, such as lacking required request parameter';
//     case 401:
//       return 'Failed to authenticate with the server';
//     case 403:
//       return 'You don\'t have permission to access the requested resource';
//     case 404:
//       return 'Requested resource does not exist';
//     case 500:
//       return 'Internal server error';
//     case 503:
//       return 'Requested service is not available';
//     default:
//       return 'Oops something went wrong';
//   }
// }


Failure getFailure(Exception e) {
  if (e.runtimeType == ResponseException) {
    return ResponseFailure(msg: (e as ResponseException).msg);
  } else if (e.runtimeType == ConnectTimeoutException) {
    return ConnectTimeoutFailure();
  } else if (e.runtimeType == ReceiveTimeoutException) {
    return ReceiveTimeoutFailure();
  } else if (e.runtimeType == SendTimeoutException) {
    return SendTimeoutFailure();
  } else if (e.runtimeType == OtherException) {
    return OtherFailure();
  } else {
    return DefaultFailure();
  }
}

class ErrorMessage implements Failure {
  ErrorMessage.fromError(Failure failure) {
    switch (failure.runtimeType) {
      case ConnectTimeoutFailure:
        message = "Connection timeout with API server";
        break;
      case ReceiveTimeoutFailure:
        message = "Receive timeout in connection with API server";
        break;
      case ResponseFailure:
        message = (failure as ResponseFailure).msg;
        break;
      case SendTimeoutFailure:
        message = "Send timeout in connection with API server";
        break;
      case OtherFailure:
        message = "Check your internet connection";
        break;
      case DefaultFailure:
      default:
        message = "Something went wrong maybe your internet connection is not stable";
        break;
    }
  }
  String? message;
  @override
  String toString() => message!;
}

/*class ErrorMessage implements Failure {
  ErrorMessage.fromError(Failure failure) {
    switch (failure.runtimeType) {
      case ConnectTimeoutFailure:
        message = "Connection timeout with API server";
        break;
      case ReceiveTimeoutFailure:
        message = "Receive timeout in connection with API server";
        break;
      case ResponseFailure:
        message = (failure as ResponseFailure).msg;
        break;
      case SendTimeoutFailure:
        message = "Send timeout in connection with API server";
        break;
      case OtherFailure:
        message = "Check your internet connection";
        break;
      case DefaultFailure:
      default:
        message = "Something went wrong maybe your internet connection is not stable";
        break;
    }
  }

  String message;

  @override
  String toString() => message;
}*/




// Exception getException(DioError e) {
//   if (e.type == DioErrorType.response) {
//     return ResponseException(msg: '${_handleError(e.response?.statusCode)}.\n ${e.response?.data['message']}');
//   } else if (e.type == DioErrorType.connectTimeout) {
//     return ConnectTimeoutException();
//   } else if (e.type == DioErrorType.receiveTimeout) {
//     return ReceiveTimeoutException();
//   } else if (e.type == DioErrorType.sendTimeout) {
//     return SendTimeoutException();
//   } else if (e.type == DioErrorType.other) {
//     return OtherException();
//   } else {
//     return DefaultException();
//   }
// }
//
// String _handleError(int? statusCode) {
//   switch (statusCode) {
//     case 400:
//       return 'You sent an invalid request, such as lacking required request parameter';
//     case 401:
//       return 'Failed to authenticate with the server';
//     case 403:
//       return 'You don\'t have permission to access the requested resource';
//     case 404:
//       return 'Requested resource does not exist';
//     case 500:
//       return 'Internal server error';
//     case 503:
//       return 'Requested service is not available';
//     default:
//       return 'Oops something went wrong';
//   }
// }
//
// Failure getFailure(Exception e) {
//   if (e.runtimeType == ResponseException) {
//     return ResponseFailure(msg: (e as ResponseException).msg);
//   } else if (e.runtimeType == ConnectTimeoutException) {
//     return ConnectTimeoutFailure();
//   } else if (e.runtimeType == ReceiveTimeoutException) {
//     return ReceiveTimeoutFailure();
//   } else if (e.runtimeType == SendTimeoutException) {
//     return SendTimeoutFailure();
//   } else if (e.runtimeType == OtherException) {
//     return OtherFailure();
//   } else {
//     return DefaultFailure();
//   }
// }
//
// class ErrorMessage implements Failure {
//   ErrorMessage.fromError(Failure failure) {
//     switch (failure.runtimeType) {
//       case ConnectTimeoutFailure:
//         message = "Connection timeout with API server";
//         break;
//       case ReceiveTimeoutFailure:
//         message = "Receive timeout in connection with API server";
//         break;
//       case ResponseFailure:
//         message = (failure as ResponseFailure).msg;
//         break;
//       case SendTimeoutFailure:
//         message = "Send timeout in connection with API server";
//         break;
//       case OtherFailure:
//         message = "Check your internet connection";
//         break;
//       case DefaultFailure:
//       default:
//         message = "Something went wrong maybe your internet connection is not stable";
//         break;
//     }
//   }
//   String? message;
//   @override
//   String toString() => message!;
// }
