# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
setupTabs = undefined
setupDatepickers = undefined
setClickListeners = undefined
hideElements = undefined

hideElements = ->
  $("#addtemplate").hide();
  return
  
setClickListeners = ->
  $("#add_from_template").click ->
    $("#addtemplate").toggle "slow"
  return
    
setupDatepickers = ->
  datefields = undefined
  datefields = $("body").find("input[id^='datepicker_']")
  datefields.each (index) ->
    initDatePicker this
    return

  return

setupTimepickers = ->
  datefields = undefined
  datefields = $("body").find("input[id^='timepicker_']")
  datefields.each (index) ->
    initTimePicker this
    return

  return

setupDateTimepickers = ->
  datefields = undefined
  datefields = $("body").find("input[id^='datetimepicker_']")
  datefields.each (index) ->
    initDateTimePicker this
    return

  return

initDateTimePicker = (el) ->
  $(el).datetimepicker
    datepicker:true,
    timepicker: true,
    format:'Y-m-d H:i'

  return

initTimePicker = (el) ->
  $(el).datetimepicker
    datepicker:false,
    format:'H:i'

  return

initDatePicker = (el) ->
  $(el).datetimepicker
    timepicker: false
    format: "Y-m-d"

  return

setupTabs = ->
  tabContainers = undefined
  tabContainers = $("body").find("div[id^='tab-container_']")
  tabContainers.each (index) ->
    initTabs this
    return

  return
  
initTabs = (el) ->
  $(el).easytabs animate: false
  
$(document).ready ->
  setupDatepickers()
  setupTimepickers()
  setupDateTimepickers()
  setupTabs()
  setClickListeners()
  hideElements()
  return