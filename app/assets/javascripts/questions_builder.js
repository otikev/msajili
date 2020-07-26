(function() {
    var el;

    var loading_overlay = "<div class=\"overlay text-center\">"+
        "<i class=\"fa fa fa-spinner fa-spin fa-4x\"></i>"+
        "</div>";

    var save_success_message = "<div class=\"label-success btn-block text-center padding-10\">Questions successfully saved</div>";
    var save_failed_message = "<div class=\"label-danger btn-block text-center padding-10\">Questions could not be saved</div>";

    var setMoveCallback = function(){
        var questionsHtml = $(el).find(".builder_content").find("div[id^='main_question_']");
        _.each(questionsHtml, function(question) {
            var id = $(question).data("id");
            var upButton = $(question).find("#question_up_"+id);
            var downButton = $(question).find("#question_down_"+id);

            if(id = ""){
                upButton.remove();
                downButton.remove();
            }else{
                upButton.off("click");
                upButton.on("click",function(){
                    var id = upButton.data("id");
                    showTinyProgress(true,id);

                    $.post( "/move_question",{id: id,direction: "up"}, function( data ) {
                        var movedQuestion = $(el).find(".builder_content").find("#main_question_"+data["id"]);
                        var replacedQuestion = getQuestionWithPosition(data["position"]);

                        var newReplacedPosition = $(movedQuestion).attr("data-position");
                        var newMovedPosition = data["position"];

                        $(replacedQuestion).attr("data-position",newReplacedPosition);
                        $(movedQuestion).attr("data-position",newMovedPosition);

                        orderQuestions();
                    }).fail(function() {
                        alert("Something went wrong!");
                    }).always(function(){
                        showTinyProgress(false,id);
                    });
                });
                downButton.off("click");
                downButton.on("click",function(){
                    var id = downButton.data("id");
                    showTinyProgress(true,id);

                    $.post( "/move_question",{id: id,direction: "down"}, function( data ) {
                        var movedQuestion = $(el).find(".builder_content").find("#main_question_"+data["id"]);
                        var replacedQuestion = getQuestionWithPosition(data["position"]);

                        var newReplacedPosition = $(movedQuestion).attr("data-position");
                        var newMovedPosition = data["position"];

                        $(replacedQuestion).attr("data-position",newReplacedPosition);
                        $(movedQuestion).attr("data-position",newMovedPosition);
                        orderQuestions();
                    }).fail(function() {
                        alert("Something went wrong!");
                    }).always(function(){
                        showTinyProgress(false,id);
                    });
                });
            }
        });
    };

    var showProgress = function(show){
        if(show){
            $(el).append(loading_overlay);
        }else{
            $(el).find(".overlay").remove();
        }
    }

    var showFooterProgress = function(show){
        if(show){
            $(el).find(".footer_progress").show();
            $(el).find("#new_question").prop( "disabled", true );
            $(el).find("#save_questions").prop( "disabled", true );
        }else{
            $(el).find(".footer_progress").hide();
            $(el).find("#new_question").prop( "disabled", false );
            $(el).find("#save_questions").prop( "disabled", false );
        }
    }

    var resetFooter = function(){
        $(el).find("#question_builder_footer").empty();
    };

    var saveQuestions = function(){
        var questionsHtml = el.find(".builder_content").find("div[id^='main_question_']");

        //validate
        var passed = true;
        _.each(questionsHtml, function(question) {
            var errorDiv = $(question).find("#message");
            $(errorDiv).empty();
            $(errorDiv).hide();
            var id = $(question).data("id");
            var content = $(question).find("#question_content_"+id).val();
            if(content == ''){
                passed = false;
                $(errorDiv).show();
                $(errorDiv).append("<div class='col-sm-12'>Question content can't be blank</div>");
            }
            var questionType = $(question).find("#question_type_"+id).find(":selected").val();
            if(questionType < 1){
                passed = false;
                $(errorDiv).show();
                $(errorDiv).append("<div class='col-sm-12'>You must select a question type</div>");
            }
            var choicesHtml = $(question).find("#choice_list_"+id).find("div");
            if(questionType == 2 || questionType == 3){
                if(choicesHtml.length < 2){
                    passed = false;
                    $(errorDiv).show();
                    $(errorDiv).append("<div class='col-sm-12'>You must add 2 or more choices</div>");
                }
                _.each(choicesHtml, function(choice) {
                    var choice_content = $(choice).find("input").prop("value");
                    if(choice_content == ''){
                        passed = false;
                        $(errorDiv).show();
                        $(errorDiv).append("<div class='col-sm-12'>You can't have blank choices</div>");
                    }
                });
            }
        });

        if(!passed){
            $(el).find("#question_builder_footer").append(save_failed_message);
            showFooterProgress(false);
            return;
        }

        var questions = new Array();
        _.each(questionsHtml, function(question) {
            var job_id = $(el).data("job_id");
            var template_id = $(el).data("template_id");
            var id = $(question).data("id");
            var position = $(question).data("position");
            var content = $(question).find("#question_content_"+id).val();
            var questionType = $(question).find("#question_type_"+id).find(":selected").val();

            var choicesHtml = $(question).find("#choice_list_"+id).find("div");
            var choices = new Array();
            _.each(choicesHtml, function(choice) {
                var choice_id = $(choice).find("input").data("id");
                var choice_content = $(choice).find("input").prop("value");
                choices.push({id:choice_id,content:choice_content});
            });
            questions.push({id:id,job_id:job_id,template_id:template_id,content:content,position:position,question_type:questionType,choices:choices});
        });

        //alert(JSON.stringify(questions));
        console.log(JSON.stringify(questions));

        if(questions.length>0){
            resetFooter();
            $.post( "/save_questions",{questions: questions}, function() {
                $(el).find("#question_builder_footer").append(save_success_message);
            }).fail(function() {
                $(el).find("#question_builder_footer").append(save_failed_message);
            }).always(function(){
                showFooterProgress(false);
            });
        }else{
            showFooterProgress(false);
            alert("Nothing to save!");
        }

    };

    var initialize = function(){
        el = $("#question_builder_container");
        if(el.length == 0){
            return;
        }
        showProgress(true);
        var job_id = $(el).data("job_id");
        var template_id = $(el).data("template_id");
        el.find("#new_question").on("click", function() {
            resetFooter();
            showFooterProgress(true);

            $.post( "/new_question",{job_id: job_id,template_id: template_id}, function( data ) {
                $(el).find(".builder_content").append(data);
                orderQuestions();
            }).fail(function() {
                alert("Something went wrong!");
            }).always(function(){
                showFooterProgress(false);
            });
            return false;
            e.preventDefault();
        });

        el.find("#save_questions").on("click", function() {
            resetFooter();
            showFooterProgress(true);
            saveQuestions();
            return false;
            e.preventDefault();
        });

        loadExisting(job_id,template_id);
    };

    var showTinyProgress = function(show, question_id){
        var optionsDiv = $(el).find('#actions_' + question_id);
        if(show){
            $(optionsDiv).find(".actions_progress").show();
            $(optionsDiv).find(".actions_buttons").hide();
        }else{
            $(optionsDiv).find(".actions_progress").hide();
            $(optionsDiv).find(".actions_buttons").show();
        }
    }

    var setRemoveCallbacks = function(){
        var removeButtons = el.find("a[id^='question_remove_']");
        _.each(removeButtons, function(item) {
            var button = $(item);
            button.off("click");
            button.on("click", function() {
                resetFooter();
                var id = button.data("id");
                showTinyProgress(true,id);

                if(id == ""){
                    $(button).parent().parent().parent().parent().remove();
                }else{
                    $.post( "/delete_question",{id: id}, function( data ) {
                        el.find('#main_question_'+id).remove();
                    }).fail(function() {
                        alert("Something went wrong!");
                    }).always(function(){
                        showTinyProgress(false,id);
                    });
                }

                return false;
                e.preventDefault();
            });
        });
    };

    var orderQuestions = function(){
        var list = $(el).find(".builder_content").find("div[id^='main_question_']");
        if(list.length > 0){
            tinysort(list,{attr:'data-position'});
        }
        resetFooter();
        setRemoveCallbacks();
        setMoveCallback();
        setQuestionTypeCallbacks();
        setRemoveChoiceCallbacks();
        setNewChoiceCallbacks();
    }

    var getQuestionWithPosition = function(position){
        var questionsHtml = $(el).find(".builder_content").find("div[id^='main_question_']");

        var question = _.find(questionsHtml, function(item) {
            var pos = $(item).attr("data-position");
            return pos == position;
        });
        return question;
    };

    var loadExisting = function(job_id,template_id){
        $.get("/questions",{job_id: job_id,template_id: template_id}, function(data){
            $(el).find(".builder_content").prepend(data);
            orderQuestions();
        },"html").fail(function() {
            alert("Something went wrong!");
        }).always(function(){
            showProgress(false);
        });
    };

    var setRemoveChoiceCallbacks = function(){
        var removeButtons = el.find("a[id^='remove_choice_']");
        _.each(removeButtons, function(item) {
            var button = $(item);
            button.off("click");
            button.on("click", function() {
                var id = button.data("id");
                el.find('#choice_'+id).parent().remove();
                $.post( "/delete_choice",{id: id}, function( data ) {
                    setRemoveChoiceCallbacks();
                }).fail(function() {
                    alert("Something went wrong!");
                }).always(function(){
                    //TODO:
                });
                return false;
                e.preventDefault();
            });
        });
    };

    var setNewChoiceCallbacks = function(){
        var newChoices = el.find("a[id^='new_choice_']");
        _.each(newChoices,function(new_choice){
            var button = $(new_choice);
            button.off("click");
            button.on("click", function() {
                var questionId = button.data("question_id");
                $.post( "/new_choice",{question_id: questionId}, function( data ) {
                    el.find("#choice_list_"+questionId).append(data);
                    setRemoveChoiceCallbacks();
                }).fail(function() {
                    alert("Something went wrong!");
                }).always(function(){
                    showFooterProgress(false);
                });

                return false;
                e.preventDefault();
            });
        });
    };

    var setQuestionTypeCallbacks = function(){
        var options = el.find("select[id^='question_type_']");
        _.each(options, function(item) {
            var select = $(item);
            select.off("change");
            select.on("change", function() {
                var id = select.data("id");
                var selectedValue = $(this).find(":selected").val();
                var choicesDiv = $("#choices_"+id);
                switch(parseInt(selectedValue)) {
                    case 2: //Single Option
                    case 3: //Multiple Option
                        choicesDiv.show();
                        break;
                    default:
                        choicesDiv.hide();
                }
                setNewChoiceCallbacks();
            });
        });
    };

    $(document).ready(function() {
        initialize();
    });

}).call(this);