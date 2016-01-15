# Description:
#   Track QA Devices
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DEVICE_ADMIN
#
# Commands:
#   ADMIN ONLY COMMANDS 
#   ===
#   [person] has my [device] - Lend a device to someone. Will also creates the device if it doesn't exist. 
#   [person] returned my [device] - Set a device as returned.
#   return my [device] - Set a device as returned.
#   I have a [device] - Start keep track of a device
#   Forget about my [device] - Stop keeping track of a device
#   Wheres my shit  - Lists QA devices and their status
#
#   PUBLIC USER COMMANDS
#   ===
#   Where is the [device] - Shows status of a device
#   list devices - Shows status of all devices
#   whos your daddy - Shows device admin
#
#
# Author:
#   Brian Lam

class QA_Device_Tracker

  constructor: (@robot) ->
    @cache = {}

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.qa_device_tracker
        @cache = @robot.brain.data.qa_device_tracker

  add: (device) ->
    response = "I'll be keeping track of the " + device + " for you."
    if (@cache[device])
      response = device + ": Previous status was " + @cache[device]
    else 
      @cache[device] = "With QA"
      @robot.brain.data.qa_device_tracker = @cache
    response

  remove: (device) ->
    response = "What is this " + device + " that you're talking about..."
    if @cache[device]
      delete @cache[device]
      @robot.brain.data.qa_device_tracker = @cache
      response = "Cya, " + device
    response

  lend: (device, person) ->
    response = "I don't know about the " + device
    if (@cache[device])
      @cache[device] = "Lent to " + person
      @robot.brain.data.qa_device_tracker = @cache
      response = device + " is now with " + person + ". Good luck please don't break it!"
    response
    
  list: -> 
    devices = []
    for key, val of @cache
      devices.push({name: key, status: val})
    devices    

  return: (device) ->
    response = "No device found"
    if (@cache[device])
      @cache[device] = "With QA"
      response = device + " is now safe at home with QA <3"
      @robot.brain.data.qa_device_tracker = @cache
    response

  status: (device) ->
    if (@cache[device])
      @cache[device]
    else
      ""

  get: (thing) ->
    k = if @cache[thing] then @cache[thing] else 0
    return k

module.exports = (robot) ->
  tracker = new QA_Device_Tracker robot
  # Set device_admin to "Shell" for local environment

  device_admins = process.env.HUBOT_DEVICE_ADMIN or ["sshaar08", "judy", "Shell"]
  lowercase_devices = process.env.HUBOT_DEVICE_LOWERCASE or "true"



  robot.respond /I have (a|an) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      device = msg.match[2]
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.add device

  robot.respond /(.+) has (the|my) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      person = msg.match[1]
      device = msg.match[3]
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.add device
      msg.send tracker.lend(device, person)

  robot.respond /(.+) returned (the|my) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      device = msg.match[3]
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.return(device)

  robot.respond /return (the|my) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      device = msg.match[2]
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.return(device)

  robot.respond /(Forget about (the|my) (.+))/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      device = msg.match[3];
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.remove device

  robot.respond /(list device(s)?|(QA Devices)|(Where(\')?s my shit)|qa shit)/i, (msg) ->
    response = ["Tracked QA devices:"]
    for device, num in tracker.list()
      response.push "#{device.name} - #{device.status}"
    msg.send response.join("\n")

  robot.respond /(device-status|where is my|wheres my|where is the) (.+)/i, (msg) ->
    device = msg.match[2];
    device = device.toLowerCase() if lowercase_devices
    msg.send tracker.status(device)

  robot.respond /(whos your daddy)/i, (msg) ->
    msg.send device_admins  

  robot.hear /((qa)? device (tracker)? help)/i, (msg) ->
    response = ["QA Device Tracker Help"]
    response.push("Commands:")
    response.push("ADMIN ONLY COMMANDS ")
    response.push("===")
    response.push("[person] has my [device] - Lend a device to someone. Creates the device if it doesn't exist. Will log the time. ")
    response.push("[person] returned my [device] - Set a device as returned.")
    response.push("return my [device] - Set a device as returned.")
    response.push("I have a [device] - Start keep track of a device")
    response.push("Forget about my [device] - Stop keeping track of a device")
    response.push("Wheres my shit  - Lists QA devices and their status")
    response.push("PUBLIC USER COMMANDS")
    response.push("===")
    response.push("Where is the [device] - Shows status of a device")
    response.push("list devices - Shows status of all devices")
    response.push("whos your daddy - Shows device admin")
    msg.send response.join("\n")
