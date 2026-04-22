# frozen_string_literal: true

module RiotKit
  module Helpers
    module Riot
      module MatchHelpers
        FILTERS = %w[ranked flex normal draft quickplay clash].freeze

        QUEUE_ID = {
          ranked: 420,
          flex: 440,
          normal: 430,
          draft: 400,
          quickplay: 490,
          clash: 700
        }.freeze

        QUEUE_LABEL = {
          420 => 'Ranked Solo/Duo',
          440 => 'Ranked Flex',
          430 => 'Normal Blind',
          400 => 'Normal Draft',
          490 => 'Quickplay',
          700 => 'Clash'
        }.freeze

        def queue_label_for(queue_id)
          QUEUE_LABEL[queue_id] || 'Unknown'
        end

        def cs_total_for(participant)
          participant[:totalMinionsKilled].to_i + participant[:neutralMinionsKilled].to_i
        end

        def cs_per_minute(cs_count, duration_seconds)
          return 0.0 if duration_seconds <= 0

          cs_count.fdiv(duration_seconds.fdiv(60)).round(2)
        end

        def item_ids_for(participant)
          (0..6).map { |index| participant[:"item#{index}"] }.compact.reject { |item_id| item_id.to_i.zero? }
        end
      end
    end
  end
end
