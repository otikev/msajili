# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
setClickListeners = undefined
hideElements = undefined

hideElements = ->
  $("#addcomment").hide();
  return
  
setClickListeners = ->
  $("#add_comment").click ->
    $("#addcomment").toggle "slow"
  return
  
$(document).ready ->
  setClickListeners()
  hideElements()
  return