# Description:
#   Hubot, be polite and say hello.
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   Hello or Good Day make hubot say hello to you back
#   Good Morning makes hubot say good morning to you back
hellos = [
    "Well hello there, %",
    "Hey %, Hello!",
    "Marnin', %",
    "Good day, %",
    "Good 'aye!, %"
]
mornings = [
    "Good morning, %",
    "Good morning to you too, %",
    "Good day, %",
    "Good 'aye!, %"
]

whatsup = [
    "I am fine. you?",
    "fine, and you?",
    "what's up? %",
    "I am fine. how are you doing? %"
]
module.exports = (robot) ->
    robot.hear /^(hi|hello|good( [d'])?ay(e)?)/i, (msg) ->
        hello = msg.random hellos
        msg.send hello.replace "%", msg.message.user.name

    robot.hear /(^(good )?m(a|o)rnin(g)?)/i, (msg) ->
        hello = msg.random mornings
        msg.send hello.replace "%", msg.message.user.name

    robot.hear /how are you( doing)?(.*?)[.?!]?$/i, (msg) ->
        hello = msg.random whatsup
        msg.send hello.replace "%", msg.message.user.name

    robot.hear /wh?at'?s\s?up[ .?!]?$/i, (msg) ->
        hello = msg.random whatsup
        msg.send hello.replace "%", msg.message.user.name

