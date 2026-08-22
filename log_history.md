# Mentor log — Senior Flutter / Technical Owner roadmap

> File này là nguồn sự thật để tiếp tục mentor trong một cuộc trò chuyện mới.  
> Cập nhật sau mỗi buổi làm việc: trạng thái, bằng chứng, quyết định, blocker và bước kế tiếp.

## Thông tin chương trình

- Người học: Hoàng (cần xác nhận nếu tên hiển thị khác).
- Mục tiêu: Nâng năng lực Senior Flutter/Technical Owner, có thể phụ trách 2–3 dự án song song.
- Khối lượng: 12 tuần + Tuần 0, 6–8 giờ/tuần.
- Bắt đầu: chưa chốt; log được tạo ngày 2026-08-22 (Asia/Saigon).
- Trạng thái: **Tuần 0 — đang thực hiện**.
- Project thực hành: Flutter app `review_known` tại `E:\Project\FE\review-known`.
- Nguyên tắc: học trên project thật; mỗi tuần phải có ít nhất một artifact kiểm chứng (PR/source, test, benchmark, ADR, checklist, incident report/postmortem hoặc technical proposal).

## Nhịp làm việc mỗi tuần

| Buổi | Thời lượng | Nội dung |
| --- | ---: | --- |
| 1 | 1.5–2 giờ | Review kiến thức, đọc code, xác định vấn đề |
| 2 | 2–3 giờ | Implement/refactor trên project thật |
| 3 | 2 giờ | Incident drill, debugging, performance hoặc testing |
| Tổng kết | 30 phút | Ghi ADR, checklist, benchmark hoặc postmortem |

### Cách mentor vận hành

1. Đầu tuần: chốt **một outcome có thể kiểm chứng**, không chỉ là danh sách cần đọc.
2. Trong tuần: Hoàng gửi code/PR, ảnh DevTools, log lỗi hoặc phần trả lời drill; mentor review, đặt câu hỏi, chỉ ra trade-off và thu hẹp scope khi cần.
3. Cuối tuần: lưu evidence, tự chấm theo rubric, ghi quyết định và chọn việc quan trọng nhất của tuần sau.
4. Nếu chậm: ưu tiên Networking & authentication → Migration & data → Performance → Architecture → Accessibility/i18n. Không để bài tập quan trọng tồn quá hai tuần.

## Rubric đánh giá (Tuần 0 và Tuần 12)

| Điểm | Ý nghĩa |
| ---: | --- |
| 0 | Chưa biết/chưa từng làm |
| 1 | Biết khái niệm nhưng cần hướng dẫn |
| 2 | Tự triển khai được trường hợp thường |
| 3 | Debug, tối ưu và xử lý production được |
| 4 | Thiết kế, review, giải thích trade-off và hướng dẫn người khác |

Không tự chấm theo cảm giác: điểm 3+ cần evidence (code, incident, benchmark hoặc tài liệu thiết kế). Mức 3 đòi hỏi đã implement, có test/measurement, debug được và giải thích trade-off; mức 4 đòi hỏi thiết kế từ đầu, review được, đưa tiêu chuẩn chung, hướng dẫn team và chịu trách nhiệm production.

## Roadmap tóm tắt và artifact bắt buộc

| Tuần | Chủ đề trọng tâm | Outcome/evidence tối thiểu |
| --- | --- | --- |
| 0 | Baseline audit: Dart/Flutter, architecture, state, network, offline, performance, native, security, testing, release, observability, a11y/i18n, ownership, đa dự án, stakeholder | Bảng điểm baseline, 5 gap lớn nhất, chọn project thật, backlog ưu tiên theo rủi ro production |
| 1 | Dart concurrency & Flutter internals: event/microtask, isolate, lifecycle, build/layout/paint, keys/scheduler | Benchmark JSON trước/sau isolate; rendering-pipeline note; checklist debug rebuild/layout/paint; xử lý stale response/race |
| 2 | Architecture & state management: boundaries, repository/use case, DTO/domain/UI, state scope, DI | Refactor feature pagination/refresh/filter/cache/error; dependency diagram; ADR kiến trúc/state |
| 3 | Networking & reliable data flow: timeout/cancel/error/retry/idempotency/auth/cache | Refresh-token coordinator; error taxonomy; test retry/timeout/401/race/out-of-order response; log đã redact |
| 4 | Local DB, offline & security foundation: migration, sync/conflict, storage, MASVS | Migration test matrix v1→v4; offline queue recovery; data classification; security checklist |
| 5 | Performance, accessibility & localization | Performance report; a11y checklist; screenshot/test ≥2 locale và text scale lớn; kiểm tra memory/list/image/frame |
| 6 | Buffer & mid-roadmap audit | Progress report, backlog điều chỉnh, benchmark/test networking+migration chạy lại |
| 7 | Native integration & advanced security: lifecycle, permissions, deep link, channels, signing, pinning | Native demo; threat model feature nhạy cảm; security review; plan certificate-pin rotation |
| 8 | Testing & quality engineering | Test strategy, CI quality gate, test refresh race/migrations/UI/core flow, flaky-test register |
| 9 | CI/CD, release & dependency management | Pipeline/design, release checklist, staged-rollout + rollback playbook |
| 10 | Observability & incident management | Mobile-health dashboard, incident runbook, hoàn chỉnh một postmortem, alert list |
| 11 | Technical ownership & stakeholder communication | Technical design, business one-pager, estimate breakdown, ADR, risk register |
| 12 | 2–3 projects, capstone & re-audit | Portfolio board, shared process templates, capstone end-to-end, re-audit và kế hoạch 90 ngày |

## Chi tiết tiêu chí của các tuần quan trọng

### Tuần 0 — baseline audit

Audit một project Flutter thực tế theo 15 nhóm: Dart/Flutter internals, architecture, state, networking, database/offline, performance, native integration, security, testing, CI/CD/release, observability, accessibility/localization, technical ownership, multi-project và stakeholder communication. Với mỗi nhóm: điểm 0–4, evidence, rủi ro, gap và hành động ưu tiên.

### Tuần 1 — Dart/concurrency/Flutter internals

Drill: JSON lớn khiến UI đứng 2–3 giây; sau khi tách isolate lại có dữ liệu cũ do request trước hoàn thành sau request mới. Phải xử lý CPU-bound work, cancellation/response versioning, race condition, loading/error. Thực hành gồm dự đoán event/microtask, đo isolate, demo rebuild-vs-relayout-vs-repaint, tìm rebuild dư và so sánh ValueKey/ObjectKey/GlobalKey.

### Tuần 2 — architecture/state

Feature thực hành có pagination, pull-to-refresh, filter, cached data, partial error, retry, empty state và background refresh. Cần trả lời: giữ data cũ khi refresh lỗi? initial loading khác refreshing thế nào? state nào sống sau dispose? business rule ở đâu? thay API bằng fake repository để test được không? Drill: hai màn hình sửa global state khiến dữ liệu reset — sửa nguyên nhân thay vì thêm điều kiện chắp vá.

### Tuần 3 — networking

Networking layer phải đảm bảo đúng một token-refresh tại một thời điểm, request khác chờ hợp lệ; không retry business/validation error; hủy request khi không cần; có correlation/request ID; redact secret/PII; lỗi API không crash. Drill: nhiều `401` tạo refresh song song rồi request thất bại logout nhầm.

### Tuần 4 — offline/security

Thực hiện migration 1→2→3→4 và test direct-upgrade từ mọi version còn user; offline queue có retry + idempotency key và phục hồi sau khi app bị kill giữa sync. Security: không nhúng secret, dùng secure storage cho token, log không chứa PII/token, session/logout, deep-link/clipboard/screenshot theo yêu cầu business, dependency review theo OWASP MASVS/MSTG. Drill: crash do thiếu migration trung gian và token bị lộ trong production log.

### Tuần 5 — performance/a11y/i18n

Đo cold/warm start, profile scroll dài, image sizing/cache, object bị retain và frame timings. A11y: semantics, screen reader, text scale, contrast, tap target, focus/reduced motion. i18n: ARB, plural/gender, locale format, overflow, RTL và backend copy. Drill: vỡ layout ở German + text scale 200%.

### Tuần 7 — native/advanced security

Review Android/iOS lifecycle, permission, signing/flavor, R8/Proguard, platform channel/Pigeon, deep/universal/app links, push, killed-state restoration; TLS, pinning & rotation, obfuscation, root/jailbreak limits, WebView, biometrics, replay/idempotency. Drill certificate rotation: backup pin, expiry strategy, flag/kill-switch (nếu có), monitoring. Client không phải trusted environment; secret/business rule quan trọng vẫn nằm backend.

### Tuần 8–10 — quality/release/operations

- Testing theo rủi ro: tiền/dữ liệu không phục hồi → auth → migration → offline sync → core value flow → UI phụ. Dùng unit/widget/integration/golden/contract test, fake clock, failure injection. Drill flaky CI do animation/timing/async.
- Release: flavors, secret injection, signing, versioning, staged rollout, flags/remote config/kill switch, rollback và crash symbols. Release gate gồm test, migration, symbols, security, a11y smoke, analytics, monitoring owner và mitigation plan. Drill crash-rate tăng nhưng store chưa rollback ngay.
- Observability: structured/redacted logs, crash/nonfatal, crash-free, ANR, startup/frame/network metrics, correlation ID, alerts, severity, RCA/postmortem. Drill crash Android sau background lâu rồi mở bằng notification.

### Tuần 11–12 — owner mindset

- Tuần 11: biến business request thành user problem, metric, MVP, dependencies, edge cases, risk, assumptions và acceptance criteria. Estimate theo best/likely/worst, scope/dependencies/testing/release/risk/buffer. Giao tiếp theo Impact → Evidence → Options → Trade-off → Recommendation → Decision needed.
- Tuần 12: portfolio board (objective/status/risk/blocker/milestone/owner); context handoff trước khi dừng; chuẩn hóa README/ADR/PR/release/security/DoD/observability templates. Chỉ tạo shared package khi có ≥2 consumer, API ổn định, owner, tests/versioning, lợi ích hơn coupling. Capstone là feature phức tạp có đủ objective → rollout/rollback → estimate/risk/stakeholder proposal. Re-audit theo đúng rubric Tuần 0, rồi lập kế hoạch 90 ngày.

## Tiêu chí hoàn thành roadmap

Có thể technical-own feature từ requirement đến production; debug qua Flutter/native/network/backend; quyết định bằng evidence/trade-off; quản lý migration/offline/auth/release risk; đo performance; đưa security/a11y/i18n vào DoD; estimate/risk bằng ngôn ngữ business; review nhiều codebase; chuẩn hóa quy trình 2–3 dự án; và re-audit chứng minh tiến bộ bằng artifact/metric.

## Nhật ký phiên làm việc

### 2026-08-22 — Tuần 0 / Buổi 1 bắt đầu

- Static audit project: có một source file `lib/main.dart`, dependencies Flutter chuẩn, không có test/CI/release setup; `flutter analyze` đã pass.
- Không dùng các thiếu vắng của project template để tự đánh giá năng lực người học. Tất cả nhóm năng lực đang là `TBD` chờ evidence.
- Đã tạo `docs/week_0_baseline_audit.md`: baseline rubric, kế hoạch 6–8 giờ, self-evidence, Bài chẩn đoán A và Drill B.
- Bước kế tiếp: Hoàng hoàn thành self-evidence và bắt đầu Bài chẩn đoán A; mentor review evidence, rồi ghi điểm baseline/risk vào audit.

### 2026-08-22 — Source control

- Project sẽ được lưu tại repository `https://github.com/eschbg/review-knownlege.git` trên branch độc lập `review-v2`.
- `review-v2` không kế thừa `main` (Next.js) hoặc `review-v1` (Flutter Web app trước đó); mục đích là giữ lab Flutter hiện tại tách biệt, không tạo PR/diff giữa các branch.

### 2026-08-22 — Khởi tạo

- Người dùng yêu cầu Codex làm mentor, đồng hành từng tuần dựa trên roadmap 12 tuần + Tuần 0, tối đa hóa tốc độ và chất lượng kết quả.
- Roadmap gốc do người dùng cung cấp dưới dạng file đính kèm. Nội dung thiết yếu đã được ghi lại trong file này để không phụ thuộc attachment.
- Đã khởi tạo Flutter project rỗng `review_known` trong workspace bằng Flutter SDK (Dart 3.9.0); không thêm dependency ngoài template Flutter tiêu chuẩn.
- Đã chạy `flutter analyze`: **No issues found** (2026-08-22).
- Workspace chưa là Git repository; chưa khởi tạo Git vì chưa có yêu cầu.
- Chưa có baseline score, lịch học, evidence hay blocker nào được cung cấp.
- Bước kế tiếp: thực hiện Tuần 0 bằng baseline audit trên project này, bắt đầu từ Dart/Flutter internals và architecture hiện tại.

## Mẫu cập nhật cho mỗi buổi (người học có thể dán nguyên khối)

```md
### YYYY-MM-DD — Tuần X / Buổi Y
- Mục tiêu buổi:
- Đã làm:
- Evidence: (PR/link/file/ảnh benchmark/log/test)
- Kết quả đo được:
- Quyết định/trade-off:
- Vướng mắc/câu hỏi:
- Bước kế tiếp (một việc cụ thể):
```

## Mẫu tổng kết tuần

```md
### Tuần X — Tổng kết
- Outcome cam kết:
- Outcome thực tế:
- Artifact/evidence:
- Baseline → kết quả:
- Điều đã hiểu nhưng chưa áp dụng:
- Đã áp dụng nhưng chưa test:
- Rủi ro/blocker còn mở:
- Điểm tự chấm (0–4) + evidence:
- Mục tiêu hẹp nhất của tuần tới:
```
