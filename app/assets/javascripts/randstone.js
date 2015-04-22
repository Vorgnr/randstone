
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
            initialLineNumber: 4,
            getCards: function(url, offset, limit, callback) {
                Randstone.ajax(url, {
                    offset: offset,
                    limit: limit
                }, callback);
            }
        }
    },
    ajax: function(url, data, success, error) {
        $.ajax({
            type: 'post',
            url: url,
            data: JSON.stringify(data),
            dataType: "json",
            headers: {
                "Content-Type": "application/json",
                "Accept": "application/json"
            },
            success: success
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