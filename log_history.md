# Mentor log — Senior Flutter / Technical Owner roadmap

> File này là nguồn sự thật để tiếp tục mentor trong một cuộc trò chuyện mới.  
> Cập nhật sau mỗi buổi làm việc: trạng thái, bằng chứng, quyết định, blocker và bước kế tiếp.

## Thông tin chương trình

- Người học: Hoàng (cần xác nhận nếu tên hiển thị khác).
- Mục tiêu: Nâng năng lực Senior Flutter/Technical Owner, có thể phụ trách 2–3 dự án song song.
- Khối lượng: có 2 track, chọn 1 để chạy thật, track kia là bản đối chiếu:
  - **Track chuẩn:** 12 tuần + Tuần 0, 6–8 giờ/tuần (~78–104 giờ thực hành).
  - **Track rút gọn — Hướng A (đang chạy):** 4 tuần + Tuần 0, 15–20 giờ/tuần (~64–86 giờ thực hành) — cùng phạm vi 15 nhóm năng lực và cùng chuẩn chấm/sửa như track chuẩn, chỉ nén lịch bằng cách gộp chủ đề liền mạch và tăng giờ/tuần, **không cắt bớt evidence bắt buộc**. Lý thuyết thuần túy được confirm nhanh qua chat; phần cốt yếu (đủ để một senior dùng được trong production) vẫn phải code/đo/viết thật, mentor chấm và yêu cầu sửa như cũ.
- Bắt đầu: chưa chốt; log được tạo ngày 2026-08-22 (Asia/Saigon).
- Trạng thái: **Tuần 0 — đang thực hiện** (áp dụng track rút gọn 4 tuần từ Tuần 1).
- Project thực hành: Flutter app `review_known` tại `E:\Project\FE\review-known`.
- Nguyên tắc: học trên project thật; mỗi tuần phải có ít nhất một artifact kiểm chứng (PR/source, test, benchmark, ADR, checklist, incident report/postmortem hoặc technical proposal).

## Nhịp làm việc mỗi tuần

### Track chuẩn (12 tuần, 6–8 giờ/tuần)

| Buổi | Thời lượng | Nội dung |
| --- | ---: | --- |
| 1 | 1.5–2 giờ | Review kiến thức, đọc code, xác định vấn đề |
| 2 | 2–3 giờ | Implement/refactor trên project thật |
| 3 | 2 giờ | Incident drill, debugging, performance hoặc testing |
| Tổng kết | 30 phút | Ghi ADR, checklist, benchmark hoặc postmortem |

### Track rút gọn 4 tuần — Hướng A (15–20 giờ/tuần, đang áp dụng)

Mỗi tuần gộp 2–3 chủ đề của track chuẩn, giữ cùng số lượng evidence, chỉ tăng giờ để bù. Nhịp gợi ý mỗi tuần (chia linh hoạt theo lịch cá nhân, không bắt buộc đúng 4 buổi):

| Buổi | Thời lượng | Nội dung |
| --- | ---: | --- |
| 1 — Lý thuyết & chẩn đoán | 3–4 giờ | Confirm khái niệm qua chat (không cần code), đọc code hiện có, xác định vấn đề/risk cho từng chủ đề gộp trong tuần |
| 2 — Implement chính | 6–8 giờ | Code/refactor artifact cốt lõi trên `review_known`, có thể chia 2 buổi nhỏ nếu cần |
| 3 — Drill & đo lường | 4–5 giờ | Incident drill, benchmark, security/test — ưu tiên 1–2 drill rủi ro cao nhất của tuần, drill phụ có thể rút gọn nếu hụt giờ |
| Tổng kết | 1 giờ | Ghi ADR/checklist/benchmark/postmortem, tự chấm rubric, review với mentor |

Nếu một tuần vượt quá 20 giờ dự kiến (thường là Tuần 3 hoặc Tuần 4 — nhiều chủ đề nhất), ưu tiên hoàn thành đúng thứ tự rủi ro production đã nêu ở mục "Nếu chậm" bên dưới, phần còn lại tràn sang buổi tổng kết hoặc đầu tuần kế tiếp thay vì cắt evidence.

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
| 1 | Dart concurrency & Flutter internals: event/microtask, isolate, lifecycle, build/layout/paint, keys/scheduler, **Element/RenderObject tree, custom RenderObject/CustomPainter, InheritedWidget/Provider mechanics** | Benchmark JSON trước/sau isolate; rendering-pipeline note; checklist debug rebuild/layout/paint; xử lý stale response/race; **demo một CustomPainter hoặc RenderObject tự viết + note cơ chế InheritedWidget propagate/rebuild** |
| 2 | Architecture & state management: boundaries, repository/use case, DTO/domain/UI, state scope, DI | Refactor feature pagination/refresh/filter/cache/error; dependency diagram; ADR kiến trúc/state |
| 3 | Networking & reliable data flow: timeout/cancel/error/retry/idempotency/auth/cache, **API contract ownership (OpenAPI/versioning/breaking change)** | Refresh-token coordinator; error taxonomy; test retry/timeout/401/race/out-of-order response; log đã redact; **draft API contract proposal (OpenAPI spec hoặc tài liệu tương đương) cho một endpoint mới, kèm versioning/backward-compatibility note gửi backend review** |
| 4 | Local DB, offline & security foundation: migration, sync/conflict, storage, MASVS | Migration test matrix v1→v4; offline queue recovery; data classification; security checklist |
| 5 | Performance, accessibility & localization | Performance report; a11y checklist; screenshot/test ≥2 locale và text scale lớn; kiểm tra memory/list/image/frame |
| 6 | Buffer & mid-roadmap audit, **multi-project priority drill** | Progress report, backlog điều chỉnh, benchmark/test networking+migration chạy lại; **priority-decision note mô phỏng 2 project deadline chồng nhau (impact/risk/trade-off/quyết định)** |
| 7 | Native integration & advanced security: lifecycle, permissions, deep link, channels, signing, pinning | Native demo; threat model feature nhạy cảm; security review; plan certificate-pin rotation |
| 8 | Testing & quality engineering | Test strategy, CI quality gate, test refresh race/migrations/UI/core flow, flaky-test register |
| 9 | CI/CD, release & dependency management, **app size/build optimization** | Pipeline/design, release checklist, staged-rollout + rollback playbook; **build-size report (split APK/App Bundle, deferred components, R8/Proguard shrink) trước/sau tối ưu** |
| 10 | Observability & incident management | Mobile-health dashboard, incident runbook, hoàn chỉnh một postmortem, alert list |
| 11 | Technical ownership & stakeholder communication, **code review & mentoring** | Technical design, business one-pager, estimate breakdown, ADR, risk register; **review một PR/code người khác (hoặc mẫu code có sẵn), viết review comment nêu rõ vấn đề + trade-off + đề xuất, theo chuẩn có thể dùng để chuẩn hóa coding convention cho team** |
| 12 | 2–3 projects, capstone & re-audit | Portfolio board, shared process templates, capstone end-to-end, re-audit và kế hoạch 90 ngày |

## Roadmap rút gọn — 4 tuần (Hướng A, đang áp dụng)

Bảng dưới đây map lại đúng 15 nhóm năng lực + 5 mục bổ sung ở trên vào 4 tuần, giữ nguyên yêu cầu evidence/chấm/sửa của track chuẩn — chỉ gộp chủ đề liền mạch (nội dung mới hiểu thường cần nội dung trước làm nền) để giảm số lần chuyển ngữ cảnh.

| Tuần | Gộp từ (track chuẩn) | Chủ đề | Artifact bắt buộc (chấm + sửa) |
| --- | --- | --- | --- |
| 0 | Tuần 0 | Baseline audit | Bảng điểm baseline, 5 gap lớn nhất, backlog ưu tiên |
| 1 | Tuần 1 + 2 + 3 | Dart/Flutter internals (kèm rendering sâu) → Architecture/state → Networking (kèm API contract) | (1) Benchmark isolate + xử lý stale response; (2) demo CustomPainter/RenderObject + note InheritedWidget; (3) refactor feature theo repository/use case + ADR kiến trúc/state; (4) refresh-token coordinator + test 401/race/retry; (5) draft API contract (OpenAPI/versioning) |
| 2 | Tuần 4 + 5 + phần app-size của Tuần 9 | Offline/DB & security foundation → Performance/a11y/i18n → App size/build optimization | (1) Migration test matrix v1→v4 + offline queue recovery; (2) security checklist (secure storage, log redact, deep-link); (3) performance report (start/scroll/frame) + a11y checklist + i18n ≥2 locale/text scale 200%; (4) build-size report trước/sau tối ưu |
| 3 | Tuần 7 + 8 + phần còn lại của Tuần 9 | Native & advanced security → Testing & quality → CI/CD & release | (1) Native demo + threat model + cert-pin rotation plan; (2) test strategy + flaky-test register + test race/migration/UI; (3) CI/CD pipeline design + release checklist + rollout/rollback playbook |
| 4 | Tuần 6 (multi-project) + 10 + 11 (kèm code review) + 12 | Observability → Ownership/stakeholder → Multi-project priority drill → Code review/mentoring → Capstone & re-audit | (1) Incident runbook + 1 postmortem hoàn chỉnh; (2) technical design + business one-pager + estimate + ADR + risk register; (3) priority-decision note đa dự án; (4) review PR/code người khác + convention draft; (5) capstone feature end-to-end + re-audit theo rubric Tuần 0 |

Ghi chú độ khó: Tuần 1 và Tuần 4 là hai tuần nặng nhất (Tuần 1 vì là nền tảng kỹ thuật cốt lõi, Tuần 4 vì gộp cả ownership lẫn capstone/re-audit) — nên chốt lịch dư ra ít nhất nửa ngày buffer cho hai tuần này nếu có thể.

### Drill nào là "chính" khi hụt giờ trong track 4 tuần

Track chuẩn có nhiều drill hơn track 4 tuần có thể tải hết mỗi tuần ở mức chấm đầy đủ. Nếu một tuần không đủ giờ để làm hết mọi drill trong bảng gộp, thứ tự ưu tiên drill chính (được chấm/sửa đầy đủ) như sau, phần còn lại có thể rút gọn thành thảo luận/chat-confirm và ghi rõ trong baseline là "hiểu khái niệm, chưa có evidence sản xuất đầy đủ" thay vì chấm như đã đạt điểm 3+:

1. Tuần 1: race condition (stale response) > 401 refresh song song > CustomPainter/InheritedWidget demo.
2. Tuần 2: migration thiếu bước trung gian + token lộ log > layout vỡ German/200% text scale.
3. Tuần 3: crash-rate tăng chưa rollback > certificate rotation > flaky CI.
4. Tuần 4: postmortem + priority-decision note đa dự án > code review/mentoring > estimate/stakeholder proposal (vì đây là năng lực người học có sẵn nền base 4 năm kinh nghiệm, rủi ro thấp hơn).

## Chi tiết tiêu chí của các tuần quan trọng

> Các mục "Tuần X" dưới đây mô tả nội dung theo track chuẩn 12 tuần (tham chiếu độ sâu kỹ thuật của từng chủ đề). Khi chạy track rút gọn 4 tuần, dùng bảng map ở trên để biết chủ đề nào gộp vào tuần nào — nội dung/yêu cầu evidence của từng chủ đề giữ nguyên như mô tả dưới đây, không rút gọn.

### Tuần 0 — baseline audit

Audit một project Flutter thực tế theo 15 nhóm: Dart/Flutter internals, architecture, state, networking, database/offline, performance, native integration, security, testing, CI/CD/release, observability, accessibility/localization, technical ownership, multi-project và stakeholder communication. Với mỗi nhóm: điểm 0–4, evidence, rủi ro, gap và hành động ưu tiên.

### Tuần 1 — Dart/concurrency/Flutter internals

Drill: JSON lớn khiến UI đứng 2–3 giây; sau khi tách isolate lại có dữ liệu cũ do request trước hoàn thành sau request mới. Phải xử lý CPU-bound work, cancellation/response versioning, race condition, loading/error. Thực hành gồm dự đoán event/microtask, đo isolate, demo rebuild-vs-relayout-vs-repaint, tìm rebuild dư và so sánh ValueKey/ObjectKey/GlobalKey.

**Đào sâu rendering (bổ sung):** đây là phần phân biệt senior với mid, không dừng ở "biết build/layout/paint" mà phải giải thích và demo được. Yêu cầu: (1) vẽ/giải thích Widget tree → Element tree → RenderObject tree và vai trò từng tầng; (2) viết một `CustomPainter` hoặc `RenderObject` tùy biến đơn giản (ví dụ vẽ biểu đồ nhỏ hoặc custom layout) để chứng minh hiểu `paint`/`performLayout`; (3) giải thích cơ chế `InheritedWidget`/`Provider` propagate và rebuild — khi nào widget con rebuild, khi nào không, so sánh với `setState` ở tầng State. Evidence: đoạn code + note ngắn giải thích trade-off.

### Tuần 2 — architecture/state

Feature thực hành có pagination, pull-to-refresh, filter, cached data, partial error, retry, empty state và background refresh. Cần trả lời: giữ data cũ khi refresh lỗi? initial loading khác refreshing thế nào? state nào sống sau dispose? business rule ở đâu? thay API bằng fake repository để test được không? Drill: hai màn hình sửa global state khiến dữ liệu reset — sửa nguyên nhân thay vì thêm điều kiện chắp vá.

### Tuần 3 — networking

Networking layer phải đảm bảo đúng một token-refresh tại một thời điểm, request khác chờ hợp lệ; không retry business/validation error; hủy request khi không cần; có correlation/request ID; redact secret/PII; lỗi API không crash. Drill: nhiều `401` tạo refresh song song rồi request thất bại logout nhầm.

**API contract ownership (bổ sung):** technical owner không chỉ tiêu thụ API mà phải chủ động đề xuất/negotiate contract với backend. Yêu cầu: chọn một endpoint mới hoặc cần thay đổi, viết draft contract (OpenAPI spec hoặc tài liệu tương đương: request/response schema, status code, error shape); nêu rõ chiến lược versioning (path/header version, additive-only field, deprecation timeline) và cách xử lý breaking change (feature flag, dual-support window, migration cho client cũ). Evidence: file/tài liệu contract + đoạn giải thích vì sao chọn cách versioning đó.

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

### Tuần 6 — buffer & multi-project priority drill (bổ sung)

Ngoài audit tiến độ và chạy lại benchmark/test, thêm một drill mô phỏng tình huống thực tế của mục tiêu chính (phụ trách 2–3 dự án song song): hai project A và B cùng có deadline trong tuần, A đang có bug production ảnh hưởng người dùng nhưng chưa nghiêm trọng, B cần review một feature quan trọng cho demo khách hàng. Trả lời trong tối đa 15 dòng: (1) thứ tự ưu tiên và lý do dựa trên impact/risk, không dựa trên cảm tính; (2) việc gì có thể delegate/defer và ai cần được thông báo; (3) trade-off chấp nhận và cách giảm rủi ro cho việc bị lùi lại. Evidence: note quyết định, không cần code.

### Tuần 9 — app size/build optimization (bổ sung)

Ngoài CI/CD & release, thêm một hạng mục đo và tối ưu kích thước build vì đây là câu hỏi production thường gặp và ảnh hưởng trực tiếp tới tải app/onboarding. Yêu cầu: đo kích thước APK/App Bundle hiện tại; áp dụng ít nhất một kỹ thuật tối ưu (split APK theo ABI, App Bundle + Play Feature Delivery/deferred components, hoặc kiểm tra R8/Proguard shrink có hoạt động đúng — không strip nhầm code cần giữ); đo lại kích thước sau tối ưu. Evidence: bảng số liệu trước/sau + note rủi ro (ví dụ: cần test kỹ sau khi bật R8 để tránh crash do obfuscation).

### Tuần 11 — code review & mentoring (bổ sung)

Tiêu chí hoàn thành roadmap có nói tới "hướng dẫn team" nhưng chưa có drill thực hành riêng. Thêm vào Tuần 11: chọn một đoạn code/PR có sẵn (của mình cũ, mã nguồn mở, hoặc mentor cung cấp), viết review comment như đang review cho đồng nghiệp — chỉ ra vấn đề cụ thể (không chỉ style mà cả architecture/state/error-handling nếu có), giải thích trade-off của cách hiện tại so với đề xuất, và đóng góp thành 3–5 dòng coding convention có thể áp dụng chung cho team. Evidence: bản review + convention draft.

### Tuần 11–12 — owner mindset

- Tuần 11: biến business request thành user problem, metric, MVP, dependencies, edge cases, risk, assumptions và acceptance criteria. Estimate theo best/likely/worst, scope/dependencies/testing/release/risk/buffer. Giao tiếp theo Impact → Evidence → Options → Trade-off → Recommendation → Decision needed.
- Tuần 12: portfolio board (objective/status/risk/blocker/milestone/owner); context handoff trước khi dừng; chuẩn hóa README/ADR/PR/release/security/DoD/observability templates. Chỉ tạo shared package khi có ≥2 consumer, API ổn định, owner, tests/versioning, lợi ích hơn coupling. Capstone là feature phức tạp có đủ objective → rollout/rollback → estimate/risk/stakeholder proposal. Re-audit theo đúng rubric Tuần 0, rồi lập kế hoạch 90 ngày.

## Tiêu chí hoàn thành roadmap

Có thể technical-own feature từ requirement đến production; debug qua Flutter/native/network/backend; quyết định bằng evidence/trade-off; quản lý migration/offline/auth/release risk; đo performance; đưa security/a11y/i18n vào DoD; estimate/risk bằng ngôn ngữ business; review nhiều codebase; chuẩn hóa quy trình 2–3 dự án; và re-audit chứng minh tiến bộ bằng artifact/metric.

## Nhật ký phiên làm việc

### 2026-08-22 — Dựng track rút gọn 4 tuần (Hướng A)

- Hoàng muốn ôn trong 4 tuần thay vì 12 tuần; phần lý thuyết thuần túy sẽ tự confirm qua chat, phần cốt yếu để dùng được ở mức senior vẫn phải thực hành, được chấm và sửa như cũ.
- Đánh giá trước khi dựng lại: giữ nguyên 4 tuần với nhịp 6–8 giờ/tuần cũ sẽ không đủ (chỉ ~1/3 khối lượng gốc) để giữ chất lượng chấm/sửa cho cả 15 nhóm năng lực — chọn Hướng A (tăng giờ/tuần lên 15–20 giờ, tổng ~64–86 giờ, gần bằng track chuẩn) thay vì Hướng B (giữ giờ cũ nhưng cắt scope).
- Đã thêm: track thứ 2 song song với track chuẩn 12 tuần (giữ track chuẩn làm tài liệu tham chiếu độ sâu từng chủ đề, không xóa); bảng map 15 nhóm năng lực + 5 mục bổ sung vào 4 tuần; nhịp làm việc 3 buổi/tuần theo giờ mới; thứ tự ưu tiên drill khi hụt giờ cho từng tuần.
- Nguyên tắc giữ nguyên: không hạ chuẩn evidence hay rubric 0–4; nếu một hạng mục phụ bị rút gọn vì hụt giờ, phải ghi rõ trong baseline là "hiểu khái niệm, chưa có evidence sản xuất" thay vì chấm như đã đạt.
- Bước kế tiếp: xác nhận với Hoàng có thực sự duy trì được 15–20 giờ/tuần trong 4 tuần tới không; nếu không, chuyển sang Hướng B (cắt scope) thay vì âm thầm hạ chuẩn evidence.

### 2026-08-22 — Cập nhật roadmap sau review

- Review lại roadmap so với mục tiêu Senior Flutter/Technical Owner phụ trách 2–3 dự án, phát hiện 5 khoảng trống và bổ sung trực tiếp vào bảng roadmap + phần chi tiết tuần:
  1. Tuần 1: thêm yêu cầu đào sâu Element/RenderObject tree, CustomPainter/RenderObject tự viết, cơ chế InheritedWidget/Provider.
  2. Tuần 3: thêm API contract ownership — draft OpenAPI/versioning/breaking-change proposal gửi backend.
  3. Tuần 6: thêm multi-project priority drill (2 project deadline chồng nhau).
  4. Tuần 9: thêm hạng mục app size/build optimization (split APK/AAB, deferred components, R8 shrink) với số liệu trước/sau.
  5. Tuần 11: thêm code review & mentoring drill — review PR người khác, viết convention draft cho team.
- Không đổi cấu trúc 12 tuần + Tuần 0 hay rubric điểm; chỉ mở rộng nội dung/outcome của các tuần liên quan.
- Bước kế tiếp: tiếp tục Tuần 0 (self-evidence, Bài chẩn đoán A, Drill B) theo kế hoạch cũ; các mục bổ sung sẽ được thực hành khi tới đúng tuần.

### 2026-08-22 — Tuần 0 / Buổi 1 bắt đầu

- Static audit project: có một source file `lib/main.dart`, dependencies Flutter chuẩn, không có test/CI/release setup; `flutter analyze` đã pass.
- Không dùng các thiếu vắng của project template để tự đánh giá năng lực người học. Tất cả nhóm năng lực đang là `TBD` chờ evidence.
- Đã tạo `docs/week_0_baseline_audit.md`: baseline rubric, kế hoạch 6–8 giờ, self-evidence, Bài chẩn đoán A và Drill B.
- Bước kế tiếp: Hoàng hoàn thành self-evidence và bắt đầu Bài chẩn đoán A; mentor review evidence, rồi ghi điểm baseline/risk vào audit.

### 2026-08-22 — Source control

- Project được lưu tại repository `https://github.com/eschbg/review-knownlege.git` trên branch độc lập `review-v2`.
- `review-v2` không kế thừa `main` (Next.js) hoặc `review-v1` (Flutter Web app trước đó); mục đích là giữ lab Flutter hiện tại tách biệt, không tạo PR/diff giữa các branch.
- Commit khởi tạo `eaac687` (`chore: initialize Flutter review lab`) đã được push và branch đang theo dõi `origin/review-v2`.

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
