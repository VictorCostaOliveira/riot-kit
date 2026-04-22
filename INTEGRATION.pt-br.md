# Integrando o RiotKit na sua aplicação

Como ligar a **riot_kit** numa API Rails, num serviço Ruby ou em Docker. Uso da API (facades, `matches` lazy, Data Dragon) está no [README.pt-br.md](README.pt-br.md).

**Idiomas:** [English](INTEGRATION.md) · Português (BR) (este arquivo)

---

## 1. Pré-requisitos

| Requisito | Observação |
|-----------|------------|
| Ruby | `>= 3.2` (ver `riot_kit.gemspec`) |
| API key da Riot | Portal de desenvolvedor Riot; expor como `RIOT_API_KEY`. |
| Região / plataforma | `config.region` (cluster de roteamento) e `config.platform` (shard: `br1`, `na1`, `euw1`, …). Plataforma errada → endpoints de ranked errados. |

---

## 2. Incluir a gem

### RubyGems (quando publicada)

```ruby
# Gemfile
gem "riot_kit", "~> 1.0"
```

### GitHub

```ruby
gem "riot_kit", github: "VictorCostaOliveira/riot-kit", branch: "main"
```

### Path local (monorepo / desenvolvimento)

Use **path relativo ao `Gemfile`** do app para o `bundle install` funcionar no Docker (paths absolutos da sua máquina **não existem** no container):

```ruby
# Ex.: gem ao lado da pasta da API
gem "riot_kit", path: "../riot-kit"
```

Se a gem ficar **fora** do que o compose monta (só `league-coach-api` → `/myapp`), **monte** a pasta da gem no `docker-compose` e ajuste o `path:`, ou use `git:` / RubyGems.

---

## 3. Rails

### Instalação

```bash
bundle install
bin/rails generate riot_kit:install
```

Gera `config/initializers/riot_kit.rb` com um bloco **`RiotKit.configure` explícito** — esse é o caminho padrão que documentamos e entregamos para quem integra:

```ruby
require "riot_kit"

RiotKit.configure do |config|
  config.api_key = ENV.fetch("RIOT_API_KEY")
  config.region = :americas # :americas | :europe | :asia | :sea
  config.platform = :br1    # br1, na1, euw1, ...

  # Opcional:
  # config.http_timeout = 30
  # config.retry_attempts = 3
  # config.retry_base_delay = 0.5
  # config.logger = Rails.logger if defined?(Rails)
end
```

Defina **`RIOT_API_KEY`** no `.env` / secrets de deploy. Ajuste **`region`** e **`platform`** ao cluster de roteamento e ao shard dos jogadores.

### Arranque da app

`ENV.fetch("RIOT_API_KEY")` **derruba o boot** sem chave — comum em produção. Em desenvolvimento você pode usar `ENV["RIOT_API_KEY"]` ou ler de `Rails.application.credentials` se precisar subir sem key.

### Uso em controllers / jobs

**Shard ou região diferentes por requisição.** O padrão vem do initializer. Para outro `platform` (ou cluster de roteamento) só naquele fluxo, duplique a config e passe **`config:`** no `Player.find` (detalhes em [README.pt-br.md](README.pt-br.md#platform-e-region-por-chamada)):

```ruby
cfg = RiotKit.config.dup.tap { |c| c.platform = params[:platform].to_sym }
player = RiotKit::Player.find(params[:riot_id], config: cfg)
```

Se a conta estiver em **outro cluster** (não só outro shard dentro de `americas`), ajuste **`region`** e **`platform`** na cópia.

```ruby
player = RiotKit::Player.find("Nome#TAG")
entry  = player.matches.first        # lazy: um GET de detalhe (+ lista de ids), não 20
detail = player.match(entry.match_id)
```

`Player.find` faz o lookup da conta uma vez. `matches` usa o `puuid` e **não** repete `GET .../accounts/by-riot-id/...` nesse fluxo.

Lista completa como Array:

```ruby
rows = player.matches(limit: 20).to_a
```

Memoização, `reload:` e `limit:` — ver [README.pt-br.md — Player#matches](README.pt-br.md).

### Testes

- Faça stub de HTTP ou do cliente Riot nos testes que tocam na API.  
- Não logar `RIOT_API_KEY`; use secrets / env no CI.

---

## 4. Ruby sem Rails

```ruby
require "riot_kit"

RiotKit.configure do |config|
  config.api_key = ENV.fetch("RIOT_API_KEY")
  config.region = :americas
  config.platform = :br1
  config.logger = nil # opcional em scripts
end

player = RiotKit::Player.find("Nome#TAG")
p player.matches.first&.match_id
```

Mesmas regras de região/plataforma.

---

## 5. Docker / Bundler

| Problema | Solução |
|----------|---------|
| `The path ... does not exist` no `bundle install` | Gem por `path:` precisa existir **dentro** do container: path relativo ao projeto montado, volume extra, ou `git:` / RubyGems. |
| Key na imagem | Preferir env em runtime (compose, K8s secrets), não gravar na imagem. |

---

## 6. Data Dragon

JSON estático vem na gem. Rake opcional para atualizar snapshots — ver README.

---

## 7. Problemas comuns

| Sintoma | O que conferir |
|---------|----------------|
| `401` / key inválida | `RIOT_API_KEY`, validade, projeto correto no portal. |
| League / ranked estranho | `config.platform` certo para o shard. |
| “Muitas chamadas” só para a primeira partida | Usar `player.matches.first` (iterável lazy)—evitar `to_a` sem necessidade ou sem entender `limit`. |
| Boot falha sem key | initializer com `ENV.fetch`; afrouxar só em dev ou dummy local (nunca commitar). |

---

## 8. Ver também

- [README.pt-br.md](README.pt-br.md) — visão geral em português  
- [README.md](README.md) — inglês  
