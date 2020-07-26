_.templateSettings = {
    interpolate: /\{\{\=(.+?)\}\}/g,
    evaluate: /\{\{(.+?)\}\}/g
};

var choice_template = ""+
    "<input type=\"text\" id=\"choice_{{= id }}\" value=\"{{= content }}\" placeholder=\"Title\" class=\"btn-xs col-sm-10\">"+
    "<a id=\"remove_choice_{{= id }}\" class=\"btn btn-danger btn-xs col-sm-2\" href=\"#\" data-id='{{= id }}'\">Remove</a>";

var Choice = Backbone.Model.extend({
    defaults: {
        id: 0,
        question_id: 0,
        content: ''
    }
});

var ChoicesCollection = Backbone.Collection.extend({
    model: Choice
});

var ChoiceView = Backbone.View.extend({
    tagName: 'div',
    className: 'row padding-10',
    template: _.template(choice_template),
    initialize: function(){
        this.render();
    },
    render: function(){
        this.$el.html( this.template(this.model.toJSON()));
    }
});