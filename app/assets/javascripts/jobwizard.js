(function() {
    var index = 0;
    var customFieldHtml = function(idx){
        return "<div id='field_"+idx+"' class='form-group'><div class='col-sm-12'><div class='row'><div class='col-sm-10'>"+
        "<input type='text' value='' placeholder='Title' name='field_title_"+idx+"' id='field_title_"+idx+"' class='btn-block'></div>"+
        "<div class='col-sm-2'><a id='remove_"+idx+"' class='btn btn-danger btn-xs'>Remove</a></div>"+
        "</div>"+
        "<div class='row'>"+
        "<div class='col-sm-10'><textarea rows='4' placeholder='Content' name='field_content_"+idx+"' id='field_content_"+idx+"' class='btn-block'></textarea></div>"+
        "<div class='col-sm-2'></div>"+
        "</div>"+
        "</div></div>";
    };

    var questionFieldHtml = function(idx){
        return "<div id='question_"+idx+"' class='form-group'><div class='col-sm-12'><div class='row'><div class='col-sm-10'>"+
                "<textarea rows='2' name='question_title_"+idx+"' id='question_title_"+idx+"' class='btn-block' placeholder='Question title'></textarea></div>"+
                "<div class='col-sm-2'><a id='question_remove_"+idx+"' class='btn btn-danger btn-xs'>Remove</a></div></div><br>"+
                "<div class='row'><div class='col-sm-12'></div></div><div class='row'><div class='col-sm-12'>"+
                "<a id='question_add_choice_"+idx+"' class='btn btn-success btn-xs'>Add Choice</a></div></div></div></div>";
    };

    var setListeners = function(){
        var addCustomfield = $( "#addCustomField" );
        if(addCustomfield != null){
            addCustomfield.click(function( event ) {
                $("#custom_fields").append( $(customFieldHtml(index)) );
                var entry = $("#field_"+index+"");
                if(entry != null){
                    entry.on('click', "a#remove_"+index+"", function(event) {
                        entry.remove();
                        event.preventDefault();
                    });
                }
                index+=1;
                event.preventDefault();
            });
        }

        var addQuestionfield = $( "#addQuestionField" );
        if(addQuestionfield != null){
            addQuestionfield.click(function( event ) {
                $("#question_fields").append( $(questionFieldHtml(index)) );
                var entry = $("#question_"+index+"");
                if(entry != null){
                    entry.on('click', "a#question_remove_"+index+"", function(event) {
                        entry.remove();
                        event.preventDefault();
                    });
                }
                index+=1;
                event.preventDefault();
            });
        }
    };

    $(document).ready(function() {
        setListeners();
    });

}).call(this);