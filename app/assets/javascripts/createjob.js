$(document).ready(function() {
    var jobWizard = $("#job-wizard");
    if(jobWizard != null ){
        jobWizard.steps({
            headerTag: "h3",
            bodyTag: "section",
            transitionEffect: "slideLeft",
            autoFocus: true,
            stepsOrientation: "vertical"
        });
    }
});