# wego.rb

wego.rb 是用 Ruby 编写的终端天气查询应用，天气数据由 [World Weather Online](http://www.worldweatheronline.com) 提供。

基于 Go 语言项目 [schachmat/wego](https://github.com/schachmat/wego) 改写，遵循其 [LICENSE](https://github.com/schachmat/wego/blob/master/LICENSE)。

## 使用

* `ruby wego.rb [城市]`
* 未指定城市则使用当前 IP 查询，返回当前天气。

## 运行环境

* Ruby >= 2.0
* 支持 UTF-8 的 256 色终端
