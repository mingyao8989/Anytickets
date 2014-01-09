$(document).ready(function() {
	$('.dropdown-toggle').dropdown();
	$('.dropdown-menu li a').click(function(e){
		e.stopPropagation();
	});

	$('form#tickets-filter').submit(function(e){
		var opts = {
		  lines: 13, // The number of lines to draw
		  length: 11, // The length of each line
		  width: 4, // The line thickness
		  radius: 18, // The radius of the inner circle
		  corners: 1, // Corner roundness (0..1)
		  rotate: 0, // The rotation offset
		  color: '#000', // #rgb or #rrggbb
		  speed: 1.5, // Rounds per second
		  trail: 72, // Afterglow percentage
		  shadow: false, // Whether to render a shadow
		  hwaccel: false, // Whether to use hardware acceleration
		  className: 'spinner', // The CSS class to assign to the spinner
		  zIndex: 2e9, // The z-index (defaults to 2000000000)
		  top: 'auto', // Top position relative to parent in px
  		left: 'auto' // Left position relative to parent in px
		};
		var spinner;
		var target = document.getElementById('spinner');
		//$('.tickets-list tbody').html("");
		spinner = new Spinner(opts).spin(target);
	});

	$('.carousel').carousel();
	
	$('#myTab a:first').tab('show');
	
	$(".alert").alert();
	
	$('.table1 .more-lnk').tooltip();
	
	$(".read-more a").click(function() {
		if( $('.entry').hasClass('active'))
		{
	  		$('.post .entry').css('height', '200px');
			$('.entry').removeClass('active');
			$('.read-more').removeClass('active');
		}
		else
		{
			$('.post .entry').css('height', 'auto');
			$('.entry').addClass('active');
			$('.read-more').addClass('active');
		}
		
		return false;
	});
	//set a-z index to work
	$('section.browse-tickets p.index a').click(function(){
		var link;
		link=$(this).attr('href');
		$("#myTab a[href='"+link+"']").click();
	});

	//hide form submit buttons, set submit on select
	$('form#sort-field #sort').hide();
	$('form#sort-field select').change(function(){
		$('form#sort-field').submit();
	});
	$('form#tickets-filter input').hide();
	$('form#tickets-filter select').change(function(){
		$('form#tickets-filter').submit();
	});

	//set up datepicker
	$(document).on("focus", "[data-behaviour~='datepicker']", function(e){
		$(this).datepicker({"format":"yyyy-mm-dd", "weekStart":1, "autoclose":true,"language":"en"});
	});

	//hide "read more" button when content is short
	$('.post .entry').css('height', 'auto');
	if ($("article#featured section.entry").height() < 200) {
		$('p.read-more').hide();
	}
	$("article#featured section.entry").height(200);

	//set the free search form to submit when selecting from autocomplete
	$('#searchinput').bind('selected', function(){
 		$('form.form-search').submit();
	});
});