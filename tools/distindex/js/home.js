// -*- Espresso -*-
$(document).ready(function(){
    $("dt.dir").click(function(){
        toggle(this);
    });
});

function toggle(dt) {
    var id = $(dt).attr("id");
    var dd = $("#dd-"+id);

    $(dt).toggleClass("toggleClosed");
    $(dt).toggleClass("toggleOpen");

    if ($(dt).hasClass("toggleOpen")) {
        dd.css("display", "block");
    } else {
        dd.css("display", "none");
    }
}
