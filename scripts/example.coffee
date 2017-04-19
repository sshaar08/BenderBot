# Description:
#   Example scripts for you to examine and try out.
#
# Notes:
#   They are commented out by default, because most of them are pretty silly and
#   wouldn't be useful and amusing enough for day to day huboting.
#   Uncomment the ones you want to try and experiment with.
#
#   These are from the scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->

   robot.hear /badger/i, (res) ->
     res.send "Badgers? BADGERS? WE DON'T NEED NO STINKIN BADGERS"
   
   robot.respond /DIE$/i, (msg) ->
     msg.send "Goodbye, cruel world."
     process.exit 0

  #
  # robot.respond /open the (.*) doors/i, (res) ->
  #   doorType = res.match[1]
  #   if doorType is "pod bay"
  #     res.reply "I'm afraid I can't let you do that."
  #   else
  #     res.reply "Opening #{doorType} doors"
  #
   robot.hear /I like pie/i, (res) ->
     res.emote "makes a freshly baked pie"

   kraken = ["http://giphy.com/gifs/animation-kraken-soDqW21ZbC1oc", "http://giphy.com/gifs/cephalopod-kraken-sorry-if-its-not-biology-enough-rGoyx8v1AgWbe"]
   robot.hear /\bkraken\b/, (res) ->
     res.send res.random kraken
  
   spam = [
    "https://www.photoshopgurus.com/forum/attachments/off-topic-games-discussions-etc-/3841d1305812606t-spam-wars-spamwithfrog-gif",
    "https://regmedia.co.uk/2015/05/01/spam_wall.jpg?x=648&y=348&crop=1",
    "https://i.ytimg.com/vi/FyhJKRTsgMU/maxresdefault.jpg",
    "https://s-media-cache-ak0.pinimg.com/originals/42/58/bf/4258bf6b2ca921185ce8e613a8df37ea.jpg",
    "https://s-media-cache-ak0.pinimg.com/736x/71/47/98/714798406995543583da89a5fd9c5402.jpg",
    "https://s-media-cache-ak0.pinimg.com/originals/16/4d/e1/164de15b43dc5cf85717b15698de68fb.jpg",
    "http://file.vintageadbrowser.com/l-45njutdpldm8j5.jpg",
    "https://s-media-cache-ak0.pinimg.com/236x/9d/72/33/9d7233b334db555c50dcea930f32e7a1.jpg",

   ]
   robot.respond /\bspam\b/, (res) ->
     res.send res.random spam
  

   hibiki = ["http://cdn.shopify.com/s/files/1/0719/6401/products/hibiki_harmony_grande.png?v=1480620707"]
   robot.hear /\hibiki\b/, (res) ->
     res.send res.random hibiki
   

  # james = ["https://goo.gl/photos/UT6p8AqT5wiDP7vp7"]
  # robot.hear /@james_park *.* (coconut|water)/i, (res) ->
  #   res.send res.random james
  

  #

  # lulz = ['lol', 'rofl', 'lmao']
  #
  # robot.respond /lulz/i, (res) ->
  #   res.send res.random lulz
  #
  # robot.topic (res) ->
  #   res.send "#{res.message.text}? That's a Paddlin'"
  #
  #
  # enterReplies = ['Hi', 'Target Acquired', 'Firing', 'Hello friend.', 'Gotcha', 'I see you']
  # leaveReplies = ['Are you still there?', 'Target lost', 'Searching']
  #
  # robot.enter (res) ->
  #   res.send res.random enterReplies
  # robot.leave (res) ->
  #   res.send res.random leaveReplies
  #
   answer = 42
   answer_to_uq = ["Thats the answer, but what is the question?","The super computer has not been built yet. http://www.logicalhierarchy.com/blog/wp-content/uploads/2014/10/41_4.jpg "]
  #
   robot.respond /what is the answer to the ultimate question of life/, (res) ->
     unless answer?
       res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
       return
     res.send "#{answer}, but what is the question?"

   robot.respond /42/, (res) ->
     unless answer?
       res.send "Missing HUBOT_ANSWER_TO_THE_ULTIMATE_QUESTION_OF_LIFE_THE_UNIVERSE_AND_EVERYTHING in environment: please set and try again"
       return
     res.send res.random answer_to_uq
   
   robot.hear /random (.+) (.+)/i, (res) ->
    #(.+) (.+) (.+)
    #max = 6
    #min = 0
    max = res.match[1]
    min = res.match[2]
    console.log('max': max)
    console.log('min': min)

    #repeat = msg.match[3]
    #console.log(repeat)
    #console.log(message)  
    message = Math.floor((Math.random() * (max - min)) + min)
    res.send message

  #
  # robot.respond /you are a little slow/, (res) ->
  #   setTimeout () ->
  #     res.send "Who you calling 'slow'?"
  #   , 60 * 1000
  #
  # annoyIntervalId = null
  #
  # robot.respond /annoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #     return
  #
  #   res.send "Hey, want to hear the most annoying sound in the world?"
  #   annoyIntervalId = setInterval () ->
  #     res.send "AAAAAAAAAAAEEEEEEEEEEEEEEEEEEEEEEEEIIIIIIIIHHHHHHHHHH"
  #   , 1000
  #
  # robot.respond /unannoy me/, (res) ->
  #   if annoyIntervalId
  #     res.send "GUYS, GUYS, GUYS!"
  #     clearInterval(annoyIntervalId)
  #     annoyIntervalId = null
  #   else
  #     res.send "Not annoying you right now, am I?"
  #
  #
  # robot.router.post '/hubot/chatsecrets/:room', (req, res) ->
  #   room   = req.params.room
  #   data   = JSON.parse req.body.payload
  #   secret = data.secret
  #
  #   robot.messageRoom room, "I have a secret: #{secret}"
  #
  #   res.send 'OK'
  #
   robot.error (err, res) ->
     robot.logger.error "DOES NOT COMPUTE"
     if res?
       res.reply "DOES NOT COMPUTE"
  
  # robot.respond /have a soda/i, (res) ->
  #   # Get number of sodas had (coerced to a number).
  #   sodasHad = robot.brain.get('totalSodas') * 1 or 0
  #
  #   if sodasHad > 4
  #     res.reply "I'm too fizzy.."
  #
  #   else
  #     res.reply 'Sure!'
  #
  #     robot.brain.set 'totalSodas', sodasHad+1
  #
  # robot.respond /sleep it off/i, (res) ->
  #   robot.brain.set 'totalSodas', 0
  #   res.reply 'zzzzz'
