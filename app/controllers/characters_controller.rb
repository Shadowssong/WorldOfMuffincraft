require 'battle-muffin'

class CharactersController < ApplicationController
  helper_method :build_stats_string, :get_race, :get_background, :get_profile_main, :get_guild, :get_item_url, :name,  :average_item_level, :average_item_level_equipped, :achievement_points, :get_item_id

  def index
    #
  end

  def show 
    @client             = BattleMuffin.new("7argtwb4rtuy2ccwcfjs74eapm52juhv") 
    char_name          = params[:id].split("_").first.strip
    realm              = params[:id].split("_").last.strip
    @character          = @client.character_handler.search(realm, char_name) 
    @all_info           = @character.all_info
    @items              = @all_info['items']
    @title              = get_current_title(@all_info['titles'])

    @nav_bar            = ["Summary", "Hunter Pets", "Auctions", "Events", "Achievements", "Challenge Mode", "Pets & Mounts", "Professions", "Reputation", "PvP", "Activity", "Feed", "Guild"]
    @left_column_gear   = ["head", "neck", "shoulder", "back", "chest", "shirt", "tabard", "wrist" ]
    @right_column_gear  = ["hands", "waist", "legs", "feet", "finger1", "finger2", "trinket1", "trinket2" ]
    @mainhand           = [ "mainHand", "offHand" ] 
  end

  def get_current_title(titles)
    titles.each do |title|
      if title['selected']
        replacements = [ ["%s, ", ""], ["%s ", ""], [" %s", "" ] ]
        replacements.each {|replacement| title['name'].gsub!(replacement[0], replacement[1])}
        return title['name']
      end
    end
    return ""
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
    @all_info['talents'].each do |spec|
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
      @all_info['guild']['name']
    rescue
      ""
    end
  end

  def get_item_id(slot)
    @items[slot]['id'] unless @items[slot].nil?
  end

  def get_item_url(slot)
    begin
      "http://media.blizzard.com/wow/icons/56/#{@items[slot]['icon']}.jpg"
    rescue
      if slot == "mainHand" || slot == "offHand"
        "empty_weapon.png"
      else
        "blank_item_slot.png"
      end
    end
  end

  def name
    @character.name
  end

  def average_item_level
    @all_info['items']['averageItemLevel']
  end

  def average_item_level_equipped
    @all_info['items']['averageItemLevelEquipped']
  end

  def achievement_points
    @all_info['achievementPoints']
  end
end
