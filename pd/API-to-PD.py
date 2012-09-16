import urllib2

#import https://trac.v2.nl/attachment/wiki/pyOSC/pyOSC-0.3.5b-5294.tar.gz
import OSC

# http://pypi.python.org/pypi/simplejson/
import simplejson

port = 8080

# the url for the data api, return as json, NOT jsonp
# url = open("test_data.json")


# go fetch all the data as json, DO NOT TOUCH THIS
# req = urllib2.Request(url, None, {'user-agent':'syncstream/vimeo'})
# opener = urllib2.build_opener()
# f = opener.open(req)
data = simplejson.load(open("data-bus-21-zone-changes.json"))

# for debugging
# print data

# THIS IS WHAT YOU WANT TO EDIT FOR WHICHEVER API
# parse the data to retreive whatever you want
results = data['journey']['markers']

min_elevation = data['min_elevation']
elevation_range = data['elevation_range']
min_speed = data['min_speed']
speed_range = data['speed_range']

client = OSC.OSCClient()
msg = OSC.OSCMessage()
msg.setAddress("/ele-low")
msg.append(float(min_elevation))
client.sendto(msg, ('localhost', port))

client = OSC.OSCClient()
msg = OSC.OSCMessage()
msg.setAddress("/ele-range")
msg.append(float(elevation_range))
client.sendto(msg, ('localhost', port))

client = OSC.OSCClient()
msg = OSC.OSCMessage()
msg.setAddress("/speed-low")
msg.append(float(min_speed))
client.sendto(msg, ('localhost', port))

client = OSC.OSCClient()
msg = OSC.OSCMessage()
msg.setAddress("/speed-range")
msg.append(float(speed_range))
client.sendto(msg, ('localhost', port))

for i in range(0,300):
	speed = results[i]['speed']
	zone = results[i]['zone']
	ele = results[i]['ele']
	print 'Iteration %i'%i

	client = OSC.OSCClient()
	msg = OSC.OSCMessage()
	msg.setAddress("/speed")
	msg.append(float(speed))
	client.sendto(msg, ('localhost', port))

	client = OSC.OSCClient()
	msg = OSC.OSCMessage()
	msg.setAddress("/zone")
	msg.append(float(zone))
	client.sendto(msg, ('localhost', port))

	client = OSC.OSCClient()
	msg = OSC.OSCMessage()
	msg.setAddress("/ele")
	msg.append(float(ele))
	client.sendto(msg, ('localhost', port))
