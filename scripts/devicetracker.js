
// Description:
//   Track QA Devices
//
// Dependencies:
//   Slack, Node
//
// Configuration:
//   HUBOT_DEVICE_ADMIN
//
// Commands:
//   hubot <person> has my <device> - Lend a device to someone. Will also creates the device if it doesn't exist. (For Device Admin) [tracker]
//   hubot <person> returned my <device> - Set a device as returned. (For Device Admin) [tracker]
//   hubot return my <device> - Set a device as returned. (For Device Admin) [tracker]
//   hubot I have a <device> - Start keep track of a device. (For Device Admin) [tracker]
//   hubot Forget about my <device> - Stop keeping track of a device. (For Device Admin) [tracker]
//   hubot Wheres my stuff  - Lists QA devices and their status. (For Device Admin) [tracker]
//   hubot Where is the <device> - Shows status of a tracked device [tracker]
//   hubot list devices - Shows status of all tracked devices [tracker]
//   hubot whos qa admin - Shows device admin [tracker]
//  Author
//   Sammy Shaar V.02, V.03,V.04

const devices = require('../devices.json');
class QA_Device_Tracker {

  constructor(robot) {
    this.robot = robot;
    this.cache = devices;
      

    this.robot.brain.on('loaded', () => {
      if (this.robot.brain.data.qa_device_tracker) {
        console.log('Loading from Brain');
        const redismem = this.robot.brain.data.qa_device_tracker;
        //console.log(@robot.brain.data.qa_device_tracker)
        for (let office in this.cache) {
          const devices = this.cache[office];
          if (redismem[office]=== {}) {
            delete redismem[office];
            console.log("removed", office);
          }
          if (!redismem[office]) {
            redismem[office] = {};
          }
          for (let device in devices) {
            const dict = devices[device];
            if (redismem[office][device]) {
              this.cache[office][device]['location'] = redismem[office][device]['location'];
              if (this.cache[office][device]['OS Version'] !== redismem[office][device]['OS Version']) {
                console.log('os mismatch 1', office + device);
                console.log(this.cache[office][device]['OS Version'], 'cache');
                console.log(redismem[office][device]['OS Version'], 'redismem');
                redismem[office][device]['OS Version'] = this.cache[office][device]['OS Version'];
              }
              if (this.cache[office][device]['type'] !== redismem[office][device]['type']) {
                console.log('type mismatch 1', office + device);
                console.log(this.cache[office][device]['type'], 'cache');
                console.log(redismem[office][device]['type'], 'redismem');
                redismem[office][device]['type'] = this.cache[office][device]['type'];
              }

            } else {
              console.log(`new device ${office} ${device}`);
              redismem[office][device] = {};
              redismem[office][device]['Device_name'] = this.cache[office][device]['Device_name'];
              redismem[office][device]['OS Version'] = this.cache[office][device]['OS Version'];
              redismem[office][device]['Serial'] = this.cache[office][device]['Serial'];
              redismem[office][device]['CompassId'] = this.cache[office][device]['CompassId'];
              redismem[office][device]['location'] = "The Vault";
              redismem[office][device]['type'] = this.cache[office][device]['type'];
              console.log(`Ill be keeping track of the ${office} ${device} ${device['Device_name']} for you.`);
            }
          }
        }
        return this.cache = this.robot.brain.data.qa_device_tracker;
      }
    });
  }

  add(office, id, device, OS, Serial, CompassId, type) {
    let response;
    if (this.cache[office][id]) {
      response = id + "already exists." + " update coming to change device values";
    } else {
      this.cache[office][id] = {};
      this.cache[office][id]['Device_name'] = device;
      this.cache[office][id]['OS Version'] = OS;
      this.cache[office][id]['Serial'] = Serial;
      this.cache[office][id]['CompassId'] = CompassId;
      this.cache[office][id]['location'] = "The Vault";
      this.cache[office][id]['type'] = type;
      response = `Ill be keeping track of the' + ${office} + 'id ' + ${id} +' Device_name ' + ${device} + ' OS Version ' + ${OS} + ' Serial ' + ${Serial} + ' CompassId ' + ${CompassId}  + ' location ' + 'The Vault' + 'type' + #{type} + " for you."`
      (this.robot.brain.data.qa_device_tracker = this.cache);
    }
    return response;
  }

  remove(office, device) {
    let response = `What is this ${office}${device} that you're talking about...`;
    let of_removed = "";
    if (this.cache[office][device]) {
      delete this.cache[office][device];
      if (this.cache[office] === {}) {
        delete this.cache[office];
        of_removed = 'removed office too';
      }
      this.robot.brain.data.qa_device_tracker = this.cache;
      response = `Cya, ${office}${device}${of_removed}`;
    }
    return response;
  }

  lend(office, device, person) {
    const repsonseArray = [". Good luck, please don't break it!", ". Please return it when you're done!", ". You better not update this device! Return when finished, please.", ". You update it you bought it! Be sure to return it, please."];
    let response = `I don't know about the ${device}`;
    office = office.toLowerCase();
    if (this.cache[office][device]) {
      this.cache[office][device]['location'] = person;
      this.robot.brain.data.qa_device_tracker = this.cache;
      response = this.cache[office][device]['Device_name'] + " is now with " + '<' +person + '>' + repsonseArray[Math.floor((Math.random() * repsonseArray.length))];
    }
    return response;
  }

  list() {
    const devices = [];
    for (let office in this.cache) {
      if (this.cache[office] !== undefined) {
        for (let key in this.cache[office]) {
          const device = this.cache[office][key];
          devices.push({ office, name: key, item: device['Device_name'], Serial: device['Serial'], CompassId: device['CompassId'], OS: device['OS Version'], location: device['location'], type: device['type'],});
        }
      }
    }
    return devices;
  }

  return(office, device) {
    let response = "No device found";
    if (this.cache[office][device]) {
      this.cache[office][device]['location'] = "In the Vault";
      response = this.cache[office][device]['Device_name'] + " is now safe at home with QA <3";
      this.robot.brain.data.qa_device_tracker = this.cache;
    }
    return response;
  }

  status(office, device) {
    if (this.cache[office][device]) {
      return this.cache[office][device]['location'];
    } else {
      return "";
    }
  }

  get(thing) {
    const k = this.cache[thing] ? this.cache[thing] : 0;
    return k;
  }

  get_brain(thing) {
    //qa_device_tracker
    const k = this.robot.brain.get(thing);
    return k;
  }

  random_int(max, min) {
    const int = Math.floor((Math.random() * (max - min)) + min);
    return int;
  }


  update(office, id, OS, Serial) {
    if (this.cache[office][id]) {
      if (OS) {
        this.cache[office][id]['OS Version'] = OS;
      }
      if (Serial) {
        return this.cache[office][id]['Serial'] = Serial;
      }
    }
  }
}

module.exports = function(robot) {
  const tracker = new QA_Device_Tracker(robot);
  // Set device_admin to "Shell" for local environment
  const Admins = ["sshaar",
            "angel.dionisio",
            "aparna.parlapalli",
            "alan.wang",
            "beatrice.mendoza",
            "cevon.carver",
            "charles.smith",
            "leilah",
            "lee.pollard",
            "margie.ruparel",
            "masha.malygina",
            "neha.mittal",
            "paola.justiniano",
            "raghav",
            "robert.gray",
            "ray.leung",
            "russell.stephens", 
            "sammy",
            "sammy.shaar",
            "Shell",
            "sean.macgahan",
            "shahadat.noor",
            "tal.amitai",
            "tania.goswami",
            "vamshidhar.soma"
          ];

  const device_admins = process.env.HUBOT_DEVICE_ADMIN || Admins;
  const lowercase_devices = process.env.HUBOT_DEVICE_LOWERCASE || "true";

  robot.respond(/get brain (.+)/i, function(msg) {
    const item = msg.match[1];

    return msg.send(tracker.get_brain(item));
  });

  robot.respond(/device delete (.+) (.+)/i, function(msg) {
    if (['Shell', 'sshaar', 'james_park'].includes(msg.message.user.name)) {
      const office = msg.match[1];
      const device = msg.match[2];
      return msg.send(tracker.remove(office, device));
    }
  });

  //office, id, device, OS, Serial, type
  robot.respond(/new device (.+) (.+) (.+) (.+) (.+) (.+)/i, function(msg) {
    if (device_admins.indexOf(msg.message.user.name) >= 0) {
      console.log(msg);
      let office = msg.match[1];
      office = office.toLowerCase();
      const device = msg.match[3];
      const idd = msg.match[2];
      console.log(typeof(id));
      const OS = msg.match[4];
      const Serial = msg.match[5];
      const type = msg.match[6];
      return msg.send(tracker.add(office, idd, device, OS, Serial, type ));
    }
  });


  //remove admins here
  robot.respond(/(.+) (has|have)\s?(the)?\s?(.+) (.+)/i, function(msg) {
    let person = msg.match[1].replace("@", "");
    if ((person === msg.message.user.name) | (device_admins.indexOf(msg.message.user.name) >= 0) | (person === 'I') | (person === 'i')) {

      if ((person === 'i') | (person === 'I')) {
        // removing @ as it cause the user info to be private
        // person = '@' + msg.message.user.name
        person = msg.message.user.name;
      }
      let office = msg.match[4];
      office = office.toLowerCase();
      const device = msg.match[5];
      if (device.search(/,/ >= 0)) {
        const device_array = device.split(",");
        if (device_array.length >= 5) {
          msg.send("greedy!?... :D j/k");
        }
        return Array.from(device_array).map((item) =>
          msg.send(tracker.lend(office, item, person)));
      } else {
        return msg.send(tracker.lend(office, device, person));
      }
    } else {
      return msg.send("You're not Authorized to do that!, you can only checkout devices for yourself");
    }
  });


  robot.respond(/return\s?(the|my)?\s?(.+) (.+)/i, function(msg) {
    console.log('user returning device ' + msg.message.user.name);
    if (device_admins.indexOf(msg.message.user.name) >= 0) {
      let office = msg.match[2];
      office = office.toLowerCase();
      const device = msg.match[3];
      if (device.search(/,/ >= 0)) {
        const device_array = device.split(",");
        return Array.from(device_array).map((item) =>
          msg.send(tracker.return(office, item)));
      } else {
        return msg.send(tracker.return(office, device));
      }
    } else {
      return msg.send("You are not an admin. Please give it to one of the QA teammembers in your office for return, _Don't just place it on their desk_");
    }
  });




  robot.respond(/(list device(s)?|(QA Devices)|(Where(\')?s my stuff)|qa stuff)/i, function(msg) {
    let response = ["Tracked QA devices:"];
    const iterable = tracker.list();
    for (let num = 0; num < iterable.length; num++) {
      const office = iterable[num];
      if (office !== undefined) {
        if (office.office === 'ny') {
          response.push(`*Office*: ${office.office} - *id*: ${office.name} - *device*: ${office.item} *OS*: ${office.OS} - *Serial*: ${office.Serial} - *CompassId*: ${office.CompassId} - *location*: _<${office.location}>_`);
        }
      }
    }
    if (response.length === 1) {
      response = ['Coming Soon!'];
    }
    return msg.send(response.join("\n"));
  });

  robot.respond(/(list android)/i, function(msg) {
    let response = ["Tracked QA Android devices:"];
    const iterable = tracker.list();
    for (let num = 0; num < iterable.length; num++) {
      const office = iterable[num];
      if (`${office.office}` === 'ny') {
        if (`${office.type}` === 'Android') {
          response.push(`*Office*: ${office.office} - *id*: ${office.name} - *device*: ${office.item} *OS*: ${office.OS} - *Serial*: ${office.Serial} - *CompassId*: ${office.CompassId} - *location*: _<${office.location}>_`);
        }
      }
    }

    robot.respond(/(list browserstack)/i, function(msg) {
      let response = ["Tracked QA browserstack accounts:"];
    const iterable = tracker.list();
    for (let num = 0; num < iterable.length; num++) {
      response.push('fml')
      const office = iterable[num];
      if (`${office.office}` === 'ny') {
        if (`${office.type}` == 'browserstack') {
          response.push(`*Office*: ${office.office} - *id*: ${office.name} - *device*: ${office.item} *OS*: ${office.OS} - *Serial*: ${office.Serial} - *CompassId*: ${office.CompassId} - *location*: _<${office.location}>_`);
        }
      }
    }
  });

    if (response.length === 1) {
      response = ['Coming Soon!'];
    }
    return msg.send(response.join("\n"));
  });


  robot.respond(/(list ios)/i, function(msg) {
    let response = ["Tracked QA IOS devices:"];
    const iterable = tracker.list();
    for (let num = 0; num < iterable.length; num++) {
      const office = iterable[num];
      if (`${office.office}` === 'ny') {
        if (`${office.type}` === 'IOS') {
          response.push(`*Office*: ${office.office} - *id*: ${office.name} - *device*: ${office.item} *OS*: ${office.OS} - *Serial*: ${office.Serial} - *CompassId*: ${office.CompassId} - *location*: _<${office.location}>_`);
        }
      }
    }
    if (response.length === 1) {
      response = ['Coming Soon!'];
    }
    return msg.send(response.join("\n"));
  });

  robot.respond(/(list other)/i, function(msg) {
    let response = ["Tracked QA other devices:"];
    const iterable = tracker.list();
    for (let num = 0; num < iterable.length; num++) {
      const office = iterable[num];
      if (`${office.office}` === 'ny') {
        if (`${office.type}` === 'other') {
          rresponse.push(`*Office*: ${office.office} - *id*: ${office.name} - *device*: ${office.item} *OS*: ${office.OS} - *Serial*: ${office.Serial} - *CompassId*: ${office.CompassId} - *location*: _<${office.location}>_`);
        }
      }
    }
    if (response.length === 1) {
      response = ['Coming Soon!.'];
    }
    return msg.send(response.join("\n"));
  });


  robot.respond(/storage delete (\w*)$/i, function(msg) {
    if (device_admins.indexOf(msg.message.user.name) >= 0) {
      this.robot.brain.remove(qa_device_tracker);
      return msg.send(`${msg.match[1]} deleted from storage`);
    }
  });



  robot.respond(/(device-status|where is my|wheres my|where is the) (.+) (.+)/i, function(msg) {
    const office = msg.match[2];
    let device = msg.match[3];
    if (lowercase_devices) { device = device.toLowerCase(); }
    return msg.send(tracker.status(office, device));
  });

  robot.respond(/(whos admin)/i, msg => msg.send(`${Admins}`));


  robot.respond(/update device (.+) (.+) (.+) (.+)/i, function(msg) {
    if (device_admins.indexOf(msg.message.user.name) >= 0) {
      let office = msg.match[1];
      office = office.toLowerCase();
      const idd = msg.match[2];
      const OS = msg.match[3];
      const Serial = msg.match[4];
      console.log(Serial);
      tracker.update(office, idd, OS, Serial);
      return msg.send(`Updated device ${office} ${idd}`);
    }
  });

  return robot.hear(/(device help)/i, function(msg) {
    const response = ["QA Device Tracker Help"];
    response.push("Commands:");
    response.push("ADMIN ONLY COMMANDS ");
    response.push("===");
    response.push("[person] returned my/the [office] [device] - Set a device as returned.");
    response.push("return [office] [device] - Set a device as returned.");
    response.push("update device - office, idd, OS, Serial. NOTE: set to values of undefined if not changing that value");
    response.push("PUBLIC USER COMMANDS");
    response.push("===");
    response.push("[person] has|have [office] [device_number] - Lend a device to someone");
    response.push("Where is the [office] [device] - Shows status of a device");
    response.push("list devices - Shows status of all devices");
    response.push("list ios - Shows status of all IOS devices");
    response.push("whos admin - Shows device admins");
    

    return msg.send(response.join("\n"));
  });
};
