function hideSettingsTabs(){
	$('div#settings_tabs').find('div[id^=setting-tabs-]').each(function(){
		$(this).css('visibility', 'hidden').css('position', 'absolute');
	});
}

function activateSettingsTab(el,attr){
	$('#'+'setting-tabs-'+attr).css('visibility', 'visible').css('position', 'relative');
	$(el).closest('.nav').find('li').removeClass('active');
	$(el).closest('li').addClass('active');
}

function settingsTabChecker(){
	$('#setting-tabs').on('click', 'a.tab-link', function(e){
		e.preventDefault();
        hideSettingsTabs();
		var attr = $(this).attr('id');
        activateSettingsTab(this,attr);
	});
}

$(document).ready(function() {
    hideSettingsTabs();
    activateSettingsTab($("#preferences"),"preferences");
    settingsTabChecker();
}); 

