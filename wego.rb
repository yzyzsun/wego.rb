#!/usr/bin/env ruby

require "json"
require "uri"
require "net/http"

class Wego

  IconUnknown = [
    "    .-.      ",
    "     __)     ",
    "    (        ",
    "     `-’     ",
    "      •      ",
  ]
  IconSunny = [
    "\033[38;5;226m    \\   /    \033[0m",
    "\033[38;5;226m     .-.     \033[0m",
    "\033[38;5;226m  ― (   ) ―  \033[0m",
    "\033[38;5;226m     `-’     \033[0m",
    "\033[38;5;226m    /   \\    \033[0m",
  ]
  IconPartlyCloudy = [
    "\033[38;5;226m   \\  /\033[0m      ",
    "\033[38;5;226m _ /\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m   \\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "             ",
  ]
  IconCloudy = [
    "             ",
    "\033[38;5;250m     .--.    \033[0m",
    "\033[38;5;250m  .-(    ).  \033[0m",
    "\033[38;5;250m (___.__)__) \033[0m",
    "             ",
  ]
  IconVeryCloudy = [
    "             ",
    "\033[38;5;240;1m     .--.    \033[0m",
    "\033[38;5;240;1m  .-(    ).  \033[0m",
    "\033[38;5;240;1m (___.__)__) \033[0m",
    "             ",
  ]
  IconLightShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;111m     ‘ ‘ ‘ ‘ \033[0m",
    "\033[38;5;111m    ‘ ‘ ‘ ‘  \033[0m",
  ]
  IconHeavyShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;240;1m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;240;1m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;240;1m(___(__) \033[0m",
    "\033[38;5;21;1m   ‚‘‚‘‚‘‚‘  \033[0m",
    "\033[38;5;21;1m   ‚’‚’‚’‚’  \033[0m",
  ]
  IconLightSnowShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;255m     *  *  * \033[0m",
    "\033[38;5;255m    *  *  *  \033[0m",
  ]
  IconHeavySnowShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;240;1m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;240;1m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;240;1m(___(__) \033[0m",
    "\033[38;5;255;1m    * * * *  \033[0m",
    "\033[38;5;255;1m   * * * *   \033[0m",
  ]
  IconLightSleetShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;111m     ‘ \033[38;5;255m*\033[38;5;111m ‘ \033[38;5;255m* \033[0m",
    "\033[38;5;255m    *\033[38;5;111m ‘ \033[38;5;255m*\033[38;5;111m ‘  \033[0m",
  ]
  IconThunderyShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;228;5m    ⚡\033[38;5;111;25m‘ ‘\033[38;5;228;5m⚡\033[38;5;111;25m‘ ‘ \033[0m",
    "\033[38;5;111m    ‘ ‘ ‘ ‘  \033[0m",
  ]
  IconThunderyHeavyRain = [
    "\033[38;5;240;1m     .-.     \033[0m",
    "\033[38;5;240;1m    (   ).   \033[0m",
    "\033[38;5;240;1m   (___(__)  \033[0m",
    "\033[38;5;21;1m  ‚‘\033[38;5;228;5m⚡\033[38;5;21;25m‘‚\033[38;5;228;5m⚡\033[38;5;21;25m‚‘   \033[0m",
    "\033[38;5;21;1m  ‚’‚’\033[38;5;228;5m⚡\033[38;5;21;25m’‚’   \033[0m",
  ]
  IconThunderySnowShowers = [
    "\033[38;5;226m _`/\"\"\033[38;5;250m.-.    \033[0m",
    "\033[38;5;226m  ,\\_\033[38;5;250m(   ).  \033[0m",
    "\033[38;5;226m   /\033[38;5;250m(___(__) \033[0m",
    "\033[38;5;255m     *\033[38;5;228;5m⚡\033[38;5;255;25m *\033[38;5;228;5m⚡\033[38;5;255;25m * \033[0m",
    "\033[38;5;255m    *  *  *  \033[0m",
  ]
  IconLightRain = [
    "\033[38;5;250m     .-.     \033[0m",
    "\033[38;5;250m    (   ).   \033[0m",
    "\033[38;5;250m   (___(__)  \033[0m",
    "\033[38;5;111m    ‘ ‘ ‘ ‘  \033[0m",
    "\033[38;5;111m   ‘ ‘ ‘ ‘   \033[0m",
  ]
  IconHeavyRain = [
    "\033[38;5;240;1m     .-.     \033[0m",
    "\033[38;5;240;1m    (   ).   \033[0m",
    "\033[38;5;240;1m   (___(__)  \033[0m",
    "\033[38;5;21;1m  ‚‘‚‘‚‘‚‘   \033[0m",
    "\033[38;5;21;1m  ‚’‚’‚’‚’   \033[0m",
  ]
  IconLightSnow = [
    "\033[38;5;250m     .-.     \033[0m",
    "\033[38;5;250m    (   ).   \033[0m",
    "\033[38;5;250m   (___(__)  \033[0m",
    "\033[38;5;255m    *  *  *  \033[0m",
    "\033[38;5;255m   *  *  *   \033[0m",
  ]
  IconHeavySnow = [
    "\033[38;5;240;1m     .-.     \033[0m",
    "\033[38;5;240;1m    (   ).   \033[0m",
    "\033[38;5;240;1m   (___(__)  \033[0m",
    "\033[38;5;255;1m   * * * *   \033[0m",
    "\033[38;5;255;1m  * * * *    \033[0m",
  ]
  IconLightSleet = [
    "\033[38;5;250m     .-.     \033[0m",
    "\033[38;5;250m    (   ).   \033[0m",
    "\033[38;5;250m   (___(__)  \033[0m",
    "\033[38;5;111m    ‘ \033[38;5;255m*\033[38;5;111m ‘ \033[38;5;255m*  \033[0m",
    "\033[38;5;255m   *\033[38;5;111m ‘ \033[38;5;255m*\033[38;5;111m ‘   \033[0m",
  ]
  IconFog = [
    "             ",
    "\033[38;5;251m _ - _ - _ - \033[0m",
    "\033[38;5;251m  _ - _ - _  \033[0m",
    "\033[38;5;251m _ - _ - _ - \033[0m",
    "             ",
  ]

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
    395 => IconHeavySnowShowers,
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

  APIKey = "f6d8a7f33686c57b00315e785aa35"
  APIBaseURL = "https://api.worldweatheronline.com/free/v2/weather.ashx"
  IPQueryURL = "https://api.ipify.org"

  WrongLocation = Class.new(StandardError)
  WrongNumOfDays = Class.new(StandardError)

  def initialize(location, days)
    raise WrongNumOfDays if days < 0 || days > 5
    @params = {
      "q"           => location,
      "num_of_days" => days.to_i,
      "tp"          => 12,
      "key"         => APIKey,
      "format"      => "json",
      "lang"        => "zh",
    }
  end

  def get
    uri = URI(APIBaseURL)
    uri.query = URI.encode_www_form(@params)
    res = Net::HTTP.get_response(uri)
    @data = JSON.parse(res.body)["data"]
    raise WrongLocation, @data["error"][0]["msg"] if @data["error"]
  end

  def current
    weather = @data["current_condition"][0]
    wef(weather, true).join("\n")
  end

  def daily(day)
    weather = @data["weather"][day]["hourly"]
    date = @data["weather"][day]["date"]
    "                         ┌────────────┐                         \n" +
    "┌────────────────────────┤ "+ date +" ├─────────────────────────┐\n" +
    "│             早晨       └──────┬─────┘       夜晚              │\n" +
    "├───────────────────────────────┼───────────────────────────────┤\n" +
    (0..4).map{|i| "│#{wef(weather[0])[i]}│#{wef(weather[1])[i]}│\n"}.join +
    "└───────────────────────────────┴───────────────────────────────┘"
  end

  def to_s
    "当前天气信息：#{@data["request"][0]["query"] if @data["request"][0]["type"] == "City"}\n\n" +
    "#{current}\n" +
    (0...@params["num_of_days"]).map{|i| daily(i)}.join("\n")
  end

  private

    def tempf(weather, current)
      def color(temp)
        col = case temp
              when -Float::INFINITY..-16 then 21
              when -15..-13 then 27
              when -12..-10 then 33
              when -9..-7 then 39
              when -6..-4 then 45
              when -3..-1 then 51
              when 0..1 then 50
              when 2..3 then 49
              when 4..5 then 48
              when 6..7 then 47
              when 8..9 then 46
              when 10..12 then 82
              when 13..15 then 118
              when 16..18 then 154
              when 19..21 then 190
              when 22..24 then 226
              when 25..27 then 220
              when 28..30 then 214
              when 31..33 then 208
              when 34..36 then 202
              when 37..Float::INFINITY then 196
              end
        "\033[38;5;#{col}m#{temp}\033[0m"
      end
      tempC = current ? weather["temp_C"] : weather["tempC"]
      temps = [tempC.to_i, weather["FeelsLikeC"].to_i].sort
      "#{color(temps[0])} - #{color(temps[1])} °C" +
      (tempC.size + weather["FeelsLikeC"].size < 4 ? "\t\t" : "\t")
    end

    def rainf(weather, current)
      if current
        "降水量：#{weather["precipMM"]} mm\t"
      else
        "降水概率：#{weather["chanceofrain"]}%\t"
      end
    end

    def humif(weather)
      "湿度：#{weather["humidity"]}%\t\t"
    end

    def windf(weather)
      def color(speed)
        col = case speed
              when 1..3 then 82
              when 4..6 then 118
              when 7..9 then 154
              when 10..12 then 190
              when 13..15 then 226
              when 16..19 then 220
              when 20..23 then 214
              when 24..27 then 208
              when 28..31 then 202
              when 32..Float::INFINITY then 196
              else 46
              end
        "\033[38;5;#{col}m#{speed}\033[0m"
      end
      dir, speed = weather["winddir16Point"], weather["windspeedKmph"].to_i
      "#{WindDir[dir]} #{color speed} km/h\t\t"
    end

    def wef(weather, current = false)
      icon = Codes[weather["weatherCode"].to_i]
      icon ||= IconUnknown
      desc = weather["lang_zh"][0]["value"] + "\t"
      desc += "\t" if desc.size <= 5
      [
        "#{icon[0]}#{desc}",
        "#{icon[1]}#{tempf weather, current}",
        "#{icon[2]}#{rainf weather, current}",
        "#{icon[3]}#{humif weather}",
        "#{icon[4]}#{windf weather}",
      ]
    end

end

if $0 == __FILE__
  begin
    location, days = nil, 2
    ARGV.each do |arg|
      if arg =~ /\D/
        location = arg
      else
        days = arg.to_i
      end
    end
    if days > 5
      STDERR.puts "查询天数最大为 5"
      days = 5
    end
    if location.nil?
      STDERR.print "未指定城市，尝试使用 IP 查询："
      public_ip = Net::HTTP.get(URI(Wego::IPQueryURL))
      STDERR.puts public_ip
      wego = Wego.new(public_ip, days)
    else
      wego = Wego.new(location, days)
    end
    wego.get
    puts wego
  rescue SocketError
    STDERR.puts "\033[31m错误：请检查网络连接\033[0m"
  rescue Wego::WrongLocation
    STDERR.puts "\033[31m错误：未找到指定的城市或 IP\033[0m"
  end
end
