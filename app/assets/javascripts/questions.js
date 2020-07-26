(function() {
    var new_count = 0;
    var questionsCollection;
    var choicesCollection;

    var choice_template = "<div id=\"choice_list_{{= id }}\"></div>"+
        "<div class=\"col-sm-12\"><a id=\"new_choice_{{= id }}\" data-question_id='{{= id }}' class=\"btn btn-primary btn-sm\" href=\"#\">Add Choice</a></div>";

    var setNewChoiceCallbacks = function(){
        var el = $("#questions");
        var newChoices = el.find("a[id^='new_choice_']");
        _.each(newChoices,function(new_choice){
            var button = $(new_choice);
            button.off("click");
            button.on("click", function() {
                var questionId = button.data("question_id");
                var choice = new Choice();
                choice.set('id',new_count);
                choice.set('question_id',questionId);

                var choiceView = new ChoiceView({model:  choice});
                choicesCollection.add(choice);
                el.find("#choice_list_"+questionId).append(choiceView.el);
                setRemoveChoiceCallbacks();
                new_count++;
                return false;
                e.preventDefault();
            });
        });
    };

    var setQuestionTypeCallbacks = function(){
        var el = $("#questions");
        var options = el.find("select[id^='type_']");
        _.each(options, function(item) {
            var select = $(item);
            select.on("change", function() {
                var id = select.data("id");
                var selectedValue = $(this).find(":selected").val();
                var choicesDiv = $("#choices_"+id);
                switch(parseInt(selectedValue)) {
                    case 2: //Single Option
                    case 3: //Multiple Option
                        var template = _.template(choice_template);
                        choicesDiv.html(template({id: id}));
                        break;
                    default:
                        choicesDiv.html("<div>No Choices</div>");
                }
                setNewChoiceCallbacks();
            });
        });
    };

    var setRemoveChoiceCallbacks = function(){
        var el = $("#questions");
        var removeButtons = el.find("a[id^='remove_choice_']");
        _.each(removeButtons, function(item) {
            var button = $(item);
            button.on("click", function() {
                var id = button.data("id");
                el.find('#choice_'+id).parent().remove();
                var choiceModel = choicesCollection.get(id);
                choicesCollection.remove(choiceModel);
                return false;
                e.preventDefault();
            });
        });
    };

    var setRemoveCallbacks = function(){
        var el = $("#questions");
        var removeButtons = el.find("a[id^='remove_']");
        _.each(removeButtons, function(item) {
            var button = $(item);
            button.on("click", function() {
                var id = button.data("id");
                el.find('#question_'+id).parent().parent().remove();
                var questionModel = questionsCollection.get(id);
                questionsCollection.remove(questionModel);
                return false;
                e.preventDefault();
            });
        });
    };

    var addQuestionToDom = function(question){
        var el = $("#questions");
        question.set('id',new_count);
        var questionView = new QuestionView({model: question});
        questionsCollection.add(question);
        el.find("#list").append(questionView.el);
        setRemoveCallbacks();
        setQuestionTypeCallbacks();
        setNewChoiceCallbacks();
        new_count++;
    };
    var initialize = function(){
        var el = $("#questions");
        if(el.length == 0){
            return;
        }

        setRemoveCallbacks();
        setQuestionTypeCallbacks();

        choicesCollection = new ChoicesCollection();
        questionsCollection = new QuestionsCollection();
        questionsCollection.fetch({
            success: function() {
                questionsCollection.each(function(question) {
                    console.log(question.toJSON());
                    addQuestionToDom(question);
                });
            },
            error: function() {
                new Error({ message: "Error loading questions." });
            }
        });

        el.find("#new_question").on("click", function() {
            var question = new Question();
            addQuestionToDom(question);
            return false;
            e.preventDefault();
        });

        el.find("#save_quiz").on("click", function() {
            _.each(questionsCollection.models,function(question) {
                question.save();
            });

            //TODO: save models
            alert(JSON.stringify(questionsCollection));
            return false;
            e.preventDefault();
        });

        setNewChoiceCallbacks();
    };

    $(document).ready(function() {
        initialize();
    });

}).call(this);