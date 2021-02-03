(function() {
    var screenshotsCarousel;
    var fix;

    screenshotsCarousel = function(){
        var owl = $("#screenshots");
        owl.owlCarousel({
            items: 3, //3 items above 1000px browser width
            itemsDesktop: [1000, 3], //3 items between 1000px and 901px
            itemsDesktopSmall: [900, 2], // betweem 900px and 601px
            itemsTablet: [600, 1], //1 items between 600 and 0
            itemsMobile: false, // itemsMobile disabled - inherit from itemsTablet option
            navigation: false, // Show next and prev buttons
            slideSpeed: 800,
            paginationSpeed: 400,
            autoPlay: 5000,
            stopOnHover: true
        });
        $('#screenshots a').nivoLightbox({
            effect: 'fadeScale'
        });
    };

    fix = function () {
        var padding_top = parseInt($('.home-body').css('padding-top').replace(/[^-\d\.]/g, ''));
        var footer_height = $('.home-footer').outerHeight();
        var neg = padding_top + footer_height;
        //Get window height and the wrapper height
        var window_height = $(window).height();
        $(".content-home").css('min-height', window_height - neg);

    }

    $(document).ready(function() {
        screenshotsCarousel();
        if($('.prettySocial') != null){
            $('.prettySocial').prettySocial();
        }
        if($('.home-body').length > 0){
            fix();
        }
    });

    $(window, ".wrapper").resize(function () {
        if($('.home-body').length > 0){
            fix();
        }
    });
}).call(this);