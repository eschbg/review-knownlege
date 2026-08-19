# Kế Hoạch Xây Dựng Ứng Dụng Flutter Web Ôn Tập Kiến Thức (Tech Mastery Review Hub)

Bản kế hoạch này tổng hợp dữ liệu từ 2 lộ trình **Roadmap Backend (Spring)** và **Roadmap Mobile (Flutter)** có sẵn trong project để thiết kế một ứng dụng Web tương tác bằng Flutter. Ứng dụng giúp theo dõi tiến độ, tự đánh giá năng lực (Baseline Audit 0-4), luyện tập giải quyết sự cố (Incident Drills), và ôn tập kiến thức qua Flashcard / Practice Scenarios.

---

## 1. Mục Tiêu Ứng Dụng (Product Objectives)

1. **Tổng hợp & Số hóa 2 Roadmap**: Biến 2 tài liệu Markdown (`roadmap-backend-spring.md` & `roadmap-mobile-flutter.md`) thành giao diện tương tác trực quan.
2. **Theo Dõi Tiến Độ & Self-Audit**:
   - Cho phép người dùng tự chấm điểm năng lực (thang 0-4) theo từng kỹ năng và từng tuần.
   - Theo dõi bằng chứng hoàn thành (Deliverables: PR, Benchmark, ADR, Postmortem, Checklist).
3. **Mô Phỏng Sự Cố (Incident Drill Interactive Engine)**:
   - Đưa ra các tình huống sự cố thực tế từ 2 roadmap (ví dụ: AOP proxy self-invocation, Connection pool exhaustion, Refresh Token race condition, Migration crash,...).
   - Cho phép chọn hướng giải quyết, hiển thị phân tích nguyên nhân gốc (Root Cause) và Postmortem.
4. **Cầu Nối Kỹ Năng (Mobile ↔ Backend Mapping)**:
   - Đô thị hóa và so sánh trực quan các khái niệm tương đồng giữa Mobile & Backend (VD: Flutter Isolates vs JVM Threads, Client Refresh Token vs Server Refresh Token, Local DB Migration vs Flyway/Liquibase).

---

## 2. Phân Tích Nội Dung Tích Hợp Dữ Liệu

### A. Backend Spring Roadmap (12 Tuần + Tuần 0)
- **Tuần 0**: Audit 11 nhóm kỹ năng (Architecture, DB, API, Concurrency, Security, Caching, Testing, CI/CD, Observability, Performance).
- **Tuần 1-12**: JVM & Spring Internals, Concurrency, DB & Transactions, API & Error handling, Caching, Security, Messaging (Kafka/RabbitMQ), Microservices & Saga, Testing (Testcontainers), CI/CD & Docker, Observability (OpenTelemetry/RED), System Design & Capstone.

### B. Mobile Flutter Roadmap (12 Tuần + Tuần 0)
- **Tuần 0**: Audit 15 nhóm kỹ năng (Dart internals, Architecture, State, Networking, Local DB, Performance, Native, Security, Testing, CI/CD, Observability, Multi-project management,...).
- **Tuần 1-12**: Dart & Render Pipeline, Architecture & State, Networking & Refresh Token, Local DB & Security, Performance & i18n/a11y, Mid-Audit, Native & Security, Testing, CI/CD & Rollout, Observability & Incident, Technical Ownership & Stakeholder, Multi-Project Management & Capstone.

---

## 3. Các Feature Cốt Lõi Của Website (Core Features)

### 📊 Feature 1: Dashboard & Progress Tracker (Tổng Quan Tiến Độ)
- Bảng tổng hợp tổng phần trăm hoàn thành theo từng lộ trình.
- Biểu đồ radar / bar chart hiển thị số điểm Self-Audit (thang 0 đến 4) cho từng nhóm kỹ năng.
- Widget thông báo các công việc / bài tập / incident drill cần hoàn thành trong tuần hiện tại.

### 🗺️ Feature 2: Interactive Roadmap Explorer (Trình Khám Phá Lộ Trình)
- Xem chi tiết từng tuần theo dạng Timeline dọc hoặc Kanban Board.
- Lọc theo Roadmap (Spring Backend / Mobile Flutter / Chế độ kết hợp Mobile-to-Backend).
- Chi tiết từng tuần gồm:
  - **Nội dung Review** (Checklist các khái niệm cần nắm).
  - **Thực Hành** (Yêu cầu bài tập).
  - **Incident Drill** (Tình huống sự cố thực tế).
  - **Deliverable Upload/Input** (Lưu link PR, ghi chú ADR, link postmortem).

### 🚨 Feature 3: Incident Drill Simulator (Trình Mô Phỏng Sự Cố)
- Hệ thống bài tập tình huống dạng Scenario-based Quiz / Interactive Decision Tree.
- Giúp rèn luyện tư duy Production:
  - Bước 1: Phát hiện sự cố qua Log / Symptom.
  - Bước 2: Chọn phương án khoanh vùng / khắc phục tạm thời.
  - Bước 3: Phân tích Root Cause.
  - Bước 4: Chọn giải pháp phòng ngừa dài hạn.
- Có đáp án chi tiết và giải thích lý do kỹ thuật.

### 🧠 Feature 4: Flashcard & Knowledge Review (Thẻ Ôn Tập Kiến Thức)
- Thẻ ghi nhớ thông minh phân loại theo chủ đề (JVM, Concurrency, Spring AOP, Flutter Rendering, Riverpod/Bloc, Refresh Token, Outbox Pattern,...).
- Đánh dấu thẻ: "Chưa thuộc", "Cần ôn lại", "Đã nắm vững" (Spaced Repetition cơ bản).

### 🔀 Feature 5: Cross-Domain Concept Mapping (Tư Duy Ánh Xạ Mobile ↔ Backend)
- Bảng so sánh khái niệm tương đương giúp tận dụng 4 năm kinh nghiệm Mobile khi sang Backend Spring:
  - *Flutter Isolates / Event Loop* ↔ *JVM Threads / Executor Services*
  - *Dio Interceptors & Token Queue* ↔ *Spring Security Filters & Auth Coordinator*
  - *Drift / SQLite Migration* ↔ *Flyway / Liquibase DB Migration*
  - *DevTools Performance Profiler* ↔ *JProfiler / VisualVM / APM*

---

## 4. Kiến Trúc Kỹ Thuật (Technical Architecture for Flutter Web)

### Framework & Package Setup
- **Framework**: Flutter Web (SDK >= 3.0.0)
- **State Management**: `flutter_riverpod` (dễ mở rộng, testable, type-safe)
- **Routing**: `go_router` (quản lý URL bookmarkable trên Web)
- **UI Components & Icons**: `google_fonts`, `lucide_icons`
- **Charts & Visualization**: `fl_chart` (Vẽ biểu đồ Self-Audit Radar/Bar chart)
- **Local Persistence**: `shared_preferences` / `hive` (lưu trữ tiến độ, baseline scores, ghi chú người dùng trực tiếp trên trình duyệt)
- **Markdown Renderer**: `flutter_markdown` (để hiển thị động nội dung chi tiết từ các file Markdown roadmap)

### Cấu Trúc Thư Mục Dự Án (Project Structure)
```
lib/
├── main.dart
├── core/
│   ├── constants/       # Color palette, Typography, App strings
│   ├── theme/           # Dark/Light Material 3 Theme with glassmorphism
│   ├── utils/           # Responsive breakpoints, Helpers
│   └── widgets/         # Custom UI components (Cards, Badges, Buttons)
├── features/
│   ├── dashboard/       # Overview, Radar chart, Progress stats
│   ├── roadmap/         # Weekly roadmap viewer, Timeline, Deliverable form
│   ├── incident_drill/  # Interactive scenario runner, Root cause analysis
│   ├── flashcard/       # Spaced repetition flashcards
│   └── concept_mapping/ # Mobile vs Backend comparison tool
├── models/              # Roadmap, WeekTopic, IncidentScenario, SelfAuditScore
└── data/
    ├── roadmap_backend_data.dart   # Content parsed from roadmap-backend-spring.md
    ├── roadmap_flutter_data.dart   # Content parsed from roadmap-mobile-flutter.md
    └── concept_mappings_data.dart  # Mapping matrix data
```

---

## 5. Thiết Kế UI/UX & Design System (Aesthetic Requirements)

Dựa trên quy chuẩn thiết kế ứng dụng web hiện đại:
- **Phong cách UI**: Dark Mode chủ đạo (Deep Navy `#0B0F19`, Slate `#1E293B`, Vivid Indigo `#6366F1`, Emerald `#10B981`, Amber `#F59E0B`).
- **Glassmorphism & Micro-animations**: Hiệu ứng mờ đục nhè nhẹ (Backdrop blur), hiệu ứng hover mượt mà cho các card tuần học và nút bấm.
- **Layout Responsive**:
  - Web Desktop: Navigation Sidebar cố định bên trái, content area 2-3 cột linh hoạt.
  - Tablet/Mobile Web: Drawer Menu, responsive stack.
- **Typography**: Google Fonts (Inter / Outfit / JetBrains Mono cho code snippets).

---

## 6. Các Bước Triển Khai Dự Án (Implementation Steps)

| Bước | Hạng Mục Công Việc | Chi Tiết Thực Hiện |
| :--- | :--- | :--- |
| **Bước 1** | **Khởi tạo Dự án Flutter Web** | Tạo dự án Flutter, thiết lập `go_router`, `riverpod`, `fl_chart`, theme Material 3 Dark. |
| **Bước 2** | **Số hóa Dữ liệu Roadmap** | Chuyển đổi dữ liệu từ 2 file `.md` thành các Data Class (`Roadmap`, `WeekItem`, `IncidentDrill`, `AuditCategory`). |
| **Bước 3** | **Xây dựng Design System & Layout Core** | Tạo Sidebar Navigation, Header, Responsive Container, Card Components, Rating Stars/Sliders cho Audit score. |
| **Bước 4** | **Xây dựng Feature Dashboard & Progress** | Thiết lập biểu đồ Radar/Bar chart tổng quan điểm Self-Audit (thang 0-4) và thanh phần trăm hoàn thành. |
| **Bước 5** | **Xây dựng Roadmap Explorer & Detail View** | Cho phép xem 12 tuần học, đánh dấu completed, nhập link bằng chứng (PR/ADR/Postmortem), filter theo chủ đề. |
| **Bước 6** | **Xây dựng Trình Mô Phỏng Incident Drill** | Tạo giao diện tương tác giải quyết sự cố từng bước (Symptom → Triage → Root Cause → Prevention). |
| **Bước 7** | **Xây dựng Flashcards & Mobile-Backend Matrix** | Thiết lập bộ thẻ ghi nhớ kiến thức và bảng so sánh khái niệm song song. |
| **Bước 8** | **Tối Ưu & Build Web** | Test responsiveness, kiểm tra lưu trữ `SharedPreferences`, build web bundle / kiểm tra chạy mượt mà trên browser. |

---

## 7. Quyết Định Cần Duyệt (Next Steps & Decisions)

1. **Xác nhận Kế hoạch**: Bạn thấy cấu trúc tính năng và kế hoạch kiến trúc trên đã đầy đủ chưa?
2. **Công cụ State Management**: Bạn muốn ưu tiên sử dụng `flutter_riverpod`, `provider` hay `flutter_bloc` cho web app này?
3. **Tiến hành Code**: Ngay khi bạn đồng ý với kế hoạch này, chúng ta sẽ bắt đầu tạo dự án Flutter Web và code từng màn hình theo từng bước trên.
