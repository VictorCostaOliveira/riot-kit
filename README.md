# RiotKit

Gem Ruby pura para consumir a **Riot Games API** (rotas regionais + plataforma), modelos de partida/jogador e dados estáticos via **Data Dragon**, sem dependência de Rails.

## Instalação

```ruby
gem "riot_kit", github: "SEU_USUARIO/riot-kit"
```

## Configuração

```ruby
require "riot_kit"

RiotKit.configure do |config|
  config.api_key = ENV.fetch("RIOT_API_KEY")
  config.region = :americas      # :americas | :europe | :asia | :sea
  config.platform = :br1         # br1, na1, euw1, ...
end
```

## Uso

### Facades (fluente)

```ruby
player = RiotKit::Player.find("SummonerName#TAG")
player.matches(:ranked)
player.match("BR1_1234567890")
player.ranked
player.avg_matches_per_week

RiotKit::Items.find(3078)
RiotKit::Items.categorize([3078, 3006, 1036])
RiotKit::Champions.find("Aatrox")
RiotKit::SummonerSpells.find(4)
RiotKit::Runes.find(8005)
```

### Services (`Result`)

```ruby
RiotKit::Services::Riot::MatchHistory.call(nickname: "Name#TAG", filter: :ranked)
  .on_success { |entries| p entries }
  .on_failure { |error| warn error.message }
```

### Data Dragon local

Snapshots JSON ficam em `lib/riot_kit/data/data_dragon/`. Para atualizar (rede necessária):

```bash
bundle exec rake data_dragon:sync
bundle exec rake data_dragon:version
```

## Roadmap

- Rate limiting por headers `X-App-Rate-Limit`
- Tipagem RBS / `dry-types`
- Publicação RubyGems

## Licença

MIT — ver [LICENSE.txt](LICENSE.txt).
