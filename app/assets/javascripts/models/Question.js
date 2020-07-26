// Question types; 1 - Open Ended, 2 - Single Option, 3 - Multiple Option

_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

var question_template = ""+
    "<div class='col-sm-12'>"+
        "<div class='row'>"+
            "<input type=\"text\" id=\"question_{{= id }}\" value=\"{{= content }}\" placeholder=\"Title\" class=\"btn-xs col-sm-12\">"+
        "</div>"+
        "<div class='row padding-10'>"+
            "<div class='col-sm-8'></div>"+
            "<div class='col-sm-4'>"+
                    "<select id=\"type_{{= id }}\" class=\"col-sm-6\" data-id='{{= id }}'\"><option value='0'>Question type</option>"+
                    "<option value='1'>Open Ended</option><option value='2'>Single Option</option>"+
                    "<option value='3'>Multiple Option</option></select>"+
                    "<a id=\"remove_{{= id }}\" class=\"btn btn-danger btn-xs col-sm-6\" href=\"#\" data-id='{{= id }}'\">Remove Question</a>"+
            "</div>"+
        "</div>"+
        "<div id=\"choices_{{= id }}\" class='col-sm-12'></div>"+
    "</div>";

var Question = Backbone.Model.extend({
    defaults: {
        id: 0,
        job_id: 0,
        content: '',
        type: 0,
        choices: new ChoicesCollection()
    },
    validate: function(attributes){
        if ( attributes.job_id < 1 ){
            return 'Question must have job_id';
        }

        if ( !attributes.content || attributes.content.length < 1){
            return 'Question must have content';
        }

        if (attributes.type < 1 || attributes.type > 3){
            return 'Invalid Question type';
        }
    },
    save: function(){
        var id = this.id;
        var content = $("#question_"+id).val();
        var type = parseInt($("#type_"+id).val());
        if (this.set({content: content,type: type})){
            alert("validate passed");
        }else{
            alert("validate failed");
        }

    }
});

var QuestionsCollection = Backbone.Collection.extend({
    url: '/ajax_questions',
    model: Question
});

var QuestionView = Backbone.View.extend({
    tagName: 'div',
    className: 'row padding-10',
    template: _.template(question_template),
    initialize: function(){
        this.render();
    },
    render: function(){
        this.$el.html( this.template(this.model.toJSON()));
    }
});