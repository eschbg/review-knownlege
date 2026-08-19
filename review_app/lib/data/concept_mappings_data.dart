import '../features/roadmap/domain/entities/concept_mapping.dart';

class ConceptMappingsData {
  static List<ConceptMapping> getMappings() {
    return const [
      ConceptMapping(
        id: 'map_1',
        topicName: 'Concurrency & Multi-Threading',
        flutterConcept: 'Event Loop & Isolates (Single-threaded event-driven with separate memory Isolates)',
        springConcept: 'Thread Pool & JVM Threads (Thread-per-request Servlet model with Shared Memory & Locks)',
        keyInsight: 'Tư duy debugging crash/jank trên Event Loop Flutter tương đồng 1-1 với tư duy debug Thread contention, Deadlock & ThreadPool Exhaustion trên Spring Boot. Chỉ khác là JVM dùng Shared Memory nên cần Synchronized/Locks, còn Flutter dùng Message Passing.',
        flutterSnippet: '''// Flutter: Offload heavy JSON parse to Isolate
final data = await compute(parseLargeJson, responseBody);''',
        springSnippet: '''// Spring: Execute async task with ThreadPoolTaskExecutor
@Async("taskExecutor")
public CompletableFuture<Data> processAsync() { ... }''',
      ),
      ConceptMapping(
        id: 'map_2',
        topicName: 'Authentication & Refresh Token Flow',
        flutterConcept: 'Dio QueuedInterceptor & Single Flight Completer Lock',
        springConcept: 'Spring Security Filter Chain & OAuth2 Token Coordinator',
        keyInsight: 'Vấn đề Refresh Token race condition xảy ra y hệt cả ở Client (nhiều API cùng bị 401) lẫn Server (nhiều client request cùng refresh token). Xử lý trên Client bằng Completer Lock cũng giống như Server áp dụng ConcurrentLock/Redis Lock.',
        flutterSnippet: '''// Flutter Dio Interceptor
if (response.statusCode == 401) {
  final newToken = await _tokenCoordinator.refreshToken();
  return dio.fetch(response.requestOptions..headers['Authorization'] = 'Bearer \$newToken');
}''',
        springSnippet: '''// Spring Security Filter
@Override
protected void doFilterInternal(HttpServletRequest req, ...) {
  String token = extractToken(req);
  if (token != null && jwtProvider.validate(token)) {
    SecurityContextHolder.getContext().setAuthentication(auth);
  }
}''',
      ),
      ConceptMapping(
        id: 'map_3',
        topicName: 'Database Schema & Migration',
        flutterConcept: 'Drift / SQLite Migration (onUpgrade v1 -> v2)',
        springConcept: 'Flyway / Liquibase Versioned Migration Scripts (V1__init.sql)',
        keyInsight: 'Kỷ luật kiểm tra migration trên Mobile từ tất cả các phiên bản app cũ còn tồn tại trên máy người dùng chính là tư duy viết Migration Scripts chuẩn có Rollback Plan trên Database Spring Backend.',
        flutterSnippet: '''// Drift Migration
@override
MigrationStrategy get migration => MigrationStrategy(
  onUpgrade: (m, from, to) async {
    if (from < 2) await m.addColumn(users, users.avatarUrl);
  },
);''',
        springSnippet: '''-- Flyway: V2__add_avatar_url.sql
ALTER TABLE users ADD COLUMN avatar_url VARCHAR(255);''',
      ),
      ConceptMapping(
        id: 'map_4',
        topicName: 'Reliability & Error Handling',
        flutterConcept: 'Typed Error Taxonomy & Retry with Exponential Backoff',
        springConcept: 'Resilience4j Circuit Breaker & Retry with Backoff',
        keyInsight: 'Ngăn chặn cascading failure trên Mobile bằng cách retry có backoff và cancel request thừa cũng tương đồng với việc bọc Resilience4j Circuit Breaker cho các service-to-service call ở phía Backend.',
        flutterSnippet: '''// Flutter Retry Policy
await retry(
  () => api.fetchData(),
  retryIf: (e) => e is SocketException,
  delayFactor: Duration(seconds: 1),
);''',
        springSnippet: '''// Spring Resilience4j
@CircuitBreaker(name = "backendService", fallbackMethod = "fallback")
@Retry(name = "backendService")
public Data callExternalService() { ... }''',
      ),
      ConceptMapping(
        id: 'map_5',
        topicName: 'Observability & Incident Debugging',
        flutterConcept: 'Flutter DevTools Timeline, Crashlytics & Non-Fatal Logs',
        springConcept: 'MDC Correlation ID, OpenTelemetry Tracing & Micrometer RED Metrics',
        keyInsight: 'Mobile Dev có kỷ luật theo dõi Crash-Free Users (>99.5%) và ANR rate. Sang Backend, kỷ luật này chuyển thành SLA/SLO, RED Metrics (Rate, Errors, Duration) và Correlation ID truyền xuyên qua các Microservices.',
        flutterSnippet: '''// Flutter Structured Logging
FirebaseCrashlytics.instance.recordError(error, stack, reason: 'Payment Failure');''',
        springSnippet: '''// Spring MDC Correlation ID Logging
MDC.put("correlationId", request.getHeader("X-Correlation-ID"));
log.error("Payment failed for order: {}", orderId);''',
      ),
    ];
  }
}
