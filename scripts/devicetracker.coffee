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
#   list-devices - Lists devices and their status
#   lend-device [name] [person] - Lend a device to a person
#   return-device [name] - List a device as returned
#   device-status [name] - Show status of device
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
    @cache[device] = "With QA"
    @robot.brain.data.qa_device_tracker = @cache

  remove: (device) ->
    delete @cache[device]
    @robot.brain.data.qa_device_tracker = @cache

  lend: (device, person) ->
    if (@cache[device])
      @cache[device] = "Lent to " + person
    @robot.brain.data.qa_device_tracker = @cache
    

  list: -> 
    devices = []
    for key, val of @cache
      devices.push({name: key, status: val})
    devices    

  return: (device) ->
    if (@cache[device])
      @cache[device] = "With QA"

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
  robot.hear /add-device (.*)/, (msg) ->
    device = msg.match[1];
    msg.send "Adding #{device}";
    tracker.add device

  robot.hear /remove-device (.*)/, (msg) ->
    device = msg.match[1];
    msg.send "Remove #{device}";
    tracker.remove device

  robot.hear /list-device(s)?/, (msg) ->
    response = ["Listing QA Devices"]
    for device, num in tracker.list()
      response.push "#{num} #{device.name} - #{device.status}"
    msg.send response.join("\n")

  robot.hear /lend-device (.*) (.*)/, (msg) ->
    device = msg.match[1];
    person = msg.match[2];
    tracker.lend(device, person)

  robot.hear /return-device (.*)/, (msg) ->
    device = msg.match[1];
    tracker.return(device)
