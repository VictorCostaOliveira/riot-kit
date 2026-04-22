# Integrating RiotKit into your app

How to wire **riot_kit** into a Rails API, a plain Ruby service, or Docker. For API usage (facades, lazy `matches`, Data Dragon), see also [README.md](README.md).

**Languages:** English (this file) · [Português (BR)](INTEGRATION.pt-br.md)

---

## 1. Prerequisites

| Requirement | Notes |
|-------------|--------|
| Ruby | `>= 3.2` (see `riot_kit.gemspec`) |
| Riot developer API key | From the [Riot Developer Portal](https://developer.riotgames.com/). Use as `RIOT_API_KEY`. |
| Region / platform | Set `config.region` (routing cluster) and `config.platform` (shard, e.g. `br1`, `na1`, `euw1`). Wrong platform → wrong league endpoints. |

---

## 2. Add the gem

### From RubyGems (when published)

```ruby
# Gemfile
gem "riot_kit", "~> 1.0"
```

### From GitHub

```ruby
gem "riot_kit", github: "VictorCostaOliveira/riot-kit", branch: "main"
```

### Local path (monorepo / development)

Use a **path relative to your app’s `Gemfile`** so `bundle install` works in Docker (absolute host paths usually **fail** inside containers):

```ruby
# Example: gem lives next to the API folder
gem "riot_kit", path: "../riot-kit"
```

If the gem stays **outside** the compose mount (e.g. only `league-coach-api` → `/myapp`), add a **volume** in `docker-compose.yml` that mounts the gem directory and point `path:` at that mount, **or** vendor/copy the gem into the repo.

---

## 3. Rails

### Install

```bash
bundle install
bin/rails generate riot_kit:install
```

Creates `config/initializers/riot_kit.rb` with an explicit **`RiotKit.configure` block** (this is the default integration path we document and ship):

```ruby
require "riot_kit"

RiotKit.configure do |config|
  config.api_key = ENV.fetch("RIOT_API_KEY")
  config.region = :americas # :americas | :europe | :asia | :sea
  config.platform = :br1    # br1, na1, euw1, ...

  # Optional:
  # config.http_timeout = 30
  # config.retry_attempts = 3
  # config.retry_base_delay = 0.5
  # config.logger = Rails.logger if defined?(Rails)
end
```

Set **`RIOT_API_KEY`** in `.env` / deployment secrets. Adjust **`region`** and **`platform`** to match your players’ routing cluster and shard.

### Boot order

`ENV.fetch("RIOT_API_KEY")` **fails boot** if the key is missing—often what you want in production. In development you can use `ENV["RIOT_API_KEY"]` or read from `Rails.application.credentials` if you need the app to boot without the key.

### Using the API in controllers / jobs

**Different shard or region per request.** Default `region` / `platform` come from the initializer. To target another platform (or routing cluster) for one flow, duplicate config and pass **`config:`** to `Player.find` (see [README.md — Override platform](README.md#override-platform-or-region-per-call)):

```ruby
cfg = RiotKit.config.dup.tap { |c| c.platform = params[:platform].to_sym }
player = RiotKit::Player.find(params[:riot_id], config: cfg)
```

Use **both** `region` and `platform` when the summoner's account is under another routing cluster (not only another shard within `americas`).

```ruby
player = RiotKit::Player.find("GameName#TAG")
entry  = player.matches.first        # lazy: one match-detail request (+ id list), not 20
detail = player.match(entry.match_id)
```

`Player.find` performs the account lookup once. `matches` reuses `puuid` and does **not** repeat `GET .../accounts/by-riot-id/...` for that flow.

For a full list as an Array:

```ruby
rows = player.matches(limit: 20).to_a
```

See [README.md — Player#matches](README.md#playermatches--lazy-loading-memoization-account-lookup-limit) for memoization, `reload:`, and `limit:`.

### Tests

- Stub HTTP or the Riot client if you integration-test Riot calls.  
- Keep `RIOT_API_KEY` out of CI logs; use credentials or env injected by CI.

---

## 4. Non-Rails Ruby

```ruby
require "riot_kit"

RiotKit.configure do |config|
  config.api_key = ENV.fetch("RIOT_API_KEY")
  config.region = :americas
  config.platform = :br1
  config.logger = nil # optional: silence stdout in scripts
end

player = RiotKit::Player.find("Name#TAG")
p player.matches.first&.match_id
```

Same rules: region/platform must match the player’s environment.

---

## 5. Docker / Bundler checklist

| Issue | Mitigation |
|-------|------------|
| `The path ... does not exist` on `bundle install` | Path gems must exist **inside** the container. Use relative `path:` under the mounted app tree, or mount the gem directory, or use `git:` / RubyGems. |
| API key in image | Prefer runtime env (`docker-compose` `environment`, Kubernetes secrets), not baked into the image. |

---

## 6. Data Dragon (static JSON)

Items/champions/runes ship with JSON under the gem. Optional rake tasks (see README) refresh data when you choose to bump DD snapshots.

---

## 7. Troubleshooting

| Symptom | What to check |
|---------|----------------|
| `401` / invalid key | `RIOT_API_KEY`, key not expired, correct project on developer portal. |
| Wrong league / ranked data | `config.platform` (e.g. `br1` vs `na1`). |
| Too many HTTP calls for “only first match” | Use `player.matches.first` (lazy iterable)—not `matches.to_a.first` without understanding `limit`. |
| Boot fails on missing key | initializer uses `ENV.fetch`; relax in dev or set a dummy key only locally (never commit). |

---

## 8. Further reading

- [README.md](README.md) — features, facades, services, publishing  
- [README.pt-br.md](README.pt-br.md) — Portuguese overview  
