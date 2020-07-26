(function() {
    var el;

    var loading_overlay = "<div class=\"overlay text-center\">"+
        "<i class=\"fa fa fa-spinner fa-spin fa-4x\"></i>"+
        "</div>";

    var save_success_message = "<div class=\"label-success btn-block text-center padding-10\">Fields successfully saved</div>";
    var save_failed_message = "<div class=\"label-danger btn-block text-center padding-10\">Fields could not be saved</div>";

    var orderFields = function(){
        var list = $(el).find(".builder_content").find("div[id^='job_field_']");
        if(list.length > 0){
            tinysort(list,{attr:'data-position'});
        }
        resetFooter();
    }

    var getFieldWithPosition = function(position){
        var fieldsHtml = $(el).find(".builder_content").find("div[id^='job_field_']");

        var field = _.find(fieldsHtml, function(item) {
            var pos = $(item).attr("data-position");
            return pos == position;
        });
        return field;
    };

    var setMoveCallback = function(){
        var fieldsHtml = $(el).find(".builder_content").find("div[id^='job_field_']");
        _.each(fieldsHtml, function(field) {
            var id = $(field).data("id");
            var upButton = $(field).find("#job_field_up_"+id);
            var downButton = $(field).find("#job_field_down_"+id);

            if(id = ""){
                upButton.remove();
                downButton.remove();
            }else{
                upButton.off("click");
                upButton.on("click",function(){
                    var id = upButton.data("id");
                    showTinyProgress(true,id);

                    $.post( "/move_job_field",{id: id,direction: "up"}, function( data ) {
                        var movedField = $(el).find(".builder_content").find("#job_field_"+data["id"]);
                        var replacedField = getFieldWithPosition(data["position"]);

                        var newReplacedPosition = $(movedField).attr("data-position");
                        var newMovedPosition = data["position"];

                        $(replacedField).attr("data-position",newReplacedPosition);
                        $(movedField).attr("data-position",newMovedPosition);

                        orderFields();
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

                    $.post( "/move_job_field",{id: id,direction: "down"}, function( data ) {
                        var movedField = $(el).find(".builder_content").find("#job_field_"+data["id"]);
                        var replacedField = getFieldWithPosition(data["position"]);

                        var newReplacedPosition = $(movedField).attr("data-position");
                        var newMovedPosition = data["position"];

                        $(replacedField).attr("data-position",newReplacedPosition);
                        $(movedField).attr("data-position",newMovedPosition);
                        orderFields();
                    }).fail(function() {
                        alert("Something went wrong!");
                    }).always(function(){
                        showTinyProgress(false,id);
                    });
                });
            }
        });
    };

    var setRemoveCallbacks = function(){
        var removeButtons = el.find("a[id^='job_field_remove_']");
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
                    $.post( "/delete_job_field",{id: id}, function( data ) {
                        el.find('#job_field_'+id).remove();
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

    var showTinyProgress = function(show, job_field_id){
        var optinsDiv = $(el).find('#actions_'+job_field_id);
        if(show){
            $(optinsDiv).find(".actions_progress").show();
            $(optinsDiv).find(".actions_buttons").hide();
        }else{
            $(optinsDiv).find(".actions_progress").hide();
            $(optinsDiv).find(".actions_buttons").show();
        }
    }

    var showFooterProgress = function(show){
        if(show){
            $(el).find(".footer_progress").show();
            $(el).find("#new_field").prop( "disabled", true );
            $(el).find("#save_fields").prop( "disabled", true );
        }else{
            $(el).find(".footer_progress").hide();
            $(el).find("#new_field").prop( "disabled", false );
            $(el).find("#save_fields").prop( "disabled", false );
        }
    }

    var showProgress = function(show){
        if(show){
            $(el).append(loading_overlay);
        }else{
            $(el).find(".overlay").remove();
        }
    }

    var loadExisting = function(id){
        $.get("/job_fields",{id: id}, function(data){
            $(el).find(".builder_content").prepend(data);
            orderFields();
            setRemoveCallbacks();
            setMoveCallback();
        },"html").fail(function() {
            alert("Something went wrong!");
        }).always(function(){
            showProgress(false);
        });
    };

    var saveFields = function(){
        var fieldsHtml = el.find("div[id^='job_field_']");
        var jobFields = new Array();
        _.each(fieldsHtml, function(field) {
            var job_id = $(el).data("id");
            var id = $(field).data("id");
            var position = $(field).data("position");
            var title = $(field).find("#job_field_title_"+id).val();
            var content = $(field).find("#job_field_content_"+id).val();

            jobFields.push({id:id,job_id:job_id,title:title,content:content,position:position});
        });

        if(jobFields.length>0){
            resetFooter();
            $.post( "/save_fields",{fields: jobFields}, function() {
                $(el).find("#job_field_builder_footer").append(save_success_message);
            }).fail(function() {
                $(el).find("#job_field_builder_footer").append(save_failed_message);
            }).always(function(){
                showFooterProgress(false);
            });
        }else{
            showFooterProgress(false);
            alert("Nothing to save!");
        }
    };

    var resetFooter = function(){
        $(el).find("#job_field_builder_footer").empty();
    };

    var initialize = function(){
        el = $("#job_field_builder_container");
        if(el.length == 0){
            return;
        }
        showProgress(true);
        var id = $(el).data("id");
        el.find("#new_field").on("click", function() {
            resetFooter();
            showFooterProgress(true);

            $.post( "/new_job_field",{id: id}, function( data ) {
                $(el).find(".builder_content").append(data);
                setRemoveCallbacks();
                setMoveCallback();
            }).fail(function() {
                alert("Something went wrong!");
            }).always(function(){
                showFooterProgress(false);
            });
            return false;
            e.preventDefault();
        });

        el.find("#save_fields").on("click", function() {
            resetFooter();
            showFooterProgress(true);
            saveFields();
            return false;
            e.preventDefault();
        });

        loadExisting(id);
    };

    $(document).ready(function() {
        initialize();
    });

}).call(this);