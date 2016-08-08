$(document).on('map_display#map:loaded', function(){
    // Add geolocation button
    //L.control.locate().addTo(map);

    /* ------- TIPS LOGIC ------- */
    var h = $('#main-container').height();
    $('#image-map').height() ;

    $( "#libraries-and-floors" ).click(function() {
        $(".optionsTopBar").slideToggle();
        $("#image-map").toggleClass("image-map-open");
    });

    $( "#qr-code" ).click(function() {
        $("#qr-container").toggle();
    });

    var state = "searching";

    $( "#help-info-yes" ).click(function() {
        if(state == "searching") {
            $("#help-info").slideToggle();
            $.ajax({
                url: "/save_statistics",
                type: "post",
                data: {found: true},
            });
        }else if(state == "floor-question"){
            $("#help-info-text").text("Have you checked the recent return shelf?");
            state = "recent-returns"
        }else if(state == "recent-returns"){
            $("#help-info-text").css("padding", "45px");
            $("#help-info-text").text("Apologies for the inconvenience. Please contact the help desk services in the library if you have further questions.");
            $.ajax({
                url: "/save_statistics",
                type: "post",
                data: {found: false},
            });
        }
    });

    $( "#help-info-not-yet" ).click(function() {
        $("#help-info").slideToggle();
        helpInfo(60000);

        setTimeout(function () {
            if (state == "floor-question" || state == "recent-returns") {
                $("#help-info-yes div").width("33.33%");
                $("#help-info-not-yet div").width("33.33%");
                $("#help-info-not-yet div").text("Not yet...");
                $("#help-info-text").text("Have you found your book?");
                state = "searching"
            }
        }, 60000);
    });

    $( "#help-info-no" ).click(function() {
        $("#help-info-yes div").width("50%");
        $("#help-info-not-yet div").width("50%");
        $("#help-info-not-yet div").text("No!");
        $("#help-info-text").text("Are you on the " + $('.btn-floor[data-floor="<%= @floor %>"]').text() + " floor?");
        state = "floor-question";
    });
});

function helpInfo(time){
    setTimeout(function () {
        $("#help-info").slideToggle();
    }, time);
}