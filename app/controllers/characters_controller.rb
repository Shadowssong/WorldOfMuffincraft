require 'battle-muffin'
require 'date'

class CharactersController < ApplicationController
  helper_method :build_stats_string, :get_race, :get_background, :get_profile_main, :get_guild, :get_item_url, :name,  :average_item_level, :average_item_level_equipped, :achievement_points, :get_item_id, :get_icon_url, :achievement_array, :get_standing
  before_action :load_data, only: [:view, :challenge_mode, :pets_mounts, :achievements, :progression, :reputation]

  def index
    #
  end

  def view
    #
  end

  def challenge_mode
    #
  end

  def pets_mounts
    #
  end

  def achievements
    #
  end

  def progression 
    #
  end

  def reputation 
    #
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
    @races.each do |race|
      return race['name'] if race['id'] == @character.race
    end
  end

  def get_class(class_id)
    @classes.each do |character_class|
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

  def get_icon_url(name)
    "http://media.blizzard.com/wow/icons/56/#{name}.jpg"
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

  def achievement_array
    achieves = [ ]
    @all_info['achievements']['achievementsCompleted'].reverse.first(25).each_with_index do |ach, index|
      tmp = { }
      tmp[:id] = ach
      tmp[:time] = get_achieve_timestamp(index)
      tmp[:name] = get_achievement(ach)
      tmp[:timestamp] = get_achieve_timestamp(index)
      achieves << tmp
    end
    achieves.sort_by { |hsh| hsh[:time] }.reverse
  end

  def get_achievement(ach)
    get_achievement_name(ach)
  end


  def get_achieve_timestamp(index)
    timestamp = @all_info['achievements']['achievementsCompletedTimestamp'][index]
    DateTime.strptime(timestamp.to_s,'%Q').strftime("%c")
  end

  def get_achievement_name(id)
    Nokogiri::HTML(HTTParty.get("http://www.wowhead.com/achievement=#{id}")).title.split("- Achievement").first.strip
  end

  def load_data
    @client             = BattleMuffin.new("7argtwb4rtuy2ccwcfjs74eapm52juhv") 
    char_name           = params[:character][:name].capitalize
    @realm              = params[:character][:realm]
    @realms             = get_realms
    @character          = @client.character_handler.search(@realm, char_name) 
    @all_info           = @character.all_info
    @items              = @all_info['items']
    @title              = get_current_title(@all_info['titles'])
    @races              = JSON.parse(File.read('app/helpers/races.json'))['races']
    @classes            = JSON.parse(File.read('app/helpers/classes.json'))['classes']
    @left_column_gear   = ["head", "neck", "shoulder", "back", "chest", "shirt", "tabard", "wrist" ]
    @right_column_gear  = ["hands", "waist", "legs", "feet", "finger1", "finger2", "trinket1", "trinket2" ]
    @mainhand           = [ "mainHand", "offHand" ] 
  end

  def get_standing(standing)
    case standing
    when 0
      "Hated"
    when 1
      "Acquaintance"
    when 2
      "Unfriendly"
    when 3
      "Neutral"
    when 4
      "Friendly"
    when 5
      "Honored"
    when 6
      "Revered"
    when 7
      "Exalted"
    else
      "Error"
    end
  end
end
