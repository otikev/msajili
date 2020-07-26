/*
    This is what we use to render the popovers for the help icons throughout the app.
 */

(function() {
    var initializePopovers;

    initializePopovers = function() {
        var elements = $("body").find("a[id^='help-popover_']");
        elements.each(function() {
            $(this).popover({trigger: 'hover',html: true});
        });
    };

    $(document).ready(function() {
        initializePopovers();
    });

}).call(this);