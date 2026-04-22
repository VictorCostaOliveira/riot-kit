# Changelog

## 1.0.0 (2026-04-22)

- Primeira versão estável no RubyGems; publicação automática via GitHub Actions ao enviar tag `v*` que coincide com `lib/riot_kit/version.rb` (`gem build` + `gem push`).
- Client Riot + Data Dragon, modelos de partida, services com `Result`, facades `Player` / `Items` / `Champions` / `SummonerSpells` / `Runes`, snapshot Data Dragon embarcado, rake `data_dragon:sync`.
