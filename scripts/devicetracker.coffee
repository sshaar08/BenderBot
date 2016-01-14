# Description:
#   Track QA Devices
#
# Dependencies:
#   None
#
# Configuration:
#
# Commands:
#   add-device [name] - Add a device to the list of devices
#   remove-device [name] - Remove a device to the list of devices
#   QA Devices, wheres my shit - Lists devices and their status
#   Lend qad, Lend QA Device [name] [person] - Lend a device to a person
#   return-device [name] - List a device as returned
#   where is my [name] - Show status of device
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
      response = "I'm already keeping track of the " + device
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
      "No device"

  selfDeniedResponses: (name) ->
    @self_denied_responses = [
      "I don't know what device you're talking about man",
      "Can't find that device br0",
    ]

  get: (thing) ->
    k = if @cache[thing] then @cache[thing] else 0
    return k

  sort: ->
    s = []
    for key, val of @cache
      s.push({ name: key, karma: val })
    s.sort (a, b) -> b.karma - a.karma

module.exports = (robot) ->
  tracker = new QA_Device_Tracker robot
  allow_self = process.env.KARMA_ALLOW_SELF or "true"

  # robot.hear /add-device ([\w.-]+\s*)+/, (msg) ->
  robot.hear /(Add QA Device) (.*)/i, (msg) ->
    device = msg.match[2];
    msg.send tracker.add device

  robot.hear /(Remove QA Device (.*))/i, (msg) ->
    device = msg.match[2];
    msg.send tracker.remove device

  robot.hear /(list-device(s)?|(QA Devices)|(Where(\')?s my shit)|qa shit)/i, (msg) ->
    response = ["Listing QA Devices"]
    for device, num in tracker.list()
      response.push "#{num}. #{device.name} - #{device.status}"
    msg.send response.join("\n")

  robot.hear /(lend-device|lend (QA)? Device|) (.*) (.*)/, (msg) ->
    device = msg.match[0];
    msg.send device
    person = msg.match[1];
    msg.send tracker.lend(device, person)

  robot.hear /(return-device|(R|r)eturn (QA|qa)? (D|d)evice|Return (QAD|qad)) (.*)/, (msg) ->
    device = msg.match[6];
    msg.send tracker.return(device)

  robot.hear /(device-status|where is my) (.*)/, (msg) ->
    device = msg.match[2];
    msg.send tracker.status(device)


