# frozen_string_literal: true

module MatchPayloads
  module_function

  # Payload mínimo compatível com MatchHistory / MatchDetail (chaves symbolizadas).
  def minimal_match(puuid:, match_id: 'BR1_123')
    {
      metadata: { matchId: match_id },
      info: {
        queueId: 420,
        gameCreation: 1_700_000_000_000,
        gameDuration: 1200,
        participants: [
          {
            puuid: puuid,
            championId: 1,
            championName: 'Annie',
            riotIdGameName: 'Summoner',
            summonerName: 'Summoner',
            teamId: 100,
            win: true,
            kills: 5,
            deaths: 2,
            assists: 10,
            totalMinionsKilled: 180,
            neutralMinionsKilled: 12,
            summoner1Id: 4,
            summoner2Id: 14,
            item0: 3031,
            item1: 3006
          },
          {
            puuid: 'other-puuid',
            championId: 2,
            championName: 'Olaf',
            teamId: 200,
            win: false,
            kills: 0,
            deaths: 0,
            assists: 0,
            totalMinionsKilled: 0,
            neutralMinionsKilled: 0
          }
        ],
        teams: [
          {
            teamId: 100,
            win: true,
            objectives: {
              baron: { kills: 1 },
              dragon: { kills: 2 },
              tower: { kills: 5 },
              inhibitor: { kills: 1 },
              riftHerald: { kills: 1 }
            }
          },
          {
            teamId: 200,
            win: false,
            objectives: {}
          }
        ]
      }
    }
  end
end
