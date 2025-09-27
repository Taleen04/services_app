/// BaseUseCase
/// 
/// هذه الفئة الأساسية لجميع UseCases في التطبيق
/// وتوفر بنية عامة لتنفيذ UseCases مع معالجة الأخطاء
abstract class BaseUseCase<Params, Result> {
  /// تنفيذ الـ UseCase
  /// 
  /// [params] - المعلمات المطلوبة لتنفيذ الـ UseCase
  /// 
  /// ترجع [Result] النتيجة بعد تنفيذ الـ UseCase
  Future<Result> call(Params params);
}

/// UseCase بدون معلمات
/// 
/// هذه الفئة الأساسية لجميع UseCases التي لا تتطلب معلمات
abstract class NoParamsUseCase<Result> {
  /// تنفيذ الـ UseCase
  /// 
  /// ترجع [Result] النتيجة بعد تنفيذ الـ UseCase
  Future<Result> call();
}
