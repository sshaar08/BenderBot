# Description:
#   Show a random image from peopleofwalmart.com
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot walmart me - Show random Walmart image [walmart]
#   hubot walmart ban - Remove NSFW Walmart image URL (lol) [walmart]
#
# Author:
#   kevinsawicki
#   Modified by Brian Lam
#
#   https://github.com/github/hubot-scripts/blob/master/src/scripts/walmart.coffee

class WalmartScraper

  constructor: (@robot) -> 
    @cache = []

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.WalmartScraper
        @cache = @robot.brain.data.WalmartScraper

  ban: (url) ->
    @cache.push(url)
    @robot.brain.data.WalmartScraper = @cache

  ban_list: ->
    @cache

module.exports = (robot) ->
  scraper = new WalmartScraper robot

  robot.respond /walmart( me)?/i, (msg) ->
    msg.http("http://www.peopleofwalmart.com/?random=1")
    .get() (error, response) ->
      msg.http(response.headers['location'])
        .get() (err, res, body) ->
          col1 = body.indexOf '<div class="nest">'
          if (col1 != -1)
            body = body.substring col1
            match = body.match /http:\/\/media.peopleofwalmart.com\/wp-content\/uploads\/\d\d\d\d\/\d\d\/.+?\.jpg/g
            if (match)
              if (scraper.ban_list().indexOf(match[0]) >= 0)
                msg.send "Try again! Found a NSFW image..."
              else
                msg.send match[0]

  robot.respond /walmart ban (.+)/i, (msg) ->
    ban_url = msg.match[1]
    scraper.ban ban_url
    msg.send "Banned " + ban_url
