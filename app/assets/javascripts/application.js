// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require rich
//= require_tree .
//= require bootstrap-datepicker/core


// Auto complete search on header. uses Bootstrap typeahead
$(function() {

      $('.typeahead').typeahead();
      $('input[placeholder], textarea[placeholder]').placeholder();
      $("#e2").select2({
        placeholder: "select city",
        allowClear: true
      });
      $("#location_select > input").hide();
      $("#e2").change(function(){
        $("#location_select").submit();
      });   
      //$(".select2-choice span").text($("#e2").val())
    var autocomplete = $('#searchinput').typeahead()
        .on('keyup', function(ev){

            ev.stopPropagation();
            ev.preventDefault();

            //filter out up/down, tab, enter, and escape keys
            if( $.inArray(ev.keyCode,[40,38,9,13,27]) === -1 ){

                var self = $(this);

                //set typeahead source to empty
                self.data('typeahead').source = [];

                //active used so we aren't triggering duplicate keyup events
                if( !self.data('active') && self.val().length > 0){

                    self.data('active', true);

                    //Do data request.
                    $.getJSON("/search/autocomplete.json?",{
                        term: $(this).val()
                    }, function(data) {

                        //set this to true when your callback executes
                        self.data('active',true);

                        //Filter out your own parameters. Populate them into an array, since this is what typeahead's source requires
                        var arr = [],
                            i=data.length;
                        while(i--){
                            arr[i] = data[i].label
                        }

                        //set your results into the typehead's source
                        self.data('typeahead').source = arr;

                        //trigger keyup on the typeahead to make it search
                        self.trigger('keyup');

                        //All done, set to false to prepare for the next remote query.
                        self.data('active', false);

                    });

                }
            }
        });
});
