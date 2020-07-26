$(window).load(function() {
        $('#carousel-screenshots').carousel();

        $(".carousel-nav a").click(function(e){
            e.preventDefault();
            var index = parseInt($(this).attr('data-to'));
            $('#carousel-screenshots').carousel(index);
            var nav = $('.carousel-nav');
            var item = nav.find('a').get(index);
            nav.find('a.active').removeClass('active');
            $(item).addClass('active');
        });

        $("#carousel-screenshots").on('slide.bs.carousel', function() {
          var elements = 6;
          var nav = $('.carousel-nav');
          var index = $('#carousel-screenshots').find('.item.active').index();
          index = (index == elements - 1) ? 0 : index+1;
          var item = nav.find('a').get(index);
          nav.find('a.active').removeClass('active');
          $(item).addClass('active');
        });
  });