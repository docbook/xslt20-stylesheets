/* -*- JavaScript -*-
*/

$( document ).ready(function() {
    $( ".dialog" ).dialog({
	autoOpen: false,
	width: "60%"
    });

    $( ".dialog-link" ).click(function( event ) {
        id = $(this).attr('id').substr(11)
        console.log("ID:" + id)
        $( "#" + id ).dialog( "open" );
	event.preventDefault();
    });
})
