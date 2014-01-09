<!-- Begin: Header.inc -->
<table border="0" cellpadding="0" cellspacing="0" class="topbar">
    <tr>
        <td class="topbar_events">
            <a href="http://anytickets.com">
                <span class="logo">
                    Any Tickets
                </span>
            </a>
        </td>
        <td class="topbar_links">
            <div class="top-links">
                <a href="http://anytickets.com/static/about_us">About Us</a>
            </div>
            <div class="form-search clearfix">
                    <input name="utf8" type="hidden" value="&#x2713;">
                    <input type="text" placeholder="Search by artist, performer, team, or category" name="search_term" id="searchinput"  class="input-medium search-query" autocomplete="off" onkeyup="searchKeyUp(event)">
                    <input id="searchMainSubmit" type="button" value="" class="btn" onclick="searchMain();">
            </div>
            <script type="text/javascript">
                function searchKeyUp(e){
                    if (e == null){e = window.event};
                    if(e.keyCode == 13)  {
                        searchMain();
                    };
                };
                function searchMain(){
                    var search = document.getElementById('searchinput');
                    var value = encodeURIComponent(search.value);
                    window.location = "http://anytickets.com/search/free_search?utf8=✓" + '&search_term=' + value; 
                };
            </script>
        </td>
    </tr>
</table>
<!-- End: Header.inc -->