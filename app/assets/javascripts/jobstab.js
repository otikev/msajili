function hideTabs(){
	$('div#dashboard_tabs').find('div[id^=job-tabs-]').each(function(){
		$(this).css('visibility', 'hidden').css('position', 'absolute');
	});
}

function activateTab(el,attr){
	$('#'+'job-tabs-'+attr).css('visibility', 'visible').css('position', 'relative');
	$(el).closest('.nav').find('li').removeClass('active');
	$(el).closest('li').addClass('active');
}

function DashboardTabChecker(){
	$('#job-tabs').on('click', 'a.tab-link', function(e){
		e.preventDefault();
		hideTabs();
		var attr = $(this).attr('id');
		activateTab(this,attr);
	});
}

$(document).ready( function() {
	hideTabs();
	activateTab($("#all"),"all");
	DashboardTabChecker();
}); 

