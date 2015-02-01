class GuildsController < ApplicationController
  helper_method :get_guild_name, :get_guild_member_count, :get_guild_description, :get_news_feed
  def index
    #
  end

  def show
    @nav_elements   = [ "Summary", "Roster", "News", "Achievements", "Challenge Mode" ]
    client         = BattleMuffin.new("7argtwb4rtuy2ccwcfjs74eapm52juhv") 
    @guild_name     = params[:id].split("_").first.strip
    @realm          = params[:id].split("_").last.strip
    @guild          = client.guild_handler.search(@realm, @guild_name)
    @all_info       = @guild.all_info
  end

  def get_guild_name
    if @guild.name.include?("%20")
      return @guild.name.gsub!("%20", " ")
    else
      return @guild.name
    end
  end

  def get_guild_member_count
    @all_info['members'].count
  end

  def get_guild_description
    "#{get_side} Guild, #{@realm}. #{get_guild_member_count} members"
  end

  def get_side
    if @guild.side == 1
      "Horde"
    else
      "Alliance"
    end
  end

  def get_item_description(id)
    Nokogiri::XML(HTTParty.get("http://www.wowhead.com/item=#{id}&xml").body).css('name').children.text
  end

  def get_news_feed
    feed = [ ]
    @all_info['news'].first(25).each do |item|
      result = { }
      result['character'] = item['character']
      if item['type'] == 'itemLoot'
        result['string'] = " obtained"
        result['link'] = get_item_description(item['itemId'])
        result['item_id'] = item['itemId']
      elsif item['type'] == 'playerAchievement'
        result['string'] = " earned the achievement "
        result['link'] = "#{item['achievement']['title']} for #{item['achievement']['points']} points"
      elsif item['type'] == 'itemPurchase'
        result['string'] = " purchased item"
        result['link'] = get_item_description(item['itemId'])
        result['item_id'] = item['itemId']
      elsif item['type'] == 'itemCraft'
        result['string'] = " crafted item"
        result['link'] = get_item_description(item['itemId'])
        result['item_id'] = item['itemId']
      end
      feed << result
    end
    feed
  end
end
