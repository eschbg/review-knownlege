"use client";

import { useEffect, useMemo, useRef, useState } from "react";

type Category = "Mobile" | "Backend" | "Owner" | "Product";
type Week = {
  title: string;
  phase: string;
  category: Category;
  focus: string;
  topics: string[];
  exercise: string;
  deliverables: string[];
};

const weeks: Week[] = [
  {
    title: "Mobile foundations",
    phase: "Nền tảng",
    category: "Mobile",
    focus: "Hiểu lifecycle, rendering và state thay vì chỉ biết dùng framework.",
    topics: ["Flutter rendering: Widget, Element, RenderObject", "Lifecycle, navigation và process death", "Coroutine, Flow, StateFlow và WorkManager", "Loading, empty, error, refresh và cache local"],
    exercise: "Xây màn danh sách đơn hàng có pagination, refresh, debounce, filter, retry và phục hồi sau process death.",
    deliverables: ["Sơ đồ lifecycle", "State model màn hình", "2 câu chuyện STAR Mobile"],
  },
  {
    title: "Architecture & code quality",
    phase: "Nền tảng",
    category: "Mobile",
    focus: "Ra quyết định kiến trúc dựa trên team, coupling và tốc độ thay đổi.",
    topics: ["Layered và feature-first architecture", "Repository, use case và model mapping", "Dependency injection và error mapping", "Testing strategy, logging và code review"],
    exercise: "Viết technical design cho feature Tạo đơn hàng: flow, API, cache, idempotency, analytics và rollout.",
    deliverables: ["Technical design", "Architecture Decision Record", "Mobile review checklist"],
  },
  {
    title: "Mobile performance",
    phase: "Mobile production",
    category: "Mobile",
    focus: "Đo → phân tích → giả thuyết → tối ưu → đo lại.",
    topics: ["Rebuild scope, virtualization và nested scroll", "Image decode, layout, animation và saveLayer", "Main-thread blocking, cold start và ANR", "Memory leak, duplicate collection và JSON parsing"],
    exercise: "Benchmark màn hình 5.000–10.000 bản ghi; đo initial render, p95 frame, memory, search và số request.",
    deliverables: ["Performance report before/after", "Danh sách bottleneck đã loại trừ", "2 STAR về performance"],
  },
  {
    title: "Mobile release & production",
    phase: "Mobile production",
    category: "Mobile",
    focus: "Phát hành an toàn, quan sát được và có đường rollback.",
    topics: ["Flavor, signing, versioning và CI/CD", "Feature flag, remote config và staged rollout", "Crashlytics, ANR, R8 và symbol upload", "Deep link, push notification và native SDK"],
    exercise: "Xử lý release tăng ANR, deep link cold start, cache chéo tài khoản và enum mới làm app cũ lỗi.",
    deliverables: ["Release checklist", "Postmortem giả lập", "Version compatibility matrix"],
  },
  {
    title: "Spring Boot & API design",
    phase: "Backend",
    category: "Backend",
    focus: "Ownership một API từ contract đến validation và compatibility.",
    topics: ["IoC, DI, bean lifecycle và Spring proxy", "Controller, service, repository và DTO", "Validation, exception handling và error code", "Pagination, idempotency, versioning và correlation ID"],
    exercise: "Triển khai API orders có validation, authorization, pagination, request ID và tests.",
    deliverables: ["OpenAPI contract", "Error response convention", "API design checklist"],
  },
  {
    title: "JPA, transaction & concurrency",
    phase: "Backend",
    category: "Backend",
    focus: "Đặt transaction boundary đúng và chống cập nhật/submit trùng.",
    topics: ["Persistence context, dirty checking và flush", "Lazy loading, N+1, projection và fetch join", "Optimistic/pessimistic lock và isolation", "Transactional proxy, self-invocation và retry có giới hạn"],
    exercise: "Đo và sửa N+1; mô phỏng hai request cập nhật cùng order; chống duplicate order nhiều lớp.",
    deliverables: ["Transaction sequence diagram", "N+1 report", "Concurrency test"],
  },
  {
    title: "Oracle, SQL & migration",
    phase: "Backend",
    category: "Backend",
    focus: "Thay đổi dữ liệu an toàn trên hệ thống đang chạy.",
    topics: ["Join, CTE, window function và pagination", "Index, cardinality và execution plan", "Lock, deadlock, connection pool và batch", "Expand–migrate–contract, backfill và forward-fix"],
    exercise: "Đổi full_name thành display_name qua nhiều release mà không downtime.",
    deliverables: ["3 migration scripts", "Forward-fix plan", "Query tuning report"],
  },
  {
    title: "Observability & debugging",
    phase: "Production end-to-end",
    category: "Backend",
    focus: "Theo dấu một hành động từ Mobile đến Database bằng evidence.",
    topics: ["Structured logging và correlation ID", "Metrics, tracing, p50/p95/p99 và error rate", "DB pool, thread pool và dependency latency", "Mobile crash, network log và incident timeline"],
    exercise: "Điều tra API chậm qua Mobile timing, payload, Backend latency, query count và execution plan.",
    deliverables: ["Observability dashboard", "Incident timeline", "Root cause analysis"],
  },
  {
    title: "Reliability & distributed workflow",
    phase: "Production end-to-end",
    category: "Backend",
    focus: "Thiết kế failure path trước khi production bắt buộc phải dạy mình.",
    topics: ["Retry, timeout, backoff và circuit breaker", "Idempotency, outbox và eventual consistency", "Saga, state machine và dead-letter handling", "Callback trùng, reconciliation và payment integration"],
    exercise: "Thiết kế payment flow chịu được timeout, callback trùng/đảo thứ tự và giao dịch treo.",
    deliverables: ["Payment state machine", "Failure scenario table", "Duplicate payment postmortem"],
  },
  {
    title: "Quản lý 2–3 workstream",
    phase: "Technical Owner",
    category: "Owner",
    focus: "Quản lý outcome, dependency và risk — không quản lý số lượng ticket.",
    topics: ["MVP scope, risk-based estimate và WIP limit", "Dependency map, risk register và roadmap", "Delegation, escalation và stakeholder communication", "Decision log, technical debt và incident ownership"],
    exercise: "Lập dashboard cho Mobile Core, Backend Payment và Platform Analytics với outcome, risk và next action.",
    deliverables: ["Project dashboard", "Roadmap 6 tuần", "Weekly status report"],
  },
  {
    title: "Design review & technical leadership",
    phase: "Technical Owner",
    category: "Owner",
    focus: "Review problem, failure mode và vận hành — không dừng ở syntax.",
    topics: ["Problem, scope và source of truth", "Backward compatibility và observability", "Feature flag, migration và rollback", "Capacity, data growth và phương án đơn giản hơn"],
    exercise: "Review đề xuất microservice, event-driven, offline sync, realtime và shared core bằng value/cost/risk.",
    deliverables: ["Technical proposal", "Design review checklist", "Decision log"],
  },
  {
    title: "Product thinking & tổng kết",
    phase: "Product",
    category: "Product",
    focus: "Nối quyết định kỹ thuật với thay đổi hành vi và metric sản phẩm.",
    topics: ["Problem → hypothesis → solution → metric", "Activation, funnel, drop-off và retention", "Feature adoption và time-to-complete", "Crash-free, ANR, API error và p95 screen load"],
    exercise: "Lập funnel tạo đơn, tìm điểm rời bỏ và chọn cải tiến kỹ thuật có tác động sản phẩm lớn nhất.",
    deliverables: ["Product brief", "Funnel analysis", "Tổng kết 12 tuần"],
  },
];

type StudyGuide = {
  theory: string[];
  scenarios: string[];
  practices: string[];
  performance: string[];
  resources: { label: string; url: string }[];
};

const studyGuides: StudyGuide[] = [
  {
    theory: [
      "Flutter giữ 3 cây Widget → Element → RenderObject: Widget mô tả cấu hình, Element giữ vị trí/lifecycle, RenderObject thực hiện layout và paint.",
      "State phải có owner rõ ràng; UI là hàm của immutable state. Phân biệt state có thể phục hồi, state tạm thời và event một lần.",
      "Coroutine dùng structured concurrency; StateFlow giữ state hiện tại, SharedFlow phù hợp broadcast, cold Flow chỉ chạy khi được collect.",
    ],
    scenarios: [
      "Màn hình rebuild làm gọi API nhiều lần vì side effect nằm trong build/render thay vì lifecycle hoặc state holder.",
      "Hệ điều hành kill process khi user đang nhập form; quay lại app thì dữ liệu và navigation state bị mất.",
      "User logout rồi đăng nhập tài khoản khác nhưng repository trả cache của tài khoản cũ.",
    ],
    practices: [
      "Đặt side effect ngoài hàm render; state holder là single source of truth và expose state bất biến.",
      "Collect Flow theo lifecycle; hủy timer, controller, stream và coroutine đúng scope.",
      "Cache key phải gồm identity và filter; xóa dữ liệu nhạy cảm khi session thay đổi.",
    ],
    performance: [
      "Giữ frame dưới ngân sách thiết bị; thu hẹp rebuild/recomposition thay vì tối ưu toàn màn hình.",
      "Dùng lazy list/virtualization và stable key; tránh nested scroll cùng hướng không có constraint.",
      "Chỉ đưa CPU-heavy work sang isolate/dispatcher nền; async I/O không tự động đồng nghĩa background thread.",
    ],
    resources: [
      { label: "Flutter performance", url: "https://docs.flutter.dev/perf/best-practices" },
      { label: "Android app architecture", url: "https://developer.android.com/topic/architecture" },
    ],
  },
  {
    theory: [
      "Architecture là cách đặt boundary và dependency; Clean Architecture không bắt buộc số layer cố định.",
      "DTO mô tả contract bên ngoài, domain model giữ invariant, UI model tối ưu cho rendering và interaction.",
      "Repository che nguồn dữ liệu và giữ consistency policy; use case chỉ đáng có khi chứa business rule hoặc tái sử dụng flow.",
    ],
    scenarios: [
      "API đổi field/enum khiến DTO được dùng trực tiếp trong UI làm nhiều màn hình vỡ cùng lúc.",
      "Một shared module lớn tạo coupling: thay đổi feature A buộc build/test/release feature B.",
      "Network và cache trả kết quả đảo thứ tự khiến dữ liệu cũ ghi đè dữ liệu mới.",
    ],
    practices: [
      "Bắt đầu bằng UI + data layer; chỉ thêm domain layer khi complexity thực sự xuất hiện.",
      "Mapping tại boundary có biến động; error được chuẩn hóa thành loại mà UI có thể xử lý.",
      "Module theo feature và ownership; dependency đi vào abstraction ổn định, không vòng lặp.",
    ],
    performance: [
      "Không tạo abstraction/mapping trên hot path nếu không mang lại isolation; đo allocation trước khi tối ưu.",
      "Trì hoãn dependency initialization không cần cho first screen để giảm startup time.",
      "Thiết kế query/cache API theo nhu cầu màn hình, tránh tải object graph lớn rồi lọc ở UI.",
    ],
    resources: [
      { label: "Flutter app architecture", url: "https://docs.flutter.dev/app-architecture" },
      { label: "Android architecture recommendations", url: "https://developer.android.com/topic/architecture/recommendations" },
    ],
  },
  {
    theory: [
      "Pipeline khung hình gồm build/layout/paint/raster; bottleneck ở bước nào quyết định cách sửa.",
      "p50 mô tả trải nghiệm điển hình, p95/p99 phơi bày tail latency và nhóm user gặp trải nghiệm tệ.",
      "Memory leak là object còn reachable ngoài lifetime mong muốn; memory pressure còn đến từ allocation churn và image decode.",
    ],
    scenarios: [
      "Danh sách 10.000 bản ghi giật vì render toàn bộ, sort/filter đồng bộ và decode ảnh kích thước gốc.",
      "Search debounce đúng nhưng response cũ đến sau và ghi đè kết quả query mới.",
      "Màn hình đóng nhưng subscription/timer còn giữ ViewModel/State, làm memory tăng sau mỗi lần mở.",
    ],
    practices: [
      "Profile trên release/profile build; lưu baseline, giả thuyết và số đo before/after.",
      "Tối ưu hotspot đã chứng minh bằng trace; mỗi thay đổi chỉ giải quyết một bottleneck để đo được tác động.",
      "Hủy request cũ hoặc gắn sequence/query key; resize/cache ảnh theo kích thước hiển thị.",
    ],
    performance: [
      "Theo dõi frame time, jank rate, startup, memory peak, GC, request count và time-to-result.",
      "Flutter: hạn chế saveLayer, opacity/clipping và intrinsic layout; Android: dùng Macrobenchmark/Baseline Profile cho critical journey.",
      "A/B trên cùng môi trường và dữ liệu; không kết luận bằng cảm giác “mượt hơn”.",
    ],
    resources: [
      { label: "Flutter performance best practices", url: "https://docs.flutter.dev/perf/best-practices" },
      { label: "Android performance measurement", url: "https://developer.android.com/topic/performance/measuring-performance" },
    ],
  },
  {
    theory: [
      "Build variant/flavor tách config; signing xác nhận nguồn phát hành; version code điều khiển upgrade path.",
      "Feature flag tách deploy khỏi release; staged rollout giới hạn blast radius và tạo thời gian quan sát.",
      "Backward compatibility là contract giữa nhiều phiên bản app đang cùng tồn tại với backend mới.",
    ],
    scenarios: [
      "Release mới chỉ crash trên ABI hoặc dòng máy cụ thể; debug build không tái hiện.",
      "Deep link cold start mở sai màn hình vì auth/session/navigation chưa khởi tạo xong.",
      "Backend thêm enum hoặc đổi nullable field khiến phiên bản app cũ parse thất bại.",
    ],
    practices: [
      "Release checklist tự động hóa signing, symbol/mapping upload, smoke test và compatibility test.",
      "Rollout theo cohort nhỏ, đặt guardrail crash-free/ANR và chuẩn bị kill switch trước release.",
      "Client parse tolerant nhưng không nuốt lỗi; backend dùng additive change và giữ contract qua cửa sổ hỗ trợ.",
    ],
    performance: [
      "So sánh startup, frame/jank, memory và binary size giữa release hiện tại với candidate.",
      "Đo production theo app version/device/OS để tránh average che mất regression theo cohort.",
      "Không khởi tạo mọi SDK ở startup; lazy init theo critical path và nhu cầu consent.",
    ],
    resources: [
      { label: "Android app performance", url: "https://developer.android.com/topic/performance/overview" },
      { label: "Flutter deployment", url: "https://docs.flutter.dev/deployment" },
    ],
  },
  {
    theory: [
      "IoC container quản lý object graph; constructor injection làm dependency bắt buộc, rõ và test được.",
      "Controller là HTTP boundary, service giữ unit of work/business rule, repository phụ trách persistence query.",
      "Idempotency bảo đảm retry cùng intent không tạo thêm side effect; correlation ID nối một request qua nhiều lớp.",
    ],
    scenarios: [
      "Mobile retry POST sau timeout; request đầu đã tạo order nhưng response bị mất, dẫn tới order trùng.",
      "Một API trả stack trace/internal exception hoặc status 200 kèm error body làm client xử lý sai.",
      "Pagination offset bị trùng/thiếu item khi dữ liệu thay đổi liên tục trong lúc user cuộn.",
    ],
    practices: [
      "Validate ở trust boundary; error response ổn định gồm code, message an toàn và correlation ID.",
      "Đặt idempotency key + unique constraint + transaction; không chỉ disable nút ở client.",
      "Contract-first cho flow nhiều client; thêm field tương thích và có consumer test cho app cũ.",
    ],
    performance: [
      "Giới hạn page size/payload; dùng projection thay vì serialize entity graph.",
      "Đo p50/p95/p99 theo endpoint và error code; tách DB, serialization và external latency.",
      "Không log body/token mặc định; structured log có sampling để tránh I/O và chi phí quá mức.",
    ],
    resources: [
      { label: "Spring MVC controllers", url: "https://docs.spring.io/spring-framework/reference/web/webmvc/mvc-controller.html" },
      { label: "Spring validation", url: "https://docs.spring.io/spring-framework/reference/core/validation/beanvalidation.html" },
    ],
  },
  {
    theory: [
      "Persistence context là identity map/unit of work; dirty checking phát hiện thay đổi và flush SQL trước/đúng lúc commit.",
      "Transaction logical khác physical; propagation, isolation và rollback rule quyết định consistency thực tế.",
      "Optimistic lock phát hiện xung đột bằng version; pessimistic lock chặn trước nhưng tăng contention/deadlock risk.",
    ],
    scenarios: [
      "Danh sách orders truy cập customer lazy trong loop tạo N+1 query.",
      "Hai request cùng đọc version rồi cập nhật status; request sau ghi đè kết quả request trước.",
      "@Transactional không hoạt động vì self-invocation không đi qua proxy hoặc exception đã bị catch.",
    ],
    practices: [
      "Đặt transaction boundary tại service/unit of work; giữ transaction ngắn và không gọi remote chậm bên trong.",
      "Dùng projection/fetch plan theo use case; không đổi toàn bộ association sang eager để chữa N+1.",
      "Conflict trả lỗi có ý nghĩa; retry chỉ cho operation idempotent và có giới hạn/backoff.",
    ],
    performance: [
      "Đếm query và rows đọc trên critical endpoint; kiểm tra plan thay vì chỉ nhìn latency tổng.",
      "Read-only transaction có thể là optimization hint; vẫn phải xác minh behavior của driver/provider.",
      "Theo dõi lock wait, deadlock, connection pool saturation và thời gian transaction.",
    ],
    resources: [
      { label: "Spring transaction management", url: "https://docs.spring.io/spring-framework/reference/data-access/transaction.html" },
      { label: "Spring Data JPA transactions", url: "https://docs.spring.io/spring-data/jpa/reference/jpa/transactions.html" },
    ],
  },
  {
    theory: [
      "Optimizer chọn execution plan theo statistics/cardinality/cost; index không tự động làm query nhanh hơn.",
      "Composite index hiệu quả phụ thuộc thứ tự cột, selectivity và predicate; constraint bảo vệ invariant ở lớp cuối.",
      "Expand–migrate–contract tách schema change phá vỡ thành nhiều release tương thích ngược.",
    ],
    scenarios: [
      "Query nhanh staging nhưng full table scan production vì data distribution và statistics khác.",
      "Migration thêm NOT NULL/default trên bảng lớn giữ lock lâu và chặn traffic.",
      "Offset pagination càng sâu càng chậm và dễ trùng/thiếu khi record được insert liên tục.",
    ],
    practices: [
      "Đọc actual/cursor plan và row estimate; benchmark bằng dữ liệu gần production.",
      "Tạo index theo workload thật, kiểm tra write overhead và unused index trước khi giữ.",
      "Schema change additive, backfill theo batch có checkpoint; xóa cột ở release sau khi mọi consumer đã chuyển.",
    ],
    performance: [
      "Theo dõi logical/physical reads, rows, elapsed/CPU, plan hash và lock wait.",
      "Dùng keyset pagination cho deep page khi business flow cho phép.",
      "Batch insert/update có kích thước kiểm soát; pool size dựa trên DB capacity chứ không theo số request web.",
    ],
    resources: [
      { label: "Oracle SQL Tuning Guide", url: "https://docs.oracle.com/en/database/oracle/oracle-database/19/tgsql/" },
    ],
  },
  {
    theory: [
      "Metrics cho xu hướng/tổng hợp, logs cho event chi tiết, traces nối lifecycle của request qua service.",
      "Correlation/context propagation phải đi xuyên Mobile → Gateway → Backend → DB/external dependency.",
      "SLI đo behavior người dùng quan tâm; SLO đặt target, alert nên dựa vào triệu chứng và burn rate.",
    ],
    scenarios: [
      "User báo màn hình chậm nhưng backend average latency bình thường; p99 hoặc client/network mới là bottleneck.",
      "Log mỗi service có ID khác nhau nên không dựng được timeline cho một giao dịch lỗi.",
      "Metric gắn userId/orderId tạo cardinality cực cao, làm hệ thống quan sát tốn kém hoặc quá tải.",
    ],
    practices: [
      "Structured log có timestamp, severity, service, version và correlation ID; redaction dữ liệu nhạy cảm.",
      "Dùng semantic convention và propagate context; sample trace có chủ đích nhưng giữ error/slow trace.",
      "Dashboard bắt đầu từ user journey/SLI, sau đó drill down dependency và resource saturation.",
    ],
    performance: [
      "Histogram cho latency distribution; luôn xem tail latency cùng throughput và error rate.",
      "Giới hạn metric label cardinality; sampling/export batch để telemetry không trở thành bottleneck.",
      "Đo instrumentation overhead và tránh trace span cho method quá nhỏ/hot loop.",
    ],
    resources: [
      { label: "OpenTelemetry concepts", url: "https://opentelemetry.io/docs/concepts/" },
      { label: "OpenTelemetry signals", url: "https://opentelemetry.io/docs/concepts/signals/" },
    ],
  },
  {
    theory: [
      "Timeout giới hạn thời gian chờ; retry xử lý lỗi tạm thời; circuit breaker ngăn dependency lỗi kéo sập caller.",
      "At-least-once delivery đồng nghĩa consumer phải idempotent; outbox nối DB transaction với event publishing.",
      "Saga/state machine mô hình hóa nhiều bước và compensation; eventual consistency cần reconciliation.",
    ],
    scenarios: [
      "Payment provider đã charge nhưng API timeout; client retry tạo giao dịch thứ hai.",
      "Callback đến trước response, đến nhiều lần hoặc đến sau khi order đã bị hủy.",
      "Retry đồng loạt không jitter gây retry storm khi dependency vừa phục hồi.",
    ],
    practices: [
      "Mọi side effect có idempotency key/invariant ở DB; lưu provider reference và trạng thái chuyển hợp lệ.",
      "Timeout theo budget end-to-end; retry có exponential backoff + jitter và chỉ cho lỗi được phân loại.",
      "Reconciliation job có checkpoint, audit trail và manual recovery path cho giao dịch treo.",
    ],
    performance: [
      "Theo dõi retry rate, circuit state, queue lag, reconciliation age và duplicate suppression count.",
      "Backpressure/queue limit bảo vệ memory và dependency; load shedding ưu tiên request quan trọng.",
      "Không giữ DB transaction trong network call; tách state transition ngắn và publish qua outbox.",
    ],
    resources: [
      { label: "Spring Cloud CircuitBreaker", url: "https://docs.spring.io/spring-cloud-circuitbreaker/reference/" },
      { label: "OpenTelemetry reliability primer", url: "https://opentelemetry.io/docs/concepts/observability-primer/" },
    ],
  },
  {
    theory: [
      "Outcome mô tả giá trị/kết quả, output là thứ được giao; dependency và risk quyết định sequencing.",
      "WIP limit giảm context switching và làm blocker lộ rõ; critical path quyết định ngày hoàn thành thật.",
      "Risk = probability × impact; mitigation giảm khả năng/tác động, contingency kích hoạt khi risk xảy ra.",
    ],
    scenarios: [
      "Mobile và Backend cùng cần release gấp nhưng API contract chưa chốt và QA capacity có hạn.",
      "Requirement đổi giữa sprint; team tiếp tục làm toàn scope cũ và trễ outcome quan trọng.",
      "Production incident xảy ra trong lúc 3 workstream đều đang có task critical.",
    ],
    practices: [
      "Mỗi workstream có outcome tuần, owner, next action, dependency và top risk — không chỉ danh sách ticket.",
      "Giữ 1 implementation chính + 1 việc chờ/review + 1 maintenance nhỏ; escalate bằng impact và evidence.",
      "Dành buffer cho incident/review; cắt scope theo user value và reversibility trước khi thêm người.",
    ],
    performance: [
      "Theo dõi lead time, blocked time, review latency và rework; tránh dùng story point như performance cá nhân.",
      "Giảm meeting/status overhead bằng dashboard async có decision log và owner rõ.",
      "Ưu tiên bottleneck của flow delivery thay vì tối ưu utilization từng người.",
    ],
    resources: [
      { label: "Google SRE — Managing incidents", url: "https://sre.google/sre-book/managing-incidents/" },
    ],
  },
  {
    theory: [
      "Design review bắt đầu từ problem, constraints và success metric; solution chỉ là giả thuyết để đạt outcome.",
      "Reversibility quyết định mức review: quyết định khó đảo cần evidence, rollout và failure analysis sâu hơn.",
      "Failure mode gồm trigger, impact, detection, mitigation và prevention; rollback khác forward-fix.",
    ],
    scenarios: [
      "Team đề xuất microservice/event-driven nhưng workload nhỏ, ownership chưa rõ và vận hành còn thủ công.",
      "Refactor lớn sát deadline không có metric, migration path hoặc cách rollback.",
      "Thiết kế chạy đúng happy path nhưng không có compatibility, observability hay recovery cho partial failure.",
    ],
    practices: [
      "Proposal ghi problem/non-goals, options, trade-off, failure mode, data migration, rollout và verification.",
      "Chọn phương án đơn giản nhất đáp ứng constraint hiện tại; ghi rõ điều kiện kích hoạt kiến trúc phức tạp hơn.",
      "Review API/data/operation cùng code; decision log lưu lý do và thời điểm cần xem xét lại.",
    ],
    performance: [
      "Đặt performance budget/SLO trước thiết kế; capacity model dùng workload và growth assumption rõ.",
      "Load test critical path với data shape thực; tránh benchmark component tách rời rồi suy diễn end-to-end.",
      "Thiết kế graceful degradation và backpressure trước khi scale bằng hạ tầng.",
    ],
    resources: [
      { label: "Google SRE — Postmortem culture", url: "https://sre.google/sre-book/postmortem-culture/" },
    ],
  },
  {
    theory: [
      "Chuỗi sản phẩm: problem → hypothesis → solution → behavior change → metric → learning.",
      "Funnel đo conversion theo bước; retention/cohort đo giá trị quay lại; guardrail bảo vệ quality khi tối ưu metric chính.",
      "Technical metric là leading/diagnostic signal; product metric xác nhận người dùng có nhận giá trị hay không.",
    ],
    scenarios: [
      "Team tối ưu p95 search nhưng user vẫn không tìm được order vì filter/status model sai nhu cầu.",
      "Conversion tăng nhưng crash/duplicate order cũng tăng do bỏ validation để giảm friction.",
      "Feature adoption thấp; chưa biết do discoverability, latency, trust hay feature không giải quyết problem.",
    ],
    practices: [
      "Định nghĩa event/property trước build, có owner và data quality check; không log dữ liệu nhạy cảm.",
      "Mỗi experiment có hypothesis, primary metric, guardrail, segment và ngưỡng quyết định trước khi xem kết quả.",
      "Phân tích drop-off cùng evidence định tính; cắt scope hoặc bỏ feature khi learning không ủng hộ.",
    ],
    performance: [
      "Nối screen/API p95 với task completion và drop-off theo cohort, không tối ưu latency tách khỏi outcome.",
      "Theo dõi crash-free, ANR, error rate và stale-data rate làm guardrail cho conversion.",
      "Ưu tiên critical user journey; performance budget theo trải nghiệm thực và network/device tier.",
    ],
    resources: [
      { label: "Google Analytics events", url: "https://developers.google.com/analytics/devguides/collection/ga4/events" },
      { label: "OpenTelemetry metrics", url: "https://opentelemetry.io/docs/concepts/signals/metrics/" },
    ],
  },
];

const coreEssentials = [
  ["Tách core chung khỏi stack: lifecycle, state, async và rendering; sau đó học riêng Flutter/Dart hoặc Android/Kotlin.", "Dart/Kotlin core: null safety, collection, equality, exception, event loop/coroutine cancellation.", "Mobile platform: layout constraints, navigation, process death, networking, offline cache và secure storage.", "Accessibility, unit/widget/integration test và resource cleanup là yêu cầu production, không phải phần phụ."],
  ["Coupling, cohesion, dependency direction và source of truth là tiêu chí chọn architecture.", "SOLID là công cụ nhận diện trách nhiệm và điểm thay đổi, không phải mục tiêu tạo nhiều layer.", "Phân biệt unit, integration, contract và end-to-end test; ưu tiên test tại boundary rủi ro.", "Mọi dependency phải có owner, lifecycle và failure behavior rõ ràng."],
  ["Hiểu pipeline build → layout → paint → raster và ngân sách frame theo refresh rate.", "Đo startup, p95 frame, jank, memory, GC, request count và time-to-result trên profile/release build.", "Phân biệt CPU-bound, I/O-bound, allocation churn và memory leak trước khi chọn cách tối ưu.", "Thiết lập performance budget và regression check cho critical journey."],
  ["Nắm build variant, signing, version compatibility và staged rollout.", "Thiết kế auth/token lifecycle, secure storage, PII redaction và SDK consent trước release.", "CI phải kiểm tra test, size, symbol/mapping upload và smoke test trên release artifact.", "Mỗi rollout cần guardrail, kill switch, rollback owner và tiêu chí dừng."],
  ["Java core: collections, generics, equals/hashCode, exception và resource management.", "JVM core: heap/stack, GC, thread, executor, synchronization và Java Memory Model.", "HTTP core: method semantics, status code, headers, caching, content negotiation và CORS.", "Spring Security, authentication/authorization, OWASP và integration/contract test là baseline API."],
  ["ACID, isolation anomaly và transaction boundary phải được hiểu trước annotation @Transactional.", "Persistence context, entity identity, flush và dirty checking quyết định thời điểm SQL chạy.", "Unique/check/foreign-key constraint là lớp bảo vệ cuối cho invariant và idempotency.", "Concurrency test phải tái hiện lost update, duplicate submit, deadlock và retry exhaustion."],
  ["Relational modeling, normalization và constraint đi trước index/query tuning.", "Hiểu B-tree, selectivity, cardinality, composite-index order và execution plan.", "Quản lý connection pool, transaction lifetime, batch size và lock footprint.", "Migration phải có backup/restore verification, expand–contract, backfill quan sát được và forward-fix."],
  ["Phân biệt log, metric, trace; mỗi signal trả lời một loại câu hỏi khác nhau.", "Định nghĩa SLI/SLO, error budget, RED/USE metrics và cardinality budget.", "Correlation ID phải xuyên Mobile → API → dependency → database nhưng không làm lộ PII/token.", "Debug theo timeline và evidence; luôn lưu hypothesis đã loại trừ và phép đo xác nhận."],
  ["Chấp nhận partial failure và network không tin cậy; timeout phải theo deadline budget.", "Hiểu at-most-once, at-least-once, ordering, deduplication và backpressure.", "Idempotency, outbox, state machine và reconciliation giải quyết các lớp lỗi khác nhau.", "Cache invalidation, clock skew, eventual consistency và disaster recovery cần failure test cụ thể."],
  ["Quản lý outcome, WIP, dependency và risk thay vì chỉ theo dõi ticket.", "Capacity estimate gồm traffic, storage growth, concurrency, latency budget và chi phí.", "Mỗi workstream cần owner, decision log, SLO, rollout/rollback và operational readiness checklist.", "Escalation tốt phải có impact, evidence, options, recommendation và deadline quyết định."],
  ["System design bắt đầu từ requirement, invariant, scale và failure mode trước technology choice.", "Review phải bao phủ API/data model, security threat, observability, test strategy, migration và cost.", "Phân biệt reversible và irreversible decision để chọn độ sâu review phù hợp.", "Operational readiness gồm dashboard, alert, runbook, on-call owner và recovery drill."],
  ["Dùng metric tree nối user outcome với product metric và system guardrail.", "Hiểu funnel, cohort, retention, sample bias, statistical significance và practical significance.", "Experiment phải có hypothesis, primary metric, guardrail, exposure rule và stopping rule trước khi chạy.", "Analytics cần data contract, privacy/consent, event quality và kiểm tra sai lệch giữa client–server."],
] as const;

const artifactTargets = [
  ["Technical design", 3], ["Architecture decision record", 3], ["Performance report", 3],
  ["Incident / postmortem", 2], ["Migration plan", 2], ["API contract", 2],
  ["Release checklist", 2], ["Product / funnel analysis", 2], ["STAR stories", 12], ["End-to-end project", 1],
] as const;

type Review = { submission: string; score: string; feedback: string };
type State = {
  selectedWeek: number;
  completed: string[];
  reviews: Record<number, Review>;
  artifacts: Record<string, number>;
  mastery: Record<string, number>;
};

type Filter = "All" | Category | "Review";
type SaveStatus = "idle" | "saving" | "saved" | "error";

const initialState: State = { selectedWeek: 0, completed: [], reviews: {}, artifacts: {}, mastery: {} };

export default function Home() {
  const [state, setState] = useState<State>(initialState);
  const [filter, setFilter] = useState<Filter>("All");
  const [notice, setNotice] = useState("");
  const [loaded, setLoaded] = useState(false);
  const [saveStatus, setSaveStatus] = useState<SaveStatus>("idle");
  const saveTimer = useRef<ReturnType<typeof setTimeout> | null>(null);
  const saveQueue = useRef(Promise.resolve());
  const saveVersion = useRef(0);

  useEffect(() => {
    fetch("/api/progress")
      .then((response) => {
        if (!response.ok) throw new Error();
        return response.json();
      })
      .then((saved) => {
        const params = new URLSearchParams(window.location.search);
        const weekFromUrl = Number(params.get("week"));
        const filterFromUrl = params.get("filter") as Filter | null;
        const mastery = saved.mastery ?? Object.fromEntries((saved.completed ?? []).map((id: string) => [id, 3]));
        setState({
          ...initialState,
          ...saved,
          mastery,
          selectedWeek: Number.isInteger(weekFromUrl) && weekFromUrl >= 1 && weekFromUrl <= weeks.length ? weekFromUrl - 1 : saved.selectedWeek,
        });
        if (["All", "Mobile", "Backend", "Owner", "Product", "Review"].includes(filterFromUrl ?? "")) setFilter(filterFromUrl!);
      })
      .catch(() => setNotice("Không đọc được data/review-progress.md. Hãy kiểm tra block dữ liệu rồi khởi động lại website local."))
      .finally(() => setLoaded(true));

    return () => {
      if (saveTimer.current) clearTimeout(saveTimer.current);
    };
  }, []);

  const update = (next: State) => {
    if (!loaded) return;
    setState(next);
    setNotice("");
    setSaveStatus("saving");
    const version = ++saveVersion.current;
    if (saveTimer.current) clearTimeout(saveTimer.current);
    saveTimer.current = setTimeout(() => {
      saveQueue.current = saveQueue.current
        .then(async () => {
          const response = await fetch("/api/progress", { method: "PUT", headers: { "content-type": "application/json" }, body: JSON.stringify(next) });
          if (!response.ok) throw new Error();
          if (saveVersion.current === version) setSaveStatus("saved");
        })
        .catch(() => {
          if (saveVersion.current === version) setSaveStatus("error");
        });
    }, 700);
  };

  useEffect(() => {
    if (!loaded) return;
    const params = new URLSearchParams(window.location.search);
    params.set("week", String(state.selectedWeek + 1));
    filter === "All" ? params.delete("filter") : params.set("filter", filter);
    window.history.replaceState(null, "", `${window.location.pathname}?${params}${window.location.hash || "#today"}`);
  }, [filter, loaded, state.selectedWeek]);

  const selected = weeks[state.selectedWeek];
  const guide = studyGuides[state.selectedWeek];
  const scoreFor = (weekIndex: number, topicIndex: number) => state.mastery[`w${weekIndex}-t${topicIndex}`] ?? (state.completed.includes(`w${weekIndex}-t${topicIndex}`) ? 3 : undefined);
  const scoredSkills = weeks.flatMap((week, weekIndex) => week.topics.map((topic, topicIndex) => ({ topic, weekIndex, category: week.category, score: scoreFor(weekIndex, topicIndex) })));
  const totalTopics = scoredSkills.length;
  const masteredTopics = scoredSkills.filter((skill) => skill.score === 3).length;
  const overall = Math.round((masteredTopics / totalTopics) * 100);
  const weekDone = selected.topics.filter((_, index) => scoreFor(state.selectedWeek, index) === 3).length;
  const weekProgress = Math.round((weekDone / selected.topics.length) * 100);
  const visibleWeeks = useMemo(() => weeks.map((week, index) => ({ week, index })).filter(({ week, index }) => {
    if (filter === "All") return true;
    if (filter === "Review") return week.topics.some((_, topicIndex) => scoreFor(index, topicIndex) !== 3) || state.reviews[index]?.score !== "3";
    return week.category === filter;
  }), [filter, state.completed, state.mastery, state.reviews]);
  const review = state.reviews[state.selectedWeek] ?? { submission: "", score: "", feedback: "" };
  const scoredOnly = scoredSkills.filter((skill): skill is typeof skill & { score: number } => skill.score !== undefined);
  const weakestCategory = (["Mobile", "Backend", "Owner", "Product"] as Category[])
    .map((category) => {
      const scores = scoredOnly.filter((skill) => skill.category === category).map((skill) => skill.score);
      return { category, average: scores.length ? scores.reduce((sum, score) => sum + score, 0) / scores.length : null };
    })
    .filter((item): item is { category: Category; average: number } => item.average !== null)
    .sort((a, b) => a.average - b.average)[0];
  const reviewQueue = scoredSkills.filter((skill) => skill.score !== undefined && skill.score < 3).sort((a, b) => (a.score ?? 0) - (b.score ?? 0)).slice(0, 4);

  const setReview = (patch: Partial<Review>) => update({
    ...state,
    reviews: { ...state.reviews, [state.selectedWeek]: { ...review, ...patch } },
  });

  const setSkillScore = (id: string, value: string) => {
    const mastery = { ...state.mastery };
    if (value === "") delete mastery[id];
    else mastery[id] = Number(value);
    const completed = value === "3" ? [...new Set([...state.completed, id])] : state.completed.filter((item) => item !== id);
    update({ ...state, mastery, completed });
  };

  const copySubmission = async () => {
    const prompt = `Hãy đánh giá bài làm tuần ${state.selectedWeek + 1}. Bạn là người chấm và feedback, tôi không tự chấm.\n\nChủ đề: ${selected.title}\nKỹ năng cần chấm 0–3:\n${selected.topics.map((topic, index) => `${index + 1}. ${topic}`).join("\n")}\nBài tập: ${selected.exercise}\nĐầu ra yêu cầu: ${selected.deliverables.join(", ")}\nCore essentials: ${coreEssentials[state.selectedWeek].join("; ")}\nBest practices cần đối chiếu: ${guide.practices.join("; ")}\nPerformance cần kiểm tra: ${guide.performance.join("; ")}\n\nBài làm của tôi:\n${review.submission || "[Chưa nhập bài làm]"}\n\nTrả về bảng: kỹ năng | điểm 0–3 | evidence | thiếu/sai | yêu cầu sửa. Sau đó nêu trade-off chưa xét, rủi ro production và bài bổ sung. Chỉ xác nhận hoàn thành khi tất cả kỹ năng đạt 3/3 và không còn yêu cầu sửa.`;
    try {
      await navigator.clipboard.writeText(prompt);
      setNotice("Đã sao chép bài nộp. Dán vào task Codex này để mình đánh giá.");
    } catch {
      setNotice("Không thể sao chép tự động. Hãy chọn và sao chép nội dung bài làm thủ công.");
    }
  };

  return (
    <main id="main-content" aria-busy={!loaded}>
      <a className="skip-link" href="#today">Bỏ qua đến nội dung chính</a>
      <header className="hero" id="top">
        <nav className="nav" aria-label="Điều hướng chính">
          <a className="brand" href="#top"><span aria-hidden="true">RL</span> Review Lab</a>
          <div className="nav-links">
            <a href="#today">Tuần hiện tại</a>
            <a href="#roadmap">Lộ trình</a>
            <a href="#review">Codex Review</a>
            <a href="#portfolio">Portfolio</a>
          </div>
          <span className="nav-progress">Tiến độ <strong>{overall}%</strong></span>
        </nav>

        <div className="hero-grid">
          <section className="hero-copy">
            <p className="eyebrow">LỘ TRÌNH 12 TUẦN · MOBILE → BACKEND → OWNER</p>
            <h1>Ôn tập có hệ thống.<br /><em>Tiến bộ có bằng chứng.</em></h1>
            <p className="hero-lead">Một nơi duy nhất để học, làm bài và nhận feedback. Mỗi tuần chỉ hoàn thành khi kết quả đã được Codex review.</p>
            <div className="hero-actions">
              <a className="button primary" href="#today">Tiếp tục tuần {state.selectedWeek + 1} <span>→</span></a>
              <a className="button ghost" href="#roadmap">Xem 12 tuần</a>
            </div>
          </section>

          <aside className="score-card" aria-label="Tiến độ tổng thể">
            <div className="score-top"><span>TIẾN ĐỘ TỔNG</span><strong>{overall}%</strong></div>
            <div className="progress large" role="progressbar" aria-label="Tiến độ tổng thể" aria-valuemin={0} aria-valuemax={100} aria-valuenow={overall}><span style={{ width: `${overall}%` }} /></div>
            <div className="score-grid">
              <div><strong>{masteredTopics}</strong><span>kỹ năng đạt 3/3</span></div>
              <div><strong>{Object.values(state.reviews).filter((item) => item.score === "3").length}</strong><span>tuần đạt chuẩn</span></div>
            </div>
            <p>Nhóm yếu nhất: <strong>{weakestCategory ? `${weakestCategory.category} · ${weakestCategory.average.toFixed(1)}/3` : "Chưa có điểm"}</strong></p>
            <p>Chuẩn hoàn thành: Codex chấm <strong>3/3</strong> hoặc xác nhận không cần sửa thêm.</p>
          </aside>
        </div>
      </header>

      <section className="today section" id="today">
        <div className="section-heading">
          <div><p className="kicker">ĐANG HỌC</p><h2>Tuần {state.selectedWeek + 1}: {selected.title}</h2></div>
          <div className="week-score"><span>{weekDone}/{selected.topics.length} chủ đề</span><strong>{weekProgress}%</strong></div>
        </div>
        <div className="progress" role="progressbar" aria-label={`Tiến độ tuần ${state.selectedWeek + 1}`} aria-valuemin={0} aria-valuemax={100} aria-valuenow={weekProgress}><span style={{ width: `${weekProgress}%` }} /></div>

        <aside className="review-queue" aria-label="Kỹ năng cần ôn lại">
          <div><p className="card-label">CẦN ÔN LẠI</p><strong>{reviewQueue.length ? `${reviewQueue.length} kỹ năng yếu nhất` : "Chưa có kỹ năng bị chấm dưới 3"}</strong></div>
          <ul>{(reviewQueue.length ? reviewQueue : selected.topics.slice(0, 2).map((topic, topicIndex) => ({ topic, weekIndex: state.selectedWeek, score: undefined, category: selected.category }))).map((skill) => <li key={`${skill.weekIndex}-${skill.topic}`}><span>Tuần {skill.weekIndex + 1}</span>{skill.topic}<b>{skill.score ?? "–"}/3</b></li>)}</ul>
        </aside>

        <div className="today-grid">
          <div className="checklist card">
            <p className="card-label">CODEX CHẤM TỪNG KỸ NĂNG · 0–3</p>
            {selected.topics.map((topic, index) => {
              const id = `w${state.selectedWeek}-t${index}`;
              const score = scoreFor(state.selectedWeek, index);
              return <div className={`skill-row ${score === 3 ? "mastered" : ""}`} key={topic}>
                <span className="skill-score" aria-hidden="true">{score ?? "–"}</span>
                <span>{topic}</span>
                <label className="sr-only" htmlFor={`${id}-score`}>Điểm Codex cho {topic}</label>
                <select id={`${id}-score`} value={score ?? ""} onChange={(event) => setSkillScore(id, event.target.value)}>
                  <option value="">Chưa chấm</option><option value="0">0 — Chưa nắm</option><option value="1">1 — Biết lý thuyết</option><option value="2">2 — Làm được</option><option value="3">3 — Production</option>
                </select>
              </div>;
            })}
          </div>
          <div className="assignment card dark-card">
            <p className="card-label">BÀI THỰC HÀNH</p>
            <h3>{selected.exercise}</h3>
            <div className="deliverables">
              <span>Đầu ra</span>
              <ul>{selected.deliverables.map((item) => <li key={item}>{item}</li>)}</ul>
            </div>
            <a className="text-link" href="#review">Soạn bài nộp cho Codex →</a>
          </div>
        </div>

        <section className="study-pack" aria-labelledby="study-pack-title">
          <div className="study-pack-heading">
            <div><p className="kicker">STUDY PACK</p><h3 id="study-pack-title">Đào sâu trước khi làm bài</h3></div>
            <p>Core, production và performance cho tuần {state.selectedWeek + 1}.</p>
          </div>
          <div className="study-guide-grid">
            {[
              ["01", "Khái niệm & lý thuyết", guide.theory],
              ["02", "Tình huống thực tế", guide.scenarios],
              ["03", "Best practices", guide.practices],
              ["04", "Performance checklist", guide.performance],
              ["05", "Core essentials", coreEssentials[state.selectedWeek]],
            ].map(([number, title, items], index) => (
              <details className="study-guide" key={title as string} open={index === 0}>
                <summary><span>{number as string}</span><strong>{title as string}</strong><i aria-hidden="true">+</i></summary>
                <ul>{(items as string[]).map((item) => <li key={item}>{item}</li>)}</ul>
              </details>
            ))}
          </div>
          <div className="official-resources">
            <span>Tài liệu chính thức</span>
            {guide.resources.map((resource) => <a key={resource.url} href={resource.url} target="_blank" rel="noreferrer">{resource.label} <span aria-hidden="true">↗</span></a>)}
          </div>
        </section>
      </section>

      <section className="roadmap section" id="roadmap">
        <div className="section-heading align-end">
          <div><p className="kicker">ROADMAP</p><h2>Một dự án, ba góc nhìn.</h2><p className="section-copy">Order Management xuyên suốt Mobile, Backend và Technical Ownership.</p></div>
          <div className="filters" aria-label="Lọc lộ trình">
            {(["All", "Review", "Mobile", "Backend", "Owner", "Product"] as const).map((item) => <button key={item} className={filter === item ? "active" : ""} aria-pressed={filter === item} onClick={() => setFilter(item)}>{item === "All" ? "Tất cả" : item === "Review" ? "Cần ôn" : item}</button>)}
          </div>
        </div>

        <div className="week-list">
          {visibleWeeks.map(({ week, index }) => {
            const count = week.topics.filter((_, topicIndex) => state.completed.includes(`w${index}-t${topicIndex}`)).length;
            const done = state.reviews[index]?.score === "3";
            return <article className={`week-row ${state.selectedWeek === index ? "selected" : ""}`} key={week.title}>
              <button className="week-main" onClick={() => update({ ...state, selectedWeek: index })} aria-label={`Chọn tuần ${index + 1}: ${week.title}`} aria-pressed={state.selectedWeek === index}>
                <span className="week-number">{String(index + 1).padStart(2, "0")}</span>
                <span className="week-title"><small>{week.phase} · {week.category}</small><strong>{week.title}</strong><em>{week.focus}</em></span>
                <span className={`status ${done ? "done" : ""}`}>{done ? "Đạt 3/3" : `${count}/${week.topics.length}`}</span>
                <span className="arrow" aria-hidden="true">→</span>
              </button>
            </article>;
          })}
        </div>
      </section>

      <section className="review section" id="review">
        <div className="review-intro">
          <p className="kicker light">CODEX REVIEW</p>
          <h2>Không tự chấm.<br />Để evidence lên tiếng.</h2>
          <p>Dán link repo, report, design hoặc câu trả lời của bạn. Website tạo prompt review đầy đủ để gửi vào task Codex hiện tại.</p>
          <ol>
            <li><span>01</span> Làm bài và ghi evidence.</li>
            <li><span>02</span> Sao chép bài nộp sang Codex.</li>
            <li><span>03</span> Lưu điểm và feedback nhận được.</li>
          </ol>
        </div>
        <div className="review-form">
          <label htmlFor="week-select">Tuần cần review</label>
          <select id="week-select" name="week" autoComplete="off" value={state.selectedWeek} onChange={(event) => update({ ...state, selectedWeek: Number(event.target.value) })}>
            {weeks.map((week, index) => <option value={index} key={week.title}>Tuần {index + 1} — {week.title}</option>)}
          </select>
          <label htmlFor="submission">Bài làm / evidence</label>
          <textarea id="submission" name="submission" autoComplete="off" rows={7} value={review.submission} onChange={(event) => setReview({ submission: event.target.value })} placeholder="Ví dụ: link repo, số liệu before/after, quyết định, trade-off, kết quả…" />
          <button className="button primary full" onClick={copySubmission}>Sao chép bài nộp cho Codex <span aria-hidden="true">↗</span></button>
          <div className="review-result">
            <label htmlFor="score">Điểm Codex đã chấm</label>
            <select id="score" name="score" autoComplete="off" value={review.score} onChange={(event) => setReview({ score: event.target.value })}>
              <option value="">Chưa được chấm</option><option value="0">0 — Chưa nắm</option><option value="1">1 — Biết lý thuyết</option><option value="2">2 — Triển khai được</option><option value="3">3 — Đạt chuẩn production</option>
            </select>
            <label htmlFor="feedback">Feedback từ Codex</label>
            <textarea id="feedback" name="feedback" autoComplete="off" rows={4} value={review.feedback} onChange={(event) => setReview({ feedback: event.target.value })} placeholder="Dán nhận xét và yêu cầu sửa vào đây…" />
          </div>
          <p className={`notice ${saveStatus}`} aria-live="polite">{notice || (saveStatus === "saving" ? "Đang lưu…" : saveStatus === "saved" ? "Đã lưu vào data/review-progress.md." : saveStatus === "error" ? "Chưa lưu được Markdown. Hãy thay đổi lại một mục để thử lại." : "")}</p>
        </div>
      </section>

      <section className="portfolio section" id="portfolio">
        <div className="section-heading">
          <div><p className="kicker">PORTFOLIO ĐẦU RA</p><h2>Học xong phải để lại dấu vết.</h2></div>
          <p className="section-copy">Mục tiêu cuối lộ trình: một bộ evidence đủ để kể câu chuyện Developer, Senior Engineer và Technical Owner.</p>
        </div>
        <div className="artifact-grid">
          {artifactTargets.map(([name, target]) => {
            const value = state.artifacts[name] ?? 0;
            return <div className="artifact" key={name}>
              <div><span>{name}</span><strong>{value}/{target}</strong></div>
              <input aria-label={`Số lượng ${name} đã hoàn thành`} type="range" min="0" max={target} value={value} onChange={(event) => update({ ...state, artifacts: { ...state.artifacts, [name]: Number(event.target.value) } })} />
            </div>;
          })}
        </div>
      </section>

      <section className="rhythm section">
        <p className="kicker">NHỊP HỌC MỖI TUẦN</p>
        <div className="rhythm-grid">
          {["T2 · Lý thuyết", "T3 · Implementation", "T4 · Production case", "T5 · Test / Profile / DB", "T6 · Design & Review", "T7 · End-to-end", "CN · Tổng kết & STAR"].map((day, index) => <div key={day}><span>{String(index + 1).padStart(2, "0")}</span><strong>{day}</strong></div>)}
        </div>
      </section>

      <footer><a className="brand" href="#top"><span aria-hidden="true">RL</span> Review Lab</a><p>Evidence over confidence.</p><a href="#top">Lên đầu trang ↑</a></footer>
    </main>
  );
}
