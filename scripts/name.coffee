# Description:
#
#
# Commands:
#   do you know me - Display the user that hubot chats with


Util = require "util"

module.exports = (robot) ->

  robot.respond /do you know me.*$/i, (resp) ->

    user = robot.brain.data.users[resp.message.user.id]

    strings = []

    strings.push "i know you. you are #{user.name}"

    resp.send strings