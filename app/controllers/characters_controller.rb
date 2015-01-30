require 'battle-muffin'

class CharactersController < ApplicationController
  helper_method :build_stats_string, :get_race, :get_background, :get_profile_main, :get_guild
  def index
    #
  end

  def show 
    @client = BattleMuffin.new("7argtwb4rtuy2ccwcfjs74eapm52juhv") 
    @char_name = params[:id].split("_").first.strip
    @realm = params[:id].split("_").last.strip
    @character = @client.character_handler.search(@realm, @char_name) 
    @nav_bar = %w{ Summary HunterPets Auctions Events Achievements ChallengeMode Pets&Mounts Professions Reputation PvP Activity Feed Guild }
    @left_column_gear = ["helm", "neck", "shoulder", "back", "chest", "shirt", "tabard", "wrist" ]
    @right_column_gear = ["gloves", "waist", "pants", "feet", "ring1", "ring2", "trinket1", "trinket2" ]
    @mainhand = [ "mainhand1", "mainhand2" ] 
    @title = get_current_title(@character.get_titles)
  end

  def nav_items
  end

  def get_current_title(titles)
    titles.each do |title|
      if title['selected']
        replacements = [ ["%s, ", ""], ["%s ", ""], [" %s", "" ] ]
        replacements.each {|replacement| title['name'].gsub!(replacement[0], replacement[1])}
        return title['name']
      end
    end
  end

  def build_stats_string
    "#{@character.level} #{get_race} #{talent_specialization} #{get_class(@character.class)}, #{@realm}"
  end

  def get_race
    @client.get_races['races'].each do |race|
      return race['name'] if race['id'] == @character.race
    end
  end

  def get_class(class_id)
    @client.get_character_classes['classes'].each do |character_class|
      return character_class['name'] if character_class['id'] == class_id
    end
  end

  def talent_specialization
    @character.get_talents.each do |spec|
      return spec['spec']['name'] if spec['selected']
    end
  end

  def get_background
    "http://us.battle.net/wow/static/images/character/summary/backgrounds/race/#{@character.race}.jpg"
  end

  def get_profile_main
    "http://us.battle.net/static-render/us/#{@character.thumbnail.gsub!("avatar", "profilemain")}"
  end

  def get_guild
    begin
      @character.get_guild['name']
    rescue
      ""
    end
  end
end