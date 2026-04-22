# frozen_string_literal: true

require 'logger'

require_relative 'riot_kit/version'
require_relative 'riot_kit/errors'
require_relative 'riot_kit/util/symbolize'
require_relative 'riot_kit/config'
require_relative 'riot_kit/env_config'
require_relative 'riot_kit/result'
require_relative 'riot_kit/http/response'
require_relative 'riot_kit/http/client'
require_relative 'riot_kit/clients/riot'
require_relative 'riot_kit/clients/data_dragon'

require_relative 'riot_kit/models/riot/account'
require_relative 'riot_kit/models/riot/ranked_entry'
require_relative 'riot_kit/models/riot/match_team'
require_relative 'riot_kit/models/riot/match_detail'
require_relative 'riot_kit/models/riot/player/stats'
require_relative 'riot_kit/models/riot/player/combat'
require_relative 'riot_kit/models/riot/player/economy'
require_relative 'riot_kit/models/riot/player/vision'
require_relative 'riot_kit/models/riot/player/objectives'
require_relative 'riot_kit/models/riot/player/equipment'
require_relative 'riot_kit/models/riot/player'
require_relative 'riot_kit/models/data_dragon/item'
require_relative 'riot_kit/models/data_dragon/champion'
require_relative 'riot_kit/models/data_dragon/summoner_spell'
require_relative 'riot_kit/models/data_dragon/rune'

require_relative 'riot_kit/helpers/riot/match_helpers'

require_relative 'riot_kit/services/base'

require_relative 'riot_kit/services/riot/fetch_account'
require_relative 'riot_kit/services/riot/fetch_ranked_data'
require_relative 'riot_kit/services/riot/fetch_avg_matches_per_week'
require_relative 'riot_kit/services/riot/match_ids'
require_relative 'riot_kit/services/riot/match_detail'
require_relative 'riot_kit/models/riot/match_entry'
require_relative 'riot_kit/models/riot/match_collection'
require_relative 'riot_kit/services/riot/match_history'
require_relative 'riot_kit/models/riot/lazy_match_entries'

require_relative 'riot_kit/registries/data_dragon'

require_relative 'riot_kit/services/data_dragon/fetch_items'
require_relative 'riot_kit/services/data_dragon/fetch_champions'
require_relative 'riot_kit/services/data_dragon/fetch_summoner_spells'
require_relative 'riot_kit/services/data_dragon/fetch_runes'
require_relative 'riot_kit/services/data_dragon/sync'

require_relative 'riot_kit/facades/player'
require_relative 'riot_kit/facades/items'
require_relative 'riot_kit/facades/champions'
require_relative 'riot_kit/facades/summoner_spells'
require_relative 'riot_kit/facades/runes'

module RiotKit
  Player = Facades::Player
  Items = Facades::Items
  Champions = Facades::Champions
  SummonerSpells = Facades::SummonerSpells
  Runes = Facades::Runes
end
