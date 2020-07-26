(function() {
    var applications;
    var stages;
    stages = function(){
        procedures = $("body").find("div[id^='morris-stages_']")
        procedures.each(function(index) {
            var el = $('#morris-stages_'+index)
            if(el == null){
                return;
            }
            var _data = el.data("values");

            if (typeof _data == 'undefined'){
                return;
            }
            Morris.Bar({
                element: 'morris-stages_'+index,
                data: _data,
                xkey: 'name',
                ykeys: ['dropped'],
                labels: ['Dropped'],
                hideHover: 'auto',
                resize: true
            });
        });
    };

    applications = function() {
        var el = $("#morris-applications");
        if(el == null){
            return;
        }
        var data = el.data("values");
        //var data = [{period: '2010', value: 50},{period: '2011', value: 41},{period: '2012', value: 59},{period: '2013', value: 33}];

        if (typeof data == 'undefined'){
            return;
        }
        Morris.Area({
            element: 'morris-applications',
            data: data,
            xkey: 'period',
            ykeys: ['value'],
            labels: ['Applications'],
            pointSize: 2,
            hideHover: 'auto',
            resize: true
        });
    };

    $(document).ready(function() {
        applications();
        stages();
    });

}).call(this);