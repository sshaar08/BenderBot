# Description:
#   Track QA Devices
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   ADMIN ONLY COMMANDS 
#   ===
#   [person] has my [device] - Lend a device to someone. Creates the device if it doesn't exist. Will log the time. 
#   [person] returned my [device] - Set a device as returned.
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
    response = "What is this " + device + "that you're talking about..."
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
  device_admin = process.env.DEVICE_ADMIN or "Shell"


  robot.respond /I have a (.+)/i, (msg) ->
    if msg.message.user.name == device_admin
      device = msg.match[1]
      msg.send tracker.add device


  robot.respond /(.+) has my (.+)/i, (msg) ->
    if msg.message.user.name == device_admin
      person = msg.match[1]
      device = msg.match[2]
      msg.send tracker.add device
      msg.send tracker.lend(device, person)

  robot.respond /(.+) returned my (.+)/i, (msg) ->
    if msg.message.user.name == device_admin
      device = msg.match[2]
      msg.send tracker.return(device)

  robot.respond /return my (.+)/i, (msg) ->
    if msg.message.user.name == device_admin
      device = msg.match[1]
      msg.send tracker.return(device)

  robot.respond /(Forget about my (.+))/i, (msg) ->
    if msg.message.user.name == device_admin
      device = msg.match[2];
      msg.send tracker.remove device

  robot.respond /(list device(s)?|(QA Devices)|(Where(\')?s my shit)|qa shit)/i, (msg) ->
    response = ["Tracked QA devices:"]
    for device, num in tracker.list()
      response.push "#{device.name} - #{device.status}"
    msg.send response.join("\n")

  robot.respond /(device-status|where is my|wheres my|where is the) (.+)/i, (msg) ->
    device = msg.match[2];
    msg.send tracker.status(device)

  robot.respond /(whos your daddy)/i, (msg) ->
    msg.send device_admin

  robot.hear /((qa)? device (tracker)? help)/i, (msg) ->
    response = ["QA Device Tracker Help"]
    msg.send response.join("\n")
