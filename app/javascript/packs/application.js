// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

/*
import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"


Rails.start()
Turbolinks.start()
ActiveStorage.start()

import 'bootstrap/dist/js/bootstrap'
import "@fortawesome/fontawesome-free/css/all"
require("stylesheets/base.scss")
*/

require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require('datatables.net-bs4')
require('custom/owl.carousel.min')
require('custom/nivo-lightbox.min')
require("custom/mobile_carousel")
require("custom/datatables")
require("custom/custom")
require("custom/app")

import $ from 'jquery';
global.$ = jQuery;
