
var Randstone = {
    image: {
        medium: {
            height: 270
        }
    },
    cardCollections: {
        pagination: {
            offset: 0,
            limit: 20,
            initialLineNumber: 4
        }
    },
    ajax: function(url, data) {
        return $.ajax({
            type: 'post',
            url: url,
            data: JSON.stringify(data),
            dataType: "json",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            }
        });
    },
    delay: (function(){
        var timer = 0;
        return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
        };
    })()
};