# Description:
#   Track QA Devices
#
# Dependencies:
#   Slack, Node
#
# Configuration:
#   HUBOT_DEVICE_ADMIN
#
# Commands:
#   hubot <person> has my <device> - Lend a device to someone. Will also creates the device if it doesn't exist. (For Device Admin) [tracker]
#   hubot <person> returned my <device> - Set a device as returned. (For Device Admin) [tracker]
#   hubot return my <device> - Set a device as returned. (For Device Admin) [tracker]
#   hubot I have a <device> - Start keep track of a device. (For Device Admin) [tracker]
#   hubot Forget about my <device> - Stop keeping track of a device. (For Device Admin) [tracker]
#   hubot Wheres my stuff  - Lists QA devices and their status. (For Device Admin) [tracker]
#   hubot Where is the <device> - Shows status of a tracked device [tracker]
#   hubot list devices - Shows status of all tracked devices [tracker]
#   hubot whos qa admin - Shows device admin [tracker]
#
# Author:
#   Brian Lam V.01
#   Sammy Shaar V.02, V.03
#   Tristan Delgado V.03

#TODO add a que to the request list
#TODO Make the bot DM the user that asks for the info to remove noise in channels.


class QA_Device_Tracker

  constructor: (@robot) ->
    @cache = {
      'ny' : {
        1 : { 'Device_name' : 'iPhone 5S', 'OS Version': 'iOS 9.2', 'MID': 4327902, 'location': '', 'type': 'IOS'}, 
        2 : { 'Device_name' : 'iPhone 6', 'OS Version': 'iOS 9.3.4', 'MID': 4327898, 'location': '', 'type': 'IOS'},
        3 : { 'Device_name': 'iPhone 6+', 'OS Version': 'iOS 10.3.1', 'MID': 4391133, 'location': '', 'type': 'IOS'},
        4 : { 'Device_name': 'iPod Touch 5G', 'OS Version':  'iOS 7.0.3', 'MID': 4296522, 'location': '', 'type': 'IOS'},
        9 : { 'Device_name': 'Samsung Galaxy S5', 'OS Version':  '4.4.4 KitKat', 'MID': 362257, 'location': '', 'type' : 'Android'},
        10 : { 'Device_name': 'Samsung Galaxy S6', 'OS Version':  '6.0.1', 'MID': 380531, 'location': '', 'type' : 'Android'},
        12 : { 'Device_name': 'Samsung Galaxy S6 edge', 'OS Version': '6.0.1', 'MID': 359812, 'location': '', 'type' : 'Android'},
        13 : { 'Device_name': 'Nexus 4', 'OS Version': '5.1.1', 'MID': 299266, 'location': '', 'type' : 'Android'},
        14 : { 'Device_name': 'Samsung Galaxy Nexus', 'OS Version': '4.1.1 Jelly Bean', 'MID': 296535, 'location': '', 'type' : 'Android'},
        15 : { 'Device_name': 'Samsung Galaxy Tab S2', 'OS Version': '6.0,1tt', 'MID': 'n/a', 'location': '', 'type' : 'Android'},
        19 : { 'Device_name': 'iPad 4 with Retina Display.', 'OS Version': 'iOS 9.2.1', 'MID': 299264, 'location': '', 'type': 'IOS'},
        20 : { 'Device_name': 'iPad 4 (Sirius)', 'OS Version':  'iOS 8.4.1', 'MID': 385299, 'location': '', 'type': 'IOS'},
        22 : { 'Device_name': 'iPad Air 2 adamc','OS Version': 'iOS 9.2.1', 'MID': 380758, 'location': '', 'type': 'IOS'}, 
<<<<<<< HEAD
        24 : { 'Device_name': 'iPad 3','OS Version': 'iOS 7.1.2', 'MID': 296846, 'location': '', 'type': 'IOS'},
        25 : { 'Device_name': 'iPad Mini 2', 'OS Version':'iOS 10.3.1', 'MID': 311384, 'location': '', 'type': 'IOS'},
=======
        25 : { 'Device_name': 'iPad Mini 2', 'OS Version':'iOS 10.2', 'MID': 311384, 'location': '', 'type': 'IOS'},
>>>>>>> ef814f11590ca6951f98bc472404f59c124a14a6
        26 : { 'Device_name': 'iPad Mini 4', 'OS Version':'iOS 9.3', 'MID': 'n/a', 'location': '', 'type': 'IOS'},
        28 : { 'Device_name': 'iPad Pro', 'OS Version':  'iOS 9.2.1', 'MID': 'n/a', 'location': '', 'type': 'IOS'},
        33 : { 'Device_name': 'Nexus 7', 'OS Version': '4.4.2 KitKat', 'MID': 296529, 'location': '', 'type' : 'Android'},
        34 : { 'Device_name': 'Nexus 7', 'OS Version': '4.2 Jelly Bean', 'MID': 296530, 'location': '', 'type' : 'Android'},
        35 : { 'Device_name': 'Nexus 10','OS Version': '5.1.1 Lollipop', 'MID': 238749, 'location': '', 'type' : 'Android'},
        38 : { 'Device_name' : 'iPhone 7', 'OS Version': 'iOS 10.3.1', 'MID': '', 'location': '', 'type': 'IOS'}, 
        39 : { 'Device_name' : 'iPhone 6s', 'OS Version': 'iOS 10.3.1', 'MID': '', 'location': '', 'type': 'IOS'}, 
        40 : { 'Device_name' : 'Samsung Galaxy S7', 'OS Version': '6.0.1', 'MID': 414091, 'location': '', 'type': 'Android'},
        42 : { 'Device_name' : 'Samsung Galaxy S7 edge', 'OS Version': '6.0.1', 'MID': '', 'location': '', 'type': 'Android'},
        43 : { 'Device_name': 'iPad 4', 'OS Version':  'iOS 7.1.4', 'MID': 'MQJDWDBF182', 'location': '', 'type': 'IOS'},
        44 : { 'Device_name': 'Samsung Galaxy s2 ', 'OS Version': '6.0.1', 'MID': 'n/a', 'location': '', 'type' : 'Android'},
        45 : { 'Device_name': 'iPhone 5 Sirius', 'OS Version':  'iOS 9.2.1', 'MID': '', 'location': '', 'type': 'IOS'},
        
        },
      'sf': {
        1: {'Device_name': 'iPhone 4', 'OS Version': 'iOS 7.0.6', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        2: {'Device_name': 'iPod Touch 5th Gen', 'OS Version': 'iOS 7.0.4', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        3: {'Device_name': 'iPhone 6', 'OS Version': 'iOS 10.1.1', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        4: {'Device_name': 'iPhone 6+', 'OS Version': 'iOS 10.0.2', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        5: {'Device_name': 'iPhone 6s', 'OS Version': 'iOS 9.3.1', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        6: {'Device_name': 'iPhone 6s+', 'OS Version': 'iOS 10.2', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        7: {'Device_name': 'iPhone 7', 'OS Version': 'iOS 10.0.2', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        8: {'Device_name': 'Galaxy S Advance', 'OS Version': '2.3.6 Gingerbread', 'MID': 'N/A', 'locaion': '', 'type': 'Android'},
        9: {'Device_name': 'Galaxy Nexus  Android 4.1.1 Jellybean', 'MID': 'N/A', 'locaion': '', 'type': 'Android'},
        10: {'Device_name': 'Samsung Galaxy S7 Edge', 'OS Version': '6.0.1 Marshmallow', 'MID': 'N/A', 'locaion': '', 'type': 'Android'},
        11: {'Device_name': 'Blackberry Q10', 'OS Version': '10.1.0.2011', 'MID': 'N/A', 'locaion': '', 'type': 'N/A'},
        12: {'Device_name': 'Blackberry Z10', 'OS Version': '10.1.0.2019', 'MID': 'N/A', 'locaion': '', 'type': 'N/A'},
        13: {'Device_name': 'iPad 1', 'OS Version': 'iOS 5.1.1', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        14: {'Device_name': 'iPad 2', 'OS Version': 'iOS 8.1.3', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        15: {'Device_name': 'iPad 3', 'OS Version': 'iOS 7.1.2', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        16: {'Device_name': 'iPad Air 1', 'OS Version': 'iOS 9.3.1', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        17: {'Device_name': 'iPad Air 2', 'OS Version': 'iOS 10.2', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        18: {'Device_name': 'iPad Pro', 'OS Version': 'iOS 10.2', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        19: {'Device_name': 'iPad Mini 4', 'OS Version': 'iOS 10.2', 'MID': 'N/A', 'locaion': '', 'type': 'IOS'},
        20: {'Device_name': 'Samsung Galaxy Tab S2', 'OS Version': '6.0.1 Marshmellow', 'MID': 'N/A', 'locaion': '', 'type': 'Android'},
        21: {'Device_name': 'Nexus 7', 'OS Version': '6.0.1 Marshmallow', 'MID': 'N/A', 'locaion': '', 'type': 'Android'},
        22: {'Device_name': 'Motorola Xoom', 'OS Version': '4.0.4 Ice Cream Sandwich', 'MID': 'N/A', 'locaion': '', 'type': 'Android'},
        23: {'Device_name': 'Apple Watch', 'OS Version': '', 'MID': 'n/a', 'location': '', 'type': 'IOS'},
        24: {'Device_name': 'iPad Pro', 'OS Version':  'iOS 9.3', 'MID': 'n/a', 'location': '', 'type': 'IOS'},

        },
      'missing_ny': {
        5 : { 'Device_name': 'iPod Touch 5G', 'OS Version':  'iOS 8.4.1', 'MID': 4296451, 'location': '', 'type': 'IOS'},
        21 : { 'Device_name': 'iPad 2', 'OS Version':  'iOS 8.4.1', 'MID': 298531, 'location': '', 'type': 'IOS'},
        23 : { 'Device_name': 'iPad Air 2','OS Version': 'iOS 9.2.1', 'MID': 'n/a', 'location': '', 'type': 'IOS'},
        27 : { 'Device_name': 'iPad Mini 4', 'OS Version':'iOS 9.3', 'MID': 'n/a', 'location': '', 'type': 'IOS'},
        17 : { 'Device_name': 'Motorola Droid 2', 'OS Version': '2.3.3 Gingerbread', 'MID': 'n/a', 'location': '', 'type' : 'Android'},
        36 : { 'Device_name': 'Samsung Galaxy Tab 10.1','OS Version':  '4.0.4 Ice Cream Sandwich', 'MID': 299257, 'location': '', 'type' : 'Android'},
        37 : { 'Device_name': 'Samsung Galaxy Tab 7.0 Plus', 'OS Version': '4.0.4 Ice Cream Sandwich', 'MID': 296553, 'location': '', 'type' : 'Android' }
        41 : { 'Device_name' : 'Samsung Galaxy S5', 'OS Version': '', 'MID': ' ', 'location': '', 'type': 'Android'}, 
        },
      
      'mnl': {
        1 : { 'Device_name': 'iPod Touch 5G', 'OS Version': 'iOS 6.1.3', 'MID': 602919400114368282, 'location': '', 'type': 'IOS'},
        2 : { 'Device_name': 'iPod Touch 5G', 'OS Version': 'iOS 9.3.2', 'MID': 602919400114368485, 'location': '', 'type': 'IOS'},
        3 : { 'Device_name': 'iPhone 6', 'OS Version': 'iOS 9.2.1', 'MID': 602919400114368283, 'location': '', 'type': 'IOS'},
        4 : { 'Device_name': 'iPhone 6+', 'OS Version': 'iOS 9.3.2', 'MID':  602919400114327899, 'location': '', 'type': 'IOS'},
        5 : { 'Device_name': 'iPhone 6s', 'OS Version': 'iOS 9.3.2', 'MID': 602919400114414953, 'location': '', 'type': 'IOS'},
        6 : { 'Device_name': 'Nexus 5', 'OS Version': '6.0.1 (Marshmallow)', 'MID': 602919400114368289, 'location': '', 'type': 'Android'},
        7 : { 'Device_name': 'Galaxy S6', 'OS Version': '6.0.1 (Marshmallow)', 'MID': 602919400114362230, 'location': '', 'type': 'Android'},
        8 : { 'Device_name': 'Galaxy S6 Edge', 'OS Version': '6.0.1 (Marshmallow)', 'MID': 602919400114414952, 'location': '', 'type': 'Android'},
        9 : { 'Device_name': 'Galaxy S7','OS Version': '', 'MID': 'n/a', 'location': '', 'type': 'Android'},
        10 : { 'Device_name': 'Samsung Galaxy Duos', 'OS Version': '4.0.4 (Ice Cream Sandwich)', 'MID': 602919400114368290, 'location': '', 'type': 'Android'},
        11 : { 'Device_name': 'Cherry Mobile Flame 2.0', 'OS Version': '4.1.2 (Jelly Bean)', 'MID': 602919400114368288, 'location': '', 'type': 'Android'},
        12 : { 'Device_name': 'iPad 2', 'OS Version': 'iOS 9.3.2', 'MID': 602919400114368286, 'location': '', 'type': 'IOS'},
        13 : { 'Device_name': 'iPad Mini 3', 'OS Version': 'iOS 9.3.2', 'MID': 602919400114368287, 'location': '', 'type': 'IOS'},
        14 : { 'Device_name': 'iPad Air 2 Gold', 'OS Version': 'iOS 9.3.2', 'MID': 602919400114368284, 'location': '', 'type': 'IOS'},
        15 : { 'Device_name': 'iPad Air 2 Silver', 'OS Version': 'iOS 9.3.2', 'MID': 602919400114368284, 'location': '', 'type': 'IOS'},
        16 : { 'Device_name': 'Galaxy Tab 4', 'OS Version': '5.0.2 (Lollipop)', 'MID': 602919400114275477, 'location': '', 'type': 'Android'},
        17 : { 'Device_name': 'Galaxy Tab S2', 'OS Version': '', 'MID': 'N/A', 'location': '', 'type': 'Android'},
        18 : { 'Device_name': 'Kindle Fire HD', 'OS Version': '7.5.1', 'MID': 'N/A', 'location': '', 'type': 'Android'},
        },
      'removed_ny' : {
        6 : { 'Device_name': 'iPod Touch 5G', 'OS Version':  'iOS 8.4.1', 'MID': 4311041, 'location': '', 'type': 'IOS'},
        7 : { 'Device_name': 'Samsung Galaxy S4', 'OS Version':  '4.4.2 KitKat', 'MID': 4298544, 'location': '', 'type' : 'Android'},
        8 : { 'Device_name': 'Samsung Galaxy S4', 'OS Version':  '4.4.2 KitKat', 'MID': 'n/a', 'location': '', 'type' : 'Android'},
        16 : { 'Device_name': 'HTC Inspire 4G', 'OS Version': '2.3.3 Gingerbread', 'MID': 'n/a', 'location': '', 'type' : 'Android'},
        30 : { 'Device_name': 'Samsung Galaxy Tab 4', 'OS Version':  '5.0.2', 'MID': 380756, 'location': '', 'type' : 'Android'},
        31 : { 'Device_name': 'Samsung Galaxy Tab 4 (7 inch)', 'OS Version': '4.4.2 KitKat', 'MID': 'n/a', 'location': '', 'type' : 'Android'},
        32 : { 'Device_name': 'Samsung Galaxy Tab 3 (Sirius)', 'OS Version': '4.2.2 Jelly Bean', 'MID': 'n/a', 'location': '', 'type' : 'Android'},
        },
      }

    @robot.brain.on 'loaded', =>
      if @robot.brain.data.qa_device_tracker
        console.log('Loading from Brain')
        redismem = @robot.brain.data.qa_device_tracker
        #console.log(@robot.brain.data.qa_device_tracker)
        for office, devices of @cache
          if (redismem[office]== {})
            delete redismem[office]
            console.log("removed", office)
          if (!redismem[office])
            redismem[office] = {}
          for device, dict of devices
            if (redismem[office][device])
              @cache[office][device]['location'] = redismem[office][device]['location']
            else
              console.log("new device #{office} #{device}")
              redismem[office][device] = {}
              redismem[office][device]['Device_name'] = @cache[office][device]['Device_name']
              redismem[office][device]['OS Version'] = @cache[office][device]['OS Version']
              redismem[office][device]['MID'] = @cache[office][device]['MID']
              redismem[office][device]['location'] = "The Vault"
              redismem[office][device]['type'] = @cache[office][device]['type']
              console.log("Ill be keeping track of the #{office} #{device} for you.")
        @cache = @robot.brain.data.qa_device_tracker

  add: (office, id, device, OS, MID, type) ->
    if (@cache[office][id])
      response = id + "already exists." + " update coming to change device values"
    else 
      @cache[office][id] = {}
      @cache[office][id]['Device_name'] = device
      @cache[office][id]['OS Version'] = OS
      @cache[office][id]['MID'] = MID
      @cache[office][id]['location'] = "The Vault"
      @cache[office][id]['type'] = type
      response = 'Ill be keeping track of the' + #{office} + 'id ' + #{id} +' Device_name ' + #{device} + ' OS Version ' + #{OS} + ' MID ' + #{MID}  + ' location ' + 'The Vault' + 'type' + #{type} + " for you."
      @robot.brain.data.qa_device_tracker = @cache
    response

  remove: (office, device) ->
    response = "What is this " + office + device + " that you're talking about..."
    of_removed = ""
    if @cache[office][device]
      delete @cache[office][device]
      if @cache[office] == {}
        delete @cache[office]
        of_removed = 'removed office too'
      @robot.brain.data.qa_device_tracker = @cache
      response = "Cya, " + office + device + of_removed
    response

  lend: (office, device, person) ->
    repsonseArray = [". Good luck, please don't break it!", ". Please return it when you're done!", ". You better not update this device! Return when finished, please.", ". You update it you bought it! Be sure to return it, please."]
    response = "I don't know about the " + device
    office = office.toLowerCase()
    if (@cache[office][device])
      @cache[office][device]['location'] = person
      @robot.brain.data.qa_device_tracker = @cache
      response = @cache[office][device]['Device_name'] + " is now with " + '<' +person + '>' + repsonseArray[Math.floor((Math.random() * repsonseArray.length))]
    response
    
  list: -> 
    devices = []
    for office of @cache
      if (@cache[office] != undefined)
        for key, device of @cache[office]
          devices.push({office: office, name: key, item: device['Device_name'], mid: device['MID'], OS: device['OS Version'], location: device['location'], type: device['type'],})
    devices    

  return: (office, device) ->
    response = "No device found"
    if (@cache[office][device])
      @cache[office][device]['location'] = "In the Vault"
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

  get_brain: (thing) ->
    #qa_device_tracker
    k = @robot.brain.get(thing) 
    return k
  
  random_int: (max, min) ->
    int = Math.floor((Math.random() * (max - min)) + min)
    return int


  update: (office, id, OS, MID) ->
    if (@cache[office][id])
      if (OS)
        @cache[office][id]['OS Version'] = OS
      if (MID)
        @cache[office][id]['MID'] = MID

module.exports = (robot) ->
  tracker = new QA_Device_Tracker robot
  # Set device_admin to "Shell" for local environment
  Admins = ["sshaar",
            "j_liu", 
            "adamc", 
            "andrew", 
            "asha", 
            "carolyn", 
            "chris.manning", 
            "james_park", 
            "megan.mcnally", 
            "pete.duff", 
            "sara.tabor", 
            "tristan.delgado", 
            "laurentpierre", 
            "cassiehaffner", 
            "Shell",
            "richy",
          ]

  device_admins = process.env.HUBOT_DEVICE_ADMIN or Admins
  lowercase_devices = process.env.HUBOT_DEVICE_LOWERCASE or "true"

  robot.hear /get brain (.+)/i, (msg) ->
    item = msg.match[1]
    
    msg.send tracker.get_brain(item)

  robot.hear /device delete (.+) (.+)/i, (msg) ->
    if (msg.message.user.name in ['Shell', 'sshaar'])
      office = msg.match[1]
      device = msg.match[2]
      msg.send tracker.remove(office, device)

  #office, id, device, OS, MID, type  
  robot.respond /new device (.+) (.+) (.+) (.+) (.+) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      console.log(msg)
      office = msg.match[1]
      office = office.toLowerCase()
      device = msg.match[3]
      idd = msg.match[2]
      console.log(typeof(id))
      OS = msg.match[4]
      MID = msg.match[5]
      type = msg.match[6]
      msg.send tracker.add(office, idd, device, OS, MID, type )

  
  #remove admins here
  robot.respond /(.+) (has|have)\s?(the)?\s?(.+) (.+)/i, (msg) ->
    person = msg.match[1]
    if (person == msg.message.user.name | (device_admins.indexOf(msg.message.user.name) >= 0) | person == 'I' | person == 'i')

      if (person == 'i' | person == 'I')
        person = '@' + msg.message.user.name
      office = msg.match[4]
      office = office.toLowerCase()
      device = msg.match[5]
      if (device.search /,/ >= 0)
        device_array = device.split "," 
        if (device_array.length >= 5)
          msg.send "greedy!?... :D j/k"
        for item in device_array
          msg.send tracker.lend(office, item, person)
      else
        msg.send tracker.lend(office, device, person)
    else
      msg.send "You're not Authorized to do that!, you can only checkout devices for yourself"


  robot.respond /return\s?(the|my)?\s?(.+) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      office = msg.match[2]
      office = office.toLowerCase()
      device = msg.match[3]
      if (device.search /,/ >= 0)
        device_array = device.split "," 
        for item in device_array
          msg.send tracker.return(office, item)
      else
        msg.send tracker.return(office, device)
    else
      msg.send "Please give it to one of the QA teammembers in your office for return, _Don't just place it on their desk_"


  

  robot.respond /(list device(s)?|(QA Devices)|(Where(\')?s my stuff)|qa stuff)/i, (msg) ->
    response = ["Tracked QA devices:"]
    for office, num in tracker.list()
      if (office != undefined)
        if (office.office == msg.match[2])  
          response.push "*Office*: #{office.office} - *id*: #{office.name} - *device*: #{office.item} *OS*: #{office.OS} - *mid*: #{office.mid} - *location*: _<#{office.location}>_"
    if (response.length == 1)  
      response = ['No devices for that office. Try ny, sf, mnl']   
    msg.send response.join("\n")

  robot.respond /(list (.+) android)/i, (msg) ->
    response = ["Tracked QA Android devices:"]
    for office, num in tracker.list()
      if ("#{office.office}" == msg.match[2].toLowerCase())
        if ("#{office.type}" == 'Android') 
          response.push "*Office*: #{office.office} - *id*: #{office.name} - *device*: #{office.item} *OS*: #{office.OS} - *mid*: #{office.mid} - *location*: _<#{office.location}>_"
    
    if (response.length == 1)  
      response = ['No devices for that office. Try ny, sf, mnl #{response.length}']   
    msg.send response.join("\n")

  
  robot.respond /(list (.+) ios)/i, (msg) ->
    response = ["Tracked QA IOS devices:"]
    for office, num in tracker.list()
      if ("#{office.office}" == msg.match[2].toLowerCase())
        if ("#{office.type}" == 'IOS') 
          response.push "*Office*: #{office.office} - *id*: #{office.name} - *device*: #{office.item} *OS*: #{office.OS} - *mid*: #{office.mid} - *location*: _<#{office.location}>_"
    if (response.length == 1)  
      response = ['No devices for that office. Try ny, sf, mnl']   
    msg.send response.join("\n")


  robot.respond /storage delete (\w*)$/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      @robot.brain.remove(qa_device_tracker)
      msg.send "#{msg.match[1]} deleted from storage"



  robot.respond /(device-status|where is my|wheres my|where is the) (.+) (.+)/i, (msg) ->
    office = msg.match[2]
    device = msg.match[3]
    device = device.toLowerCase() if lowercase_devices
    msg.send tracker.status(office, device)

  robot.respond /(whos admin)/i, (msg) ->
    msg.send Admins


  robot.respond /update device (.+) (.+) (.+) (.+)/i, (msg) ->
    if (device_admins.indexOf(msg.message.user.name) >= 0)
      office = msg.match[1]
      office = office.toLowerCase()
      idd = msg.match[2]
      OS = msg.match[3]
      MID = msg.match[4]
      console.log(MID)
      tracker.update(office, idd, OS, MID)
      msg.send "Updated device #{office} #{idd}"

  robot.hear /(device help)/i, (msg) ->
    response = ["QA Device Tracker Help"]
    response.push("Commands:")
    response.push("ADMIN ONLY COMMANDS ")
    response.push("===")
    response.push("[person] returned my/the [office] [device] - Set a device as returned.")
    response.push("return [office] [device] - Set a device as returned.")
    response.push("list devices  - Lists QA devices and their status")
    response.push("PUBLIC USER COMMANDS")
    response.push("===")
    response.push("[person] has|have [office] [device_number] - Lend a device to someone")
    response.push("Where is the [office] [device] - Shows status of a device")
    response.push("list devices - Shows status of all devices")
    response.push("whos admin - Shows device admin")
    response.push("update device - office, idd, OS, MID. NOTE: set to values of undefined if not changing that value")

    msg.send response.join("\n")
