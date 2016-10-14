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
#   hubot <person> has my <device> - Lend a device to someone. Will also creates the device if it doesn't exist. (For Device Admin) 
#   hubot <person> returned my <device> - Set a device as returned. (For Device Admin)
#   hubot return my <device> - Set a device as returned. (For Device Admin)
#   hubot I have a <device> - Start keep track of a device. (For Device Admin)
#   hubot Forget about my <device> - Stop keeping track of a device. (For Device Admin)
#   hubot Wheres my shit  - Lists QA devices and their status. (For Device Admin)
#
#   hubot Where is the <device> - Shows status of a tracked device
#   hubot list devices - Shows status of all tracked devices
#   hubot whos qa admin - Shows device admin
#
# Author:
#   Brian Lam
# xoxb-69070161077-hpszX2hHCYw02nK8w5GEmW8T

#TODO add a que to the request list


class QA_Device_Tracker

  constructor: (@robot) ->
    @cache = {
    'ny' : {
      1 : { 'Device_name' : 'iPhone 5S', 'OS Version': 'iOS 9.2', MID: 602919400114327902, 'location': '',  }, 
      2 : { 'Device_name' : 'iPhone 6', 'OS Version': 'iOS 9.2.1', MID: 602919400114327898, 'location': '',},
      },
    #'sf' :{
    #  1 : { 'Device_name' : 'sfiPhone 5S', 'OS Version': 'iOS 9.2', MID: 602919400114327902, 'location': '',}, 
    #  2 : { 'Device_name' : 'sfiPhone 6', 'OS Version': 'iOS 9.2.1', MID: 602919400114327898, 'location': '',},
    #  }
    }

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.qa_device_tracker
        @cache = @robot.brain.data.qa_device_tracker

  add: (office, device) ->
    response = "I'll be keeping track of the " + device + " for you."
    if (@cache[office][device])
      response = device + ": Previous location was " + @cache[office][device]['location']
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

  lend: (office, device, person) ->
    response = "I don't know about the " + device
    if (@cache[office][device])
      @cache[office][device]['location'] = "Lent to " + person
      @robot.brain.data.qa_device_tracker = @cache
      response = @cache[office][device]['Device_name'] + " is now with " + person + ". Good luck please don't break it!"
    response
    
  list: -> 
    devices = []
    for office of @cache
      for key, device of @cache[office]
        devices.push({office: office, name: key, item: device['Device_name'], location: device['location']})
    devices    

  return: (office, device) ->
    response = "No device found"
    if (@cache[office][device])
      @cache[office][device]['location'] = "With QA"
      response = @cache[office][device]['Device_name'] + " is now safe at home with QA <3"
      @robot.brain.data.qa_device_tracker = @cache
    response

  status: (office, device) ->
    if (@cache[office][device])
      @cache[office][device]['location']
    else
      ""

  get: (thing) ->
    k = if @cache[thing] then @cache[thing] else 0
    return k

module.exports = (robot) ->
  tracker = new QA_Device_Tracker robot
  # Set device_admin to "Shell" for local environment

  device_admins = process.env.HUBOT_DEVICE_ADMIN or ["sshaar", "cassiehaffner", "sammy", "Shell"]
  lowercase_devices = process.env.HUBOT_DEVICE_LOWERCASE or "true"

  '''
  robot.respond /new device for (.+) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      device = msg.match[2]
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.add device
  '''
  #remove admins here
  robot.respond /(.+) has (the|my) (.+) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      person = msg.match[1]
      office = msg.match[3]
      device = msg.match[4]
      device = device.toLowerCase() if lowercase_devices
      #msg.send tracker.add(office, device)
      msg.send tracker.lend(office, device, person)

  robot.respond /(.+) returned (the|my) (.+) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      office = msg.match[3]
      device = msg.match[4]
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.return(office, device)

  robot.respond /return (the|my) (.+) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      office = msg.match[2]
      device = msg.match[3]
      device = device.toLowerCase() if lowercase_devices
      msg.send tracker.return(office, device)

  
  robot.respond /(list device(s)?|(QA Devices)|(Where(\')?s my shit)|qa shit)/i, (msg) ->
    response = ["Tracked QA devices:"]
    for office, num in tracker.list()
      response.push "*Office*: #{office.office} - *id*: #{office.name} - *device*: #{office.item} - *location*: _#{office.location}_"
    msg.send response.join("\n")

  robot.respond /(device-status|where is my|wheres my|where is the) (.+) (.+)/i, (msg) ->
    office = msg.match[2];
    device = msg.match[3];
    device = device.toLowerCase() if lowercase_devices
    msg.send tracker.status(office, device)

  robot.respond /(whos qa admin)/i, (msg) ->
    msg.send device_admins  

  robot.hear /((qa)? device (tracker)? help)/i, (msg) ->
    response = ["QA Device Tracker Help"]
    response.push("Commands:")
    response.push("ADMIN ONLY COMMANDS ")
    response.push("===")
    response.push("[person] returned my [device] - Set a device as returned.")
    response.push("return the [device] - Set a device as returned.")
    response.push("list devices  - Lists QA devices and their status")
    response.push("PUBLIC USER COMMANDS")
    response.push("===")
    response.push("[person] has [office][device_number] - Lend a device to someone")
    response.push("Where is the [device] - Shows status of a device")
    response.push("list devices - Shows status of all devices")
    response.push("whos admin - Shows device admin")
    msg.send response.join("\n")
