# ADR-0007: Firebase AI Logic for the AI chat feature

- **Status**: Accepted
- **Date**: 2026-10-25

## Context

The app gains a chat-first feature: users ask questions and receive
scripture-grounded explanations (GPT-like streaming chat). The app is
personal today but store distribution is planned, and a login feature is
on the v2 roadmap.

Calling an LLM API directly from the app would embed the API key in the
binary (extractable), and a self-built proxy server (e.g. a Cloudflare
Worker) would add hosting/code to maintain.

## Decision

Use **Firebase AI Logic** (`firebase_ai`) to call Gemini from the client:

- No API key ships with the app; Firebase manages it.
- Streaming via the SDK's `generateContentStream` — no hand-rolled SSE.
- Abuse protection via Firebase App Check when distributing.
- v2 login drops in with `firebase_auth` on the same project, and chat
  history can sync through Firestore.

Scripture grounding stays local: the mentioned or currently open passage
is looked up through `BibleRepo` (bundled `bible.json`) and injected into
the prompt. Chat history is persisted locally in drift
(`chat_sessions` / `chat_messages`, schema v2).

## Consequences

- Gemini-centric lock-in; switching providers later requires a proxy of
  our own (deferred until actually needed).
- `flutterfire configure` must run per platform and `firebase_options.dart`
  is generated (not hand-written).
- The FlutterFire dependency set (`firebase_core`, `firebase_app_check`,
  `firebase_ai`) is added to the app.
