textField=$('#content');

function send_message(){
    var http = new XMLHttpRequest();
    var url = window.location.href;

    var content = textField.val();
    textField.val('');
    $('#comments').append('<p class="comment">'+content+'</p>');
    http.open("POST", url, true);

    http.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
    http.send('content='+content);
}

textField.onkeydown = function(event) {
    var e = event || window.event;

    if (e.keyCode === 13) {
        send_message()
    }
}