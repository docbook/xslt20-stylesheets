/* -*- JavaScript -*-
*/

function show_annotation(id) {
    var annot = document.getElementById('annot-'+id);
    annot.style.display = "block";
    annot = document.getElementById('annot-'+id+'-on');
    annot.style.display = "none";
    annot = document.getElementById('annot-'+id+'-off');
    annot.style.display = "inline";
    return false;
}

function hide_annotation(id) {
    var annot = document.getElementById('annot-'+id);
    annot.style.display = "none";
    annot = document.getElementById('annot-'+id+'-on');
    annot.style.display = "inline";
    annot = document.getElementById('annot-'+id+'-off');
    annot.style.display = "none";
    return false;
}


