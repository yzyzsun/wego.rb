#!/usr/bin/env ruby

require 'json'
require 'uri'
require 'net/http'
require 'socket'

class Wego

  IconUnknown = [
    "    .-.      ",
    "     __)     ",
    "    (        ",
    "     `-’     ",
    "      •      "]
  IconSunny = [
    "\033[38;5;226m    \\   /    \033[0m",
    "\033[38;5;226m     .-.     \033[0m",
    "\033[38;5;226m  ― (   ) ―  \033[0m",
    "\033[38;5;226m     `-’     \033[0m",
    "\033[38;5;226m    /   \\    \033[0m"]
  IconPartlyCloudy = [
    "\033[38;5;226m   \\  /\033[0m      ",
    "\033[38;5;226m _ /\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m   \\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "             "]
  IconCloudy = [
    "             ",
    "\033[38;5;250m     .--.    \033[0m",
    "\033[38;5;250m  .-(    ).  \033[0m",
    "\033[38;5;250m (___.__)__) \033[0m",
    "             "]
  IconVeryCloudy = [
    "             ",
    "\033[38;5;240;1m     .--.    \033[0m",
    "\033[38;5;240;1m  .-(    ).  \033[0m",
    "\033[38;5;240;1m (___.__)__) \033[0m",
    "             "]
  IconLightShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;111m     ‘ ‘ ‘ ‘ \033[0m",
    "\033[38;5;111m    ‘ ‘ ‘ ‘  \033[0m"]
  IconHeavyShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;240;1m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;240;1m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;240;1m(___(__) \033[0m",
    "\033[38;5;21;1m   ‚‘‚‘‚‘‚‘  \033[0m",
    "\033[38;5;21;1m   ‚’‚’‚’‚’  \033[0m"]
  IconLightSnowShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;255m     *  *  * \033[0m",
    "\033[38;5;255m    *  *  *  \033[0m"]
  IconHeavySnowShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;240;1m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;240;1m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;240;1m(___(__) \033[0m",
    "\033[38;5;255;1m    * * * *  \033[0m",
    "\033[38;5;255;1m   * * * *   \033[0m"]
  IconLightSleetShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;111m     ‘ \033[38;5;255m*\033[38;5;111m ‘ \033[38;5;255m* \033[0m",
    "\033[38;5;255m    *\033[38;5;111m ‘ \033[38;5;255m*\033[38;5;111m ‘  \033[0m"]
  IconThunderyShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;228;5m    ⚡\033[38;5;111;25m‘ ‘\033[38;5;228;5m⚡\033[38;5;111;25m‘ ‘ \033[0m",
    "\033[38;5;111m    ‘ ‘ ‘ ‘  \033[0m"]
  IconThunderyHeavyRain = [
    "\033[38;5;240;1m     .-.     \033[0m",
    "\033[38;5;240;1m    (   ).   \033[0m",
    "\033[38;5;240;1m   (___(__)  \033[0m",
    "\033[38;5;21;1m  ‚‘\033[38;5;228;5m⚡\033[38;5;21;25m‘‚\033[38;5;228;5m⚡\033[38;5;21;25m‚‘   \033[0m",
    "\033[38;5;21;1m  ‚’‚’\033[38;5;228;5m⚡\033[38;5;21;25m’‚’   \033[0m"]
  IconThunderySnowShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;255m     *\033[38;5;228;5m⚡\033[38;5;255;25m *\033[38;5;228;5m⚡\033[38;5;255;25m * \033[0m",
    "\033[38;5;255m    *  *  *  \033[0m"]
  IconLightRain = [
    "\033[38;5;250m     .-.     \033[0m",
    "\033[38;5;250m    (   ).   \033[0m",
    "\033[38;5;250m   (___(__)  \033[0m",
    "\033[38;5;111m    ‘ ‘ ‘ ‘  \033[0m",
    "\033[38;5;111m   ‘ ‘ ‘ ‘   \033[0m"]
  IconHeavyRain = [
    "\033[38;5;240;1m     .-.     \033[0m",
    "\033[38;5;240;1m    (   ).   \033[0m",
    "\033[38;5;240;1m   (___(__)  \033[0m",
    "\033[38;5;21;1m  ‚‘‚‘‚‘‚‘   \033[0m",
    "\033[38;5;21;1m  ‚’‚’‚’‚’   \033[0m"]
  IconLightSnow = [
    "\033[38;5;250m     .-.     \033[0m",
    "\033[38;5;250m    (   ).   \033[0m",
    "\033[38;5;250m   (___(__)  \033[0m",
    "\033[38;5;255m    *  *  *  \033[0m",
    "\033[38;5;255m   *  *  *   \033[0m"]
  IconHeavySnow = [
    "\033[38;5;240;1m     .-.     \033[0m",
    "\033[38;5;240;1m    (   ).   \033[0m",
    "\033[38;5;240;1m   (___(__)  \033[0m",
    "\033[38;5;255;1m   * * * *   \033[0m",
    "\033[38;5;255;1m  * * * *    \033[0m"]
  IconLightSleet = [
    "\033[38;5;250m     .-.     \033[0m",
    "\033[38;5;250m    (   ).   \033[0m",
    "\033[38;5;250m   (___(__)  \033[0m",
    "\033[38;5;111m    ‘ \033[38;5;255m*\033[38;5;111m ‘ \033[38;5;255m*  \033[0m",
    "\033[38;5;255m   *\033[38;5;111m ‘ \033[38;5;255m*\033[38;5;111m ‘   \033[0m"]
  IconFog = [
    "             ",
    "\033[38;5;251m _ - _ - _ - \033[0m",
    "\033[38;5;251m  _ - _ - _  \033[0m",
    "\033[38;5;251m _ - _ - _ - \033[0m",
    "             "]

  Codes = {
    113 => IconSunny,
    116 => IconPartlyCloudy,
    119 => IconCloudy,
    122 => IconVeryCloudy,
    143 => IconFog,
    176 => IconLightShowers,
    179 => IconLightSleetShowers,
    182 => IconLightSleet,
    185 => IconLightSleet,
    200 => IconThunderyShowers,
    227 => IconLightSnow,
    230 => IconHeavySnow,
    248 => IconFog,
    260 => IconFog,
    263 => IconLightShowers,
    266 => IconLightRain,
    281 => IconLightSleet,
    284 => IconLightSleet,
    293 => IconLightRain,
    296 => IconLightRain,
    299 => IconHeavyShowers,
    302 => IconHeavyRain,
    305 => IconHeavyShowers,
    308 => IconHeavyRain,
    311 => IconLightSleet,
    314 => IconLightSleet,
    317 => IconLightSleet,
    320 => IconLightSnow,
    323 => IconLightSnowShowers,
    326 => IconLightSnowShowers,
    329 => IconHeavySnow,
    332 => IconHeavySnow,
    335 => IconHeavySnowShowers,
    338 => IconHeavySnow,
    350 => IconLightSleet,
    353 => IconLightShowers,
    356 => IconHeavyShowers,
    359 => IconHeavyRain,
    362 => IconLightSleetShowers,
    365 => IconLightSleetShowers,
    368 => IconLightSnowShowers,
    371 => IconHeavySnowShowers,
    374 => IconLightSleetShowers,
    377 => IconLightSleet,
    386 => IconThunderyShowers,
    389 => IconThunderyHeavyRain,
    392 => IconThunderySnowShowers,
    395 => IconHeavySnowShowers
  }

  WindDir = {
    "N"   => "\033[1m↓\033[0m",
    "NNE" => "\033[1m↓\033[0m",
    "NE"  => "\033[1m↙\033[0m",
    "ENE" => "\033[1m↙\033[0m",
    "E"   => "\033[1m←\033[0m",
    "ESE" => "\033[1m←\033[0m",
    "SE"  => "\033[1m↖\033[0m",
    "SSE" => "\033[1m↖\033[0m",
    "S"   => "\033[1m↑\033[0m",
    "SSW" => "\033[1m↑\033[0m",
    "SW"  => "\033[1m↗\033[0m",
    "WSW" => "\033[1m↗\033[0m",
    "W"   => "\033[1m→\033[0m",
    "WNW" => "\033[1m→\033[0m",
    "NW"  => "\033[1m↘\033[0m",
    "NNW" => "\033[1m↘\033[0m",
  }

  APIBaseURL = 'https://api.worldweatheronline.com/free/v2/weather.ashx'
  APIKey = 'f6d8a7f33686c57b00315e785aa35'

  class CannotGetData < StandardError; end

  def initialize(location, days)
    @params = {}
    @params['q'] = location
    @params['num_of_days'] = days.to_i
    @params['tp'] = 12;
    @params['key'] = APIKey
    @params['format'] = 'json'
    @params['lang'] = 'zh'
  end

  def get
    uri = URI.parse(APIBaseURL)
    uri.query = URI.encode_www_form(@params)
    res = Net::HTTP.get_response(uri)
    @data = JSON.parse(res.body)['data']
    raise CannotGetData, @data['error'][0]['msg'] if @data['error']
  end

  def format_current
    cond = @data['current_condition'][0]
    format_cond(cond, true).join("\n")
  end

  def format_day(day)
    hourly = @data['weather'][day]['hourly']
    date = @data['weather'][day]['date']
    "                         ┌────────────┐                         \n" +
    "┌────────────────────────| "+ date +" |─────────────────────────┐\n" +
    "│             白天       └──────┬─────┘       夜间              │\n" +
    "├───────────────────────────────┼───────────────────────────────┤\n" +
    (0..4).map{|i| "|#{format_cond(hourly[0])[i]}|#{format_cond(hourly[1])[i]}|\n"}.join +
    "└───────────────────────────────┴───────────────────────────────┘"
  end

  def to_s
    "当前天气信息：#{@data['request'][0]['query'] if @data['request'][0]['type'] == 'City'}\n\n" +
    "#{format_current}\n" +
    (0...@params['num_of_days']).map{|i| format_day(i)}.join("\n")
  end

  private

    def format_temp(cond, current)
      def color(temp)
        col = case temp
          when -Float::INFINITY..-16; 21
          when -15..-13; 27
          when -12..-10; 33
          when -9..-7; 39
          when -6..-4; 45
          when -3..-1; 51
          when 0..1; 50
          when 2..3; 49
          when 4..5; 48
          when 6..7; 47
          when 8..9; 46
          when 10..12; 82
          when 13..15; 118
          when 16..18; 154
          when 19..21; 190
          when 22..24; 226
          when 25..27; 220
          when 28..30; 214
          when 31..33; 208
          when 34..36; 202
          when 37..Float::INFINITY; 196
        end
        "\033[38;5;#{col}m#{temp}\033[0m"
      end
      tempC = current ? cond['temp_C'] : cond['tempC']
      temps = [tempC.to_i, cond['FeelsLikeC'].to_i].sort
      "#{color(temps[0])} - #{color(temps[1])} °C" +
      (tempC.size + cond['FeelsLikeC'].size < 4 ? "\t\t" : "\t")
    end

    def format_rain(cond, current)
      if current
        "降水量：#{cond['precipMM']} mm\t"
      else
        "降水概率：#{cond['chanceofrain']}%\t"
      end
    end

    def format_humi(cond)
      "湿度：#{cond['humidity']}%\t\t"
    end

    def format_wind(cond)
      def color(speed)
        col = case speed
          when 1..3; 82
          when 4..6; 118
          when 7..9; 154
          when 10..12; 190
          when 13..15; 226
          when 16..19; 220
          when 20..23; 214
          when 24..27; 208
          when 28..31; 202
          when 32..Float::INFINITY; 196
          else 46
        end
        "\033[38;5;#{col}m#{speed}\033[0m"
      end
      dir, speed = cond['winddir16Point'], cond['windspeedKmph'].to_i
      "#{WindDir[dir]} #{color speed} km/h\t\t"
    end

    def format_cond(cond, current = false)
      icon = Codes[cond['weatherCode'].to_i]
      icon ||= IconUnknown
      desc = cond['lang_zh'][0]['value'] + "\t"
      desc += "\t" if desc.size <= 5
      [ "#{icon[0]}#{desc}",
        "#{icon[1]}#{format_temp cond, current}",
        "#{icon[2]}#{format_rain cond, current }",
        "#{icon[3]}#{format_humi cond}",
        "#{icon[4]}#{format_wind cond}"
      ]
    end

end

if __FILE__ == $0
  begin
    location, days = nil, 2
    ARGV.each do |arg|
      if arg =~ /[^\d]/
        location = arg
      else
        days = arg.to_i
      end
    end
    if location.nil?
      print "未指定城市，尝试使用 IP 查询："
      public_ip = Net::HTTP.get(URI.parse('https://api.ipify.org'))
      puts public_ip
      wego = Wego.new(public_ip, days)
    else
      wego = Wego.new(location, days)
    end
    wego.get
    puts wego
  rescue SocketError
    puts "\033[31m错误：请检查网络连接\033[0m"
  rescue Wego::CannotGetData
    puts "\033[31m错误：未找到指定的城市或 IP\033[0m"
  end
end
