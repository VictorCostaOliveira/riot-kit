# RiotKit

Toolkit Ruby para a **Riot Games API**: roteamento regional e hosts de plataforma, fluxos de partida/jogador com **`Result`**, **facades** fluentes e **Data Dragon** embutido. Serve em qualquer app Ruby — **Rails é opcional**.

**Idiomas:** [English](README.md) · Português (BR)

---

## Instalação

No `Gemfile`, depois `bundle install`:

```ruby
gem "riot_kit", "~> 1.0"
```

**Pelo GitHub** (branch ou fork):

```ruby
gem "riot_kit", github: "VictorCostaOliveira/riot-kit", branch: "main"
```

Ruby **≥ 3.2** — ver [`riot_kit.gemspec`](riot_kit.gemspec).

---

## Configuração

É preciso de uma [API key de desenvolvedor Riot](https://developer.riotgames.com/). Use **`RIOT_API_KEY`** no ambiente (ou atribua `config.api_key` na mão).

### Rails

```bash
bin/rails generate riot_kit:install
```

Gera `config/initializers/riot_kit.rb`. Ajuste **`region`** (cluster de roteamento) e **`platform`** (shard: `br1`, `na1`, `euw1`, …).

### Projeto Ruby qualquer

```ruby
require "riot_kit"

RiotKit.configure do |config|
  config.api_key = ENV.fetch("RIOT_API_KEY")
  config.region = :americas # :americas | :europe | :asia | :sea
  config.platform = :br1    # br1, na1, euw1, ...
end
```

Timeouts, retries e logger opcionais vêm comentados no initializer gerado.

---

## Uso

### Facades

```ruby
player = RiotKit::Player.find("Nome#TAG")
player.matches(:ranked).first   # lazy: detalhes conforme iteração
player.match("BR1_1234567890")
player.ranked
player.avg_matches_per_week

RiotKit::Items.find(3078)
RiotKit::Champions.find("Aatrox")
```

### Services (`Result`)

```ruby
RiotKit::Services::Riot::MatchHistory.call(nickname: "Nome#TAG", filter: :ranked)
  .on_success { |entries| p entries }
  .on_failure { |error| warn error.message }
```

### Data Dragon

Dados estáticos de campeões, itens, runas e feitiços vêm **na própria gem**.

Para **`platform` / `region` por requisição**, comportamento lazy de **`matches`**, filas, limites e APIs de mais baixo nível, veja **[Documentação](#documentação)**.

---

## Documentação

| Doc | Conteúdo |
|-----|-----------|
| **[INTEGRATION.pt-br.md](INTEGRATION.pt-br.md)** | Generator Rails, padrões de **`RiotKit.configure`**, Docker / gem por `path:`, **platform ou region por chamada**, controllers e testes |
| **[INTEGRATION.md](INTEGRATION.md)** | Mesmo guia em inglês |
| **[CHANGELOG.md](CHANGELOG.md)** | Notas de versão |

---

## Suporte

- **Bugs e ideias:** abra uma [issue](https://github.com/VictorCostaOliveira/riot-kit/issues) no GitHub (busque antes por duplicatas).
- **Dúvidas de uso:** issues são aceitáveis depois de ler **INTEGRATION** — inclua versão do Ruby/gem e um exemplo mínimo ao reportar bug.

Temas sensíveis de segurança: use o fluxo de **Security** do repositório, se existir; senão contato privado com o mantenedor.

---

## Contribuindo

1. Fork + branch.
2. `bundle install`
3. `bundle exec rspec` e `bundle exec rubocop`
4. Pull request com descrição objetiva.

**Releases:** aumente a versão em `lib/riot_kit/version.rb` e dê **push na `main`** — o **Tag release** roda em todo push, cria **`vX.Y.Z`** só se essa tag ainda não existir; o **Release RubyGem** testa e publica no RubyGems. Se a versão não mudou, o workflow só registra que a tag já existe e para. Manual: Actions → **Tag release** (`workflow_dispatch`). Detalhes em `.github/workflows/`.

---

## Licença

MIT — ver [LICENSE.txt](LICENSE.txt).
