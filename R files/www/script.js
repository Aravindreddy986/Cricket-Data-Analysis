<div id='cricapi_widget_livescores'></div>
<script>
    //localStorage["matches"] = "1022593,913643";   // this will limit the matches to these 2 only. Match unique_id on http://cricapi.com/api/cricket
    // set localStorage["matches"] = "" or localStorage["matches"] = null to clear this and show all matches again

    (function (C, r, i, c, a, p, I) {
        c = document.createElement('script');
        c.src = "//" + r + "/" + i + "/widget.js";
        document.getElementsByTagName('head')[0].appendChild(c);
    })("livescores", "cricapi.com", "widgets");
</script>