/* -*- JavaScript -*-
*/

$( document ).ready(function() {
    $( ".dialog" ).dialog({
	autoOpen: false,
	width: "60%"
    });

    $( ".dialog-link" ).click(function( event ) {
        id = $(this).attr('href').substr(1)
        console.log("ID:" + id)
        $( "#" + id ).dialog( "open" );
	event.preventDefault();
    });
})
