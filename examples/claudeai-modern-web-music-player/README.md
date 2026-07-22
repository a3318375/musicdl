<div align="right">

**English** · [简体中文](README.zh-CN.md)

</div>

# Soundtrack · 声轨

A modern web-based music **search / download / player** built on top of [musicdl](https://github.com/CharlesPikachu/musicdl).
This example is for learning and research around web playback, streaming search, download tasks, and local Cookie configuration.

## Why it doesn't freeze

musicdl's search is slow because it resolves the **real audio URL for every single result** (multiple network round-trips). A naive blocking `music_client.search()` makes the UI hang for 10–30 seconds. This project avoids that with a few techniques:

- **Per-result streaming.** The backend drives musicdl's `_search` directly, watches the result list it fills in as it resolves each track, and pushes every track to the browser the instant it's ready via Server-Sent Events (SSE). Results appear one by one instead of all at once after a long wait.
- **Concurrent sources.** Each enabled music source runs on its own thread, so fast sources show up first and slow ones never block them.
- **Watchdog timeout.** Any source that hangs longer than `PER_SOURCE_TIMEOUT` seconds is dropped and flagged, so one stuck platform can never freeze the whole UI.
- **Instant playback.** The direct URL is already resolved during search, so playback streams through a backend proxy (with HTTP Range support for seeking) — no need to download the full track first.
- **Live download progress.** Chunked downloads report downloaded MB and speed in real time.

## Run

```bash
pip install -r requirements.txt
python app.py
# open http://127.0.0.1:5000 in your browser
```

Use `PORT=8080 python app.py` to pick a different port. Downloaded files are saved under `downloads/<source>/`.

> For learning, research, and personal experiments only. Please follow applicable terms of service and local laws.

## Usage

- Type a keyword in the top bar to search; results stream in one by one.
- Toggle music sources with the chips at the top.
- Each row: ▷ play, ⭳ download. Double-clicking a row also plays it.
- Bottom player bar: previous / play-pause / next, seek, volume, live spectrum.
- The "词" button opens the synced lyrics panel; the button in the bottom-right opens the downloads list.
- Shortcuts: `Space` to play/pause, `Alt+←/→` for previous/next track.

## Structure

```
app.py             Flask backend: streaming search (SSE) / audio proxy (Range) / cover proxy / download progress (SSE)
static/index.html  UI markup
static/style.css   Visual styling (dark "recording-studio" theme)
static/app.js      Frontend logic: streaming render / Web Audio spectrum / synced lyrics / downloads
```

## Configuration

Constants at the top of `app.py`:

- `SUPPORTED_SOURCES` — add or remove music sources, change which are on by default.
- `SEARCH_SIZE_PER_SOURCE` — how many tracks to resolve per source (larger = slower).
- `PER_SOURCE_TIMEOUT` — per-source timeout in seconds.

Cookie values can be saved from the settings panel in the top-right corner. They are stored locally under `config/`.

## Credits

Built on [CharlesPikachu/musicdl](https://github.com/CharlesPikachu/musicdl). All search and audio-resolution logic comes from musicdl; this project adds the streaming web UI, player, and download experience.
