
function Randstone() {
    this.config = {
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
       } 
    };

    this.delay = (function(){
        var timer = 0;
        return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
        };
    })();
}

Randstone.prototype.ajax = function(url, data) {
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
};

window.Randstone = new Randstone();