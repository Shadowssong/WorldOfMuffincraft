require 'battle-muffin'

class CharactersController < ApplicationController
  def index
    #
  end

  def show 
    #@client = BattleMuffin.new("7argtwb4rtuy2ccwcfjs74eapm52juhv") 
    #@char_name = params[:id].split("_").first.strip
    #@realm = params[:id].split("_").last.strip
    #@character = @client.character_handler.search(@char_name, @realm) 
    @nav_bar = %w{ Summary HunterPets Auctions Events Achievements ChallengeMode Pets&Mounts Professions Reputation PvP Activity Feed Guild }
    @left_column_gear = ["helm", "neck", "shoulder", "back", "chest", "shirt", "tabard", "wrist" ]
    @right_column_gear = ["gloves", "waist", "pants", "feet", "ring1", "ring2", "trinket1", "trinket2" ]
    @mainhand = [ "mainhand1", "mainhand2" ] 
  end

  def nav_items
  end
end
