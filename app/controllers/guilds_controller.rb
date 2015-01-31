class GuildsController < ApplicationController
  helper_method :get_guild_name, :get_guild_member_count, :get_guild_description, :get_news_feed
  def index
    #
  end

  def show
    @nav_elements   = [ "Summary", "Roster", "News", "Achievements", "Challenge Mode" ]
    @client         ||= BattleMuffin.new("7argtwb4rtuy2ccwcfjs74eapm52juhv") 
    @guild_name     ||= params[:id].split("_").first.strip
    @realm          ||= params[:id].split("_").last.strip
    @guild          ||= @client.guild_handler.search(@realm, @guild_name)
  end

  def get_guild_name
    @guild.name.gsub!("%20", " ")
  end

  def get_guild_member_count
    @guild.get_members.count
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

  def get_news_feed
    feed = [ ]
    @guild.get_news.each do |item|
      if item['type'] == 'itemLoot'
        feed << "#{item['character']} obtained #{item['itemId']}"
      elsif item['type'] == 'playerAchievement'
        feed << "#{item['character']} earned the achievement #{item['achievement']['title']} for #{item['achievement']['points']} points"
      end
    end
    feed
  end
end
