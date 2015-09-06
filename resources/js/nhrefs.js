// See http://balisage.net/Proceedings/vol7/html/Vlist01/BalisageVol7-Vlist01.html
//
// This code relies on jquery and jquery-ui (which in turn relies on some jquery-ui CSS)
// to be loaded first/as well.
//
// <script src="http://ajax.googleapis.com/ajax/libs/jquery/1.6.2/jquery.min.js"
//         type="text/javascript"></script>
// <script src="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"
//         type="text/javascript"></script>
// <link href="http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/start/jquery-ui.css"
//         type="text/css" rel="Stylesheet" />

jQuery(document).ready(function() {

    jQuery('.nhrefs')
        .each(function() {

            var span = jQuery(this);
            span.hide();
            var source = jQuery('.source', this).text();
            var link = jQuery(span.before('<a href="">'+ source +'</a>')[0].previousSibling);
            var dialog = jQuery(span.before('<div title="Links for &quot;'+ source + '&quot;"><ul /> </div>')[0].previousSibling);
            var list = jQuery('ul', dialog);
            jQuery('a.arc', this)
                .each(function(){
                    list.append('<li><a href="' + this.href + '">' + this.text + '</a>');
                });
            dialog.dialog({ autoOpen: false });
            link.click(function() {
                dialog.dialog("open");
                return false;
            });
        });

 });
