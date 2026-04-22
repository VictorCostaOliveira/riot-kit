# frozen_string_literal: true

module RiotKit
  module Models
    module Riot
      class Player
        class Combat
          attr_reader :total_damage_dealt_to_champions, :physical_damage_dealt_to_champions,
                      :magic_damage_dealt_to_champions, :true_damage_dealt_to_champions, :total_damage_taken, :physical_damage_taken, :magic_damage_taken, :true_damage_taken, :damage_self_mitigated, :time_ccing_others, :total_heal, :total_heals_on_teammates, :total_damage_shielded_on_teammates, :killing_sprees, :largest_killing_spree, :double_kills, :triple_kills, :quadra_kills, :penta_kills, :largest_multi_kill, :solo_kills, :skillshots_dodged, :skillshots_hit, :outnumbered_kills, :survived_single_digit_hp

          def initialize(**attrs)
            assign_damage_dealt(attrs)
            assign_damage_taken(attrs)
            assign_support(attrs)
            assign_highlights(attrs)
          end

          def to_h
            damage_dealt_attribute_hash
              .merge(damage_taken_attribute_hash)
              .merge(support_attribute_hash)
              .merge(highlight_attribute_hash)
          end

          private

          def assign_damage_dealt(attrs)
            @total_damage_dealt_to_champions    = attrs[:total_damage_dealt_to_champions]
            @physical_damage_dealt_to_champions = attrs[:physical_damage_dealt_to_champions]
            @magic_damage_dealt_to_champions    = attrs[:magic_damage_dealt_to_champions]
            @true_damage_dealt_to_champions     = attrs[:true_damage_dealt_to_champions]
          end

          def assign_damage_taken(attrs)
            @total_damage_taken    = attrs[:total_damage_taken]
            @physical_damage_taken = attrs[:physical_damage_taken]
            @magic_damage_taken    = attrs[:magic_damage_taken]
            @true_damage_taken     = attrs[:true_damage_taken]
            @damage_self_mitigated = attrs[:damage_self_mitigated]
          end

          def assign_support(attrs)
            @time_ccing_others                  = attrs[:time_ccing_others]
            @total_heal                         = attrs[:total_heal]
            @total_heals_on_teammates           = attrs[:total_heals_on_teammates]
            @total_damage_shielded_on_teammates = attrs[:total_damage_shielded_on_teammates]
          end

          def assign_highlights(attrs)
            @killing_sprees           = attrs[:killing_sprees]
            @largest_killing_spree    = attrs[:largest_killing_spree]
            @double_kills             = attrs[:double_kills]
            @triple_kills             = attrs[:triple_kills]
            @quadra_kills             = attrs[:quadra_kills]
            @penta_kills              = attrs[:penta_kills]
            @largest_multi_kill       = attrs[:largest_multi_kill]
            @solo_kills               = attrs[:solo_kills]
            @skillshots_dodged        = attrs[:skillshots_dodged]
            @skillshots_hit           = attrs[:skillshots_hit]
            @outnumbered_kills        = attrs[:outnumbered_kills]
            @survived_single_digit_hp = attrs[:survived_single_digit_hp]
          end

          def damage_dealt_attribute_hash
            {
              total_damage_dealt_to_champions: total_damage_dealt_to_champions,
              physical_damage_dealt_to_champions: physical_damage_dealt_to_champions,
              magic_damage_dealt_to_champions: magic_damage_dealt_to_champions,
              true_damage_dealt_to_champions: true_damage_dealt_to_champions
            }
          end

          def damage_taken_attribute_hash
            {
              total_damage_taken: total_damage_taken,
              physical_damage_taken: physical_damage_taken,
              magic_damage_taken: magic_damage_taken,
              true_damage_taken: true_damage_taken,
              damage_self_mitigated: damage_self_mitigated
            }
          end

          def support_attribute_hash
            {
              time_ccing_others: time_ccing_others,
              total_heal: total_heal,
              total_heals_on_teammates: total_heals_on_teammates,
              total_damage_shielded_on_teammates: total_damage_shielded_on_teammates
            }
          end

          def highlight_attribute_hash
            {
              killing_sprees: killing_sprees,
              largest_killing_spree: largest_killing_spree,
              double_kills: double_kills,
              triple_kills: triple_kills,
              quadra_kills: quadra_kills,
              penta_kills: penta_kills,
              largest_multi_kill: largest_multi_kill,
              solo_kills: solo_kills,
              skillshots_dodged: skillshots_dodged,
              skillshots_hit: skillshots_hit,
              outnumbered_kills: outnumbered_kills,
              survived_single_digit_hp: survived_single_digit_hp
            }
          end
        end
      end
    end
  end
end
