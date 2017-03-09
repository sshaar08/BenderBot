# Description:
#   Pulls a random link from /r/funny
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot <funny> Pulls a random link from from the following reddit group: http://www.reddit.com/r/funny.json [funny]
#
# Authors:
#   Brian Lam

module.exports = (robot) ->

  robot.respond /funny/i, (msg) ->

    msg.http("https://www.reddit.com/r/funny.json")
    .get() (err, res, body) ->
      try
        result = JSON.parse(body)

        urls = [ ]
        for child in result.data.children
          urls.push(child.data.url)

        if urls.count <= 0
          msg.send "People aren't being funny right now..."
          return

        rnd = Math.floor(Math.random()*urls.length)
        picked_url = urls[rnd]
        msg.send picked_url



  robot.respond /inspo/i, (msg) ->

    msg.http("https://www.reddit.com/r/wholesomegifs.json")
    .get() (err, res, body) ->
      try
        result = JSON.parse(body)

        urls = [ ]
        for child in result.data.children
          urls.push(child.data.url)

        if urls.count <= 0
          msg.send "People aren't finding insperation right now..."
          return

        rnd = Math.floor(Math.random()*urls.length)
        picked_url = urls[rnd]
        msg.send picked_url