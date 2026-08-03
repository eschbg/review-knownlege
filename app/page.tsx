"use client";

import { useEffect, useMemo, useState } from "react";

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
};

const initialState: State = { selectedWeek: 0, completed: [], reviews: {}, artifacts: {} };
const storageKey = "review-lab-progress-v1";

export default function Home() {
  const [state, setState] = useState<State>(initialState);
  const [filter, setFilter] = useState<"All" | Category>("All");
  const [notice, setNotice] = useState("");

  useEffect(() => {
    try {
      const saved = localStorage.getItem(storageKey);
      if (saved) setState({ ...initialState, ...JSON.parse(saved) });
    } catch {
      setNotice("Không đọc được tiến độ đã lưu trên thiết bị này.");
    }
  }, []);

  const update = (next: State) => {
    setState(next);
    localStorage.setItem(storageKey, JSON.stringify(next));
  };

  const selected = weeks[state.selectedWeek];
  const totalTopics = weeks.reduce((sum, week) => sum + week.topics.length, 0);
  const overall = Math.round((state.completed.length / totalTopics) * 100);
  const weekDone = selected.topics.filter((_, index) => state.completed.includes(`w${state.selectedWeek}-t${index}`)).length;
  const weekProgress = Math.round((weekDone / selected.topics.length) * 100);
  const visibleWeeks = useMemo(() => weeks.map((week, index) => ({ week, index })).filter(({ week }) => filter === "All" || week.category === filter), [filter]);
  const review = state.reviews[state.selectedWeek] ?? { submission: "", score: "", feedback: "" };

  const setReview = (patch: Partial<Review>) => update({
    ...state,
    reviews: { ...state.reviews, [state.selectedWeek]: { ...review, ...patch } },
  });

  const toggleTopic = (id: string) => update({
    ...state,
    completed: state.completed.includes(id) ? state.completed.filter((item) => item !== id) : [...state.completed, id],
  });

  const copySubmission = async () => {
    const prompt = `Hãy đánh giá bài làm tuần ${state.selectedWeek + 1} theo thang 0–3.\n\nChủ đề: ${selected.title}\nBài tập: ${selected.exercise}\nĐầu ra yêu cầu: ${selected.deliverables.join(", ")}\n\nBài làm của tôi:\n${review.submission || "[Chưa nhập bài làm]"}\n\nHãy trả về: điểm, phần đúng, phần thiếu/sai, trade-off chưa xét, rủi ro production, yêu cầu sửa và bài bổ sung.`;
    try {
      await navigator.clipboard.writeText(prompt);
      setNotice("Đã sao chép bài nộp. Dán vào task Codex này để mình đánh giá.");
    } catch {
      setNotice("Không thể sao chép tự động. Hãy chọn và sao chép nội dung bài làm thủ công.");
    }
  };

  return (
    <main>
      <header className="hero" id="top">
        <nav className="nav" aria-label="Điều hướng chính">
          <a className="brand" href="#top"><span>RL</span> Review Lab</a>
          <div className="nav-links">
            <a href="#roadmap">Lộ trình</a>
            <a href="#review">Codex Review</a>
            <a href="#portfolio">Portfolio</a>
          </div>
        </nav>

        <div className="hero-grid">
          <section className="hero-copy">
            <p className="eyebrow">LỘ TRÌNH 12 TUẦN · MOBILE → BACKEND → OWNER</p>
            <h1>Học ít hơn.<br /><em>Chứng minh nhiều hơn.</em></h1>
            <p className="hero-lead">Mỗi tuần kết thúc bằng một sản phẩm có thể review — code, design, report hoặc câu chuyện kinh nghiệm. Codex chấm, bạn sửa, rồi mới hoàn thành.</p>
            <div className="hero-actions">
              <a className="button primary" href="#today">Tiếp tục tuần {state.selectedWeek + 1} <span>→</span></a>
              <a className="button ghost" href="#roadmap">Xem 12 tuần</a>
            </div>
          </section>

          <aside className="score-card" aria-label="Tiến độ tổng thể">
            <div className="score-top"><span>TIẾN ĐỘ TỔNG</span><strong>{overall}%</strong></div>
            <div className="progress large"><span style={{ width: `${overall}%` }} /></div>
            <div className="score-grid">
              <div><strong>{state.completed.length}</strong><span>chủ đề xong</span></div>
              <div><strong>{Object.values(state.reviews).filter((item) => item.score === "3").length}</strong><span>tuần đạt chuẩn</span></div>
            </div>
            <p>Chuẩn hoàn thành: Codex chấm <strong>3/3</strong> hoặc xác nhận không cần sửa thêm.</p>
          </aside>
        </div>
      </header>

      <section className="today section" id="today">
        <div className="section-heading">
          <div><p className="kicker">ĐANG HỌC</p><h2>Tuần {state.selectedWeek + 1}: {selected.title}</h2></div>
          <div className="week-score"><span>{weekDone}/{selected.topics.length} chủ đề</span><strong>{weekProgress}%</strong></div>
        </div>
        <div className="progress"><span style={{ width: `${weekProgress}%` }} /></div>

        <div className="today-grid">
          <div className="checklist card">
            <p className="card-label">KIẾN THỨC CẦN CHỨNG MINH</p>
            {selected.topics.map((topic, index) => {
              const id = `w${state.selectedWeek}-t${index}`;
              return <label className="check-row" key={topic}>
                <input type="checkbox" checked={state.completed.includes(id)} onChange={() => toggleTopic(id)} />
                <span>{topic}</span>
              </label>;
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
      </section>

      <section className="roadmap section" id="roadmap">
        <div className="section-heading align-end">
          <div><p className="kicker">ROADMAP</p><h2>Một dự án, ba góc nhìn.</h2><p className="section-copy">Order Management xuyên suốt Mobile, Backend và Technical Ownership.</p></div>
          <div className="filters" aria-label="Lọc lộ trình">
            {(["All", "Mobile", "Backend", "Owner", "Product"] as const).map((item) => <button key={item} className={filter === item ? "active" : ""} onClick={() => setFilter(item)}>{item === "All" ? "Tất cả" : item}</button>)}
          </div>
        </div>

        <div className="week-list">
          {visibleWeeks.map(({ week, index }) => {
            const count = week.topics.filter((_, topicIndex) => state.completed.includes(`w${index}-t${topicIndex}`)).length;
            const done = state.reviews[index]?.score === "3";
            return <article className={`week-row ${state.selectedWeek === index ? "selected" : ""}`} key={week.title}>
              <button className="week-main" onClick={() => update({ ...state, selectedWeek: index })} aria-label={`Chọn tuần ${index + 1}: ${week.title}`}>
                <span className="week-number">{String(index + 1).padStart(2, "0")}</span>
                <span className="week-title"><small>{week.phase} · {week.category}</small><strong>{week.title}</strong><em>{week.focus}</em></span>
                <span className={`status ${done ? "done" : ""}`}>{done ? "Đạt 3/3" : `${count}/${week.topics.length}`}</span>
                <span className="arrow">↗</span>
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
          <select id="week-select" value={state.selectedWeek} onChange={(event) => update({ ...state, selectedWeek: Number(event.target.value) })}>
            {weeks.map((week, index) => <option value={index} key={week.title}>Tuần {index + 1} — {week.title}</option>)}
          </select>
          <label htmlFor="submission">Bài làm / evidence</label>
          <textarea id="submission" rows={7} value={review.submission} onChange={(event) => setReview({ submission: event.target.value })} placeholder="Link repo, số liệu before/after, quyết định, trade-off, kết quả..." />
          <button className="button primary full" onClick={copySubmission}>Sao chép bài nộp cho Codex <span>↗</span></button>
          <div className="review-result">
            <label htmlFor="score">Điểm Codex đã chấm</label>
            <select id="score" value={review.score} onChange={(event) => setReview({ score: event.target.value })}>
              <option value="">Chưa được chấm</option><option value="0">0 — Chưa nắm</option><option value="1">1 — Biết lý thuyết</option><option value="2">2 — Triển khai được</option><option value="3">3 — Đạt chuẩn production</option>
            </select>
            <label htmlFor="feedback">Feedback từ Codex</label>
            <textarea id="feedback" rows={4} value={review.feedback} onChange={(event) => setReview({ feedback: event.target.value })} placeholder="Dán nhận xét và yêu cầu sửa vào đây..." />
          </div>
          <p className="notice" aria-live="polite">{notice}</p>
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

      <footer><a className="brand" href="#top"><span>RL</span> Review Lab</a><p>Evidence over confidence.</p><a href="#top">Lên đầu trang ↑</a></footer>
    </main>
  );
}
