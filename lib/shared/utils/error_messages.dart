import 'package:grocery/core/api/app_exception.dart';

String mapErrorCode(String code) => switch (code) {
      'bad_request' => 'Проверьте введённые данные',
      'not_found' => 'Ресурс не найден',
      'conflict' => 'Уже существует',
      'forbidden' => 'Нет доступа',
      'otp_expired' => 'Код истёк — запросите новый',
      'otp_invalid' => 'Неверный код подтверждения',
      'invalid_credentials' => 'Неверный телефон или пароль',
      'internal' => 'Ошибка сервера — попробуйте позже',
      _ => 'Что-то пошло не так',
    };

String mapException(Object e) {
  if (e is AppException) {
    return e.when(
      network: () => 'Нет подключения к интернету',
      unauthorized: () => 'Сессия истекла. Войдите снова',
      server: (code, message, _) => mapErrorCode(code),
    );
  }
  return 'Что-то пошло не так';
}
