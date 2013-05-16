# Description:
#
# Search for things on Foursquare
#
# Commands:
#   4sq me <query> (near <place>)?

# Configuration:
#   HUBOT_4SQ_CLIENT_ID
#   HUBOT_4SQ_CLIENT_SECRET


Util = require "util"

config = secrets:
  clientId: process.env.HUBOT_4SQ_CLIENT_ID
  clientSecret: process.env.HUBOT_4SQ_CLIENT_SECRET
  redirectUrl: "localhost:3000"

foursquare = require("node-foursquare")(config)

radius = 20000

places = [
    "where do you wanna go?",
    "where do you wanna go, %?",
    "any preferred place?",
    "any preferred place, %?"
]

trim_re = /^\s+|\s+$|[\.!\?]+$/g

search_4sq = (msg, query, location, radius, random, callback) ->
  # Perform the search
  #msg.send("Looking for #{query} around #{location}...")
  foursquare.Venues.search null, null, location, {query: query, radius: radius, limit: 2}, null, (error, data) ->
    if error != null
      return msg.send "There was an error searching for #{query}. Maybe try something different?"

    if random
      business = data.venues[Math.floor(Math.random() * data.venues.length)]
    else
      business = data.venues[0]

      msg.message.user['last_4sq_restaurant_place'] = location

    callback business

search_4sq_hours = (msg, venue_id, callback) ->
  foursquare.Venues.getHours venue_id, null, (error, data) ->
    if error != null
      return msg.send "hmm, couldn't get its business hours.."

    hours = data.popular.timeframes

    callback hours

lunchMe = (msg, query, random = true) ->
  # Clean up the query
  query = "food" if typeof query == "undefined"
  query = query.replace(trim_re, '')
  query = "food" if query == ""

  # Extract a location from the query
  split = query.split(/\snear|in|on\s/i)
  query = split[0]
  location = split[1]

  if (typeof location == "undefined" || location == "")
    place = msg.random places

    console.log msg.message.user.location

    msg.send place.replace "%", msg.message.user.name
    regex = new RegExp("^\s*(.*?)$", 'i')
    msg.waitResponse regex, (msg)->
      location = msg.message.text

      msg.send "ok, got it! "

      search_4sq msg, query, location, radius, random, (business)->
        msg.send("How about " + business.name + "? " + business.canonicalUrl)
    return

  search_4sq msg, query, location, radius, random, (business)->
    msg.send("How about " + business.name + "? " + business.canonicalUrl)
    msg.send("they are located at " + business.location.address + ", " + business.location.city)
    msg.send("you can call them " + business.contact.formattedPhone)

    search_4sq_hours business.venue_id, (hours)->


module.exports = (robot) ->

  robot.respond /4sq me(.*)/i, (msg) ->
    query = msg.match[1]
    lunchMe msg, query, false
