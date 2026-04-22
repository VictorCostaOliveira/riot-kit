# RiotKit

Ruby toolkit for the **Riot Games API**: regional routing and platform hosts, League match/player helpers, **`Result`-based services**, fluent **facades**, and bundled **Data Dragon** static data. Works in any Ruby app — **Rails is optional**.

**Languages:** English · [Português (BR)](README.pt-br.md)

---

## Installation

Add to your `Gemfile` and run `bundle install`:

```ruby
gem "riot_kit", "~> 1.0"
```

**From GitHub** (specific branch or fork):

```ruby
gem "riot_kit", github: "VictorCostaOliveira/riot-kit", branch: "main"
```

Ruby **≥ 3.2** — see [`riot_kit.gemspec`](riot_kit.gemspec).

---

## Configuration

You need a [Riot developer API key](https://developer.riotgames.com/). Expose it as **`RIOT_API_KEY`** (or assign `config.api_key` yourself).

### Rails

```bash
bin/rails generate riot_kit:install
```

This adds `config/initializers/riot_kit.rb`. Edit **`region`** (routing cluster) and **`platform`** (shard: `br1`, `na1`, `euw1`, …) for your defaults.

### Any Ruby project

```ruby
require "riot_kit"

RiotKit.configure do |config|
  config.api_key = ENV.fetch("RIOT_API_KEY")
  config.region = :americas # :americas | :europe | :asia | :sea
  config.platform = :br1    # br1, na1, euw1, ...
end
```

Optional settings (timeouts, retries, logger) are commented in the generated initializer.

---

## Usage

### Facades

```ruby
player = RiotKit::Player.find("GameName#TAG")
player.matches(:ranked).first   # lazy: loads match details as you iterate
player.match("BR1_1234567890")
player.ranked
player.avg_matches_per_week

RiotKit::Items.find(3078)
RiotKit::Champions.find("Aatrox")
```

### Services (`Result`)

```ruby
RiotKit::Services::Riot::MatchHistory.call(nickname: "GameName#TAG", filter: :ranked)
  .on_success { |entries| p entries }
  .on_failure { |error| warn error.message }
```

### Data Dragon

Static champion, item, rune, and spell data is **included in the gem** — no separate download for normal use.

For **per-request `platform` / `region`**, lazy `matches` behavior, queues, limits, and lower-level APIs, see **[Documentation](#documentation)** below.

---

## Documentation

| Doc | Contents |
|-----|-----------|
| **[INTEGRATION.md](INTEGRATION.md)** | Rails generator, **`RiotKit.configure`** patterns, Docker / `path:` gems, overriding **platform or region per request**, controllers and tests |
| **[INTEGRATION.pt-br.md](INTEGRATION.pt-br.md)** | Same guide in Portuguese (Brazil) |
| **[CHANGELOG.md](CHANGELOG.md)** | Release notes |

---

## Support

- **Bug reports & feature requests:** open an [issue](https://github.com/VictorCostaOliveira/riot-kit/issues) on GitHub (search existing issues first).
- **Questions:** GitHub Issues are appropriate if something is unclear after reading **INTEGRATION.md** — include Ruby / gem version and a minimal repro when reporting bugs.

Security-sensitive reports: prefer a private channel if your fork uses **Security** disclosures; otherwise contact the maintainer via the repo.

---

## Contributing

1. Fork the repo and create a branch.
2. `bundle install`
3. `bundle exec rspec` and `bundle exec rubocop`
4. Open a pull request with a clear description.

**Releases:** bump `lib/riot_kit/version.rb`, then **push to `main`** — the **Tag release** workflow runs on every push, creates **`vX.Y.Z`** if that tag is still missing, and **Release RubyGem** then tests and publishes to RubyGems. Pushes that do not change the version simply see “tag already exists” and skip. Manual run: Actions → **Tag release** (`workflow_dispatch`). Details in `.github/workflows/`.

---

## License

MIT — see [LICENSE.txt](LICENSE.txt).
