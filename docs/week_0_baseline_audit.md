# Tuần 0 — Baseline audit

## Mục tiêu tuần

Thiết lập điểm xuất phát dựa trên evidence, chọn các gap tác động production lớn nhất và biến `review_known` thành project thực hành xuyên suốt roadmap. **Không chấm năng lực từ template rỗng.** `TBD` nghĩa là chưa có evidence, không phải điểm 0.

## Evidence đã có (2026-08-22)

| Hạng mục | Evidence | Kết luận hiện tại |
| --- | --- | --- |
| Project | Flutter app `review_known`, Dart SDK 3.9.0 | Có môi trường thực hành |
| Source | Chỉ có `lib/main.dart`: `runApp` → `MaterialApp` → `Scaffold` → `Text` | Chỉ chứng minh Flutter entry point và `StatelessWidget` cơ bản |
| Dependencies | `flutter`, `flutter_test`, `flutter_lints`; không có package ngoài template | Khởi đầu tối giản, chưa suy ra kinh nghiệm package/DI/state |
| Static analysis | `flutter analyze` pass, không có issue | Tooling tối thiểu hoạt động |
| Tests | Không có thư mục/file test | Chưa có evidence testing |
| Automation/release | Không có `.github`, `fastlane` hoặc pipeline trong scan | Chưa có evidence CI/CD/release |
| Version control | Workspace chưa là Git repository | Cần quyết định sau khi Tuần 0 hoàn tất |

## Bảng điểm baseline

Điền **điểm + evidence cụ thể**. Điểm 3+ phải kèm source/PR, incident, benchmark hoặc design document đã có thật.

| Năng lực | Điểm 0–4 | Evidence hiện có | Gap/rủi ro | Hành động ưu tiên |
| --- | ---: | --- | --- | --- |
| Dart & Flutter internals | TBD | `main.dart` chỉ đủ evidence cơ bản | Chưa rõ concurrency/rendering/debug | Bài chẩn đoán A |
| Architecture | TBD | Template chưa có feature boundary | Chưa rõ cách phân lớp/trade-off | Bài chẩn đoán A |
| State management | TBD | Chưa có state | Chưa rõ state scope/race | Bài chẩn đoán A |
| Networking | TBD | Chưa có request | Auth/error/retry chưa được chứng minh | Bài chẩn đoán A + drill |
| Local DB & offline | TBD | Chưa có persistence | Migration/data loss chưa được chứng minh | Self-evidence |
| Performance | TBD | Chưa có measurement | Không có baseline DevTools | Self-evidence |
| Native integration | TBD | Default runners | Lifecycle/permissions/deep link chưa rõ | Self-evidence |
| Security | TBD | Không có secret/token flow | Storage/log/deep-link risk chưa rõ | Self-evidence |
| Testing | TBD | Chưa có test | Quality gate chưa rõ | Bài chẩn đoán A |
| CI/CD & release | TBD | Chưa có pipeline | Release/rollback risk chưa rõ | Self-evidence |
| Observability | TBD | Chưa có log/metrics | Incident triage chưa rõ | Drill B |
| Accessibility & localization | TBD | Chưa có evidence | Text scale/semantics/i18n chưa rõ | Self-evidence |
| Technical ownership | TBD | Chưa có proposal/ADR | Scope/risk/estimate chưa rõ | Drill B |
| Multi-project management | TBD | Chưa có portfolio evidence | Context switch/priority chưa rõ | Self-evidence |
| Stakeholder communication | TBD | Chưa có status/proposal | Decision framing chưa rõ | Drill B |

## Kế hoạch 6–8 giờ của Tuần 0

### Buổi 1 — Inventory và chẩn đoán (90 phút)

1. Hoàn tất **self-evidence** bên dưới (30 phút, chỉ ghi điều đã thật sự làm).
2. Làm **Bài chẩn đoán A** (60 phút đầu): design state và tạo skeleton. Có thể tiếp tục sang Buổi 2.

### Buổi 2 — Implement và review (2–3 giờ)

Hoàn thành Bài chẩn đoán A trong `lib/` và, nếu làm được, một widget test. Chạy `flutter analyze` và `flutter test`, sau đó gửi mentor các file đã đổi cùng output lệnh.

### Buổi 3 — Incident/owner drill (2 giờ)

Làm **Drill B**, lưu câu trả lời ở cuối file này. Mentor chấm reasoning theo reproduction → evidence → mitigation → root cause → prevention, không chấm theo độ dài.

### Tổng kết (30 phút)

Chốt baseline table, chọn 5 gap lớn nhất theo risk, và chọn one outcome cho Tuần 1. Không chuyển tuần khi chưa có ít nhất một artifact thực tế.

## Self-evidence (Hoàng điền ngắn gọn)

Với từng nhóm dưới đây, ghi `điểm — bằng chứng`. Nếu chưa có, ghi `TBD`, không đoán.

```md
- Dart/Flutter internals:
- Architecture/state management:
- Networking/authentication:
- Local DB/offline/migration:
- Performance (có số đo):
- Native integration:
- Security:
- Testing/CI/CD/release:
- Observability/incident:
- Accessibility/localization:
- Ownership/stakeholder/multi-project:
```

## Bài chẩn đoán A — Issue inbox (không dùng package mới)

Mục đích: lấy evidence cho Dart async, state scope, error UX, architecture và testing; đây là bài chẩn đoán, **không phải kiến trúc production cuối cùng**.

### User story

Người dùng xem danh sách issue, lọc theo từ khóa, bấm refresh, và thấy trạng thái loading/error/data rõ ràng.

### Điều kiện nghiệm thu

1. Có model `Issue` bất biến gồm `id`, `title`, `priority`.
2. Có fake data source/repository trả dữ liệu bất đồng bộ; khi query là `error` thì trả lỗi có chủ đích.
3. UI có ô nhập filter, nút refresh và ba trạng thái: initial loading, lỗi có retry, dữ liệu/empty.
4. Request cũ không được ghi đè kết quả request mới: cố ý tạo lần tải đầu chậm hơn lần sau để chứng minh.
5. Không dùng package mới. Có thể dùng `StatefulWidget`, `Future`, `setState` và request version/token đơn giản.
6. Viết một đoạn 5–10 dòng trong phần **Quyết định A**: state nằm ở đâu, vì sao; cách chặn stale response; nếu có API thật sẽ hủy request/đổi gì.
7. Nếu tự tin, thêm một widget test cho loading → data hoặc error → retry. Không bắt buộc để pass, nhưng là evidence quan trọng.

### Những gì phải gửi để review

- Danh sách file đổi và output `flutter analyze`.
- Output `flutter test` nếu có test.
- Video/ảnh hoặc mô tả 3 trạng thái UI.
- Quyết định A và một điều bạn còn không chắc.

### Quyết định A (Hoàng điền sau khi làm)

```md
- State đặt tại:
- Lý do:
- Cơ chế latest-request-wins:
- Nếu thay fake bằng API thật:
- Điều chưa chắc:
```

## Drill B — Race condition xảy ra ở production

Tình huống: người dùng gõ `a`, request A chạy 2 giây. Ngay sau đó họ gõ `ab`, request B chạy 300 ms. B hiển thị đúng rồi A về muộn và ghi đè UI bằng kết quả cũ. Một số máy mạng yếu còn spinner mãi sau khi rời màn hình.

Trong tối đa 20 dòng, trả lời:

1. Reproduce và dữ liệu/log nào xác nhận được race condition?
2. Mitigation an toàn có thể release nhanh là gì? Có trade-off nào?
3. Fix bền vững cho UI state và request lifecycle là gì?
4. Test nào ngăn regression? Metric/log nào theo dõi sau release?
5. Nếu PM cần ship filter hôm nay, scope nhỏ nhất bạn đề xuất là gì?

### Trả lời Drill B

_Chưa làm._

## Điều kiện hoàn tất Tuần 0

- [ ] Bảng baseline có điểm/evidence, không còn chấm theo cảm giác.
- [ ] Có một artifact từ Bài chẩn đoán A hoặc evidence tương đương từ project thật.
- [ ] Có 5 gap lớn nhất được xếp theo rủi ro production.
- [ ] Có project thực hành chính: `review_known`.
- [ ] Chốt outcome của Tuần 1.
