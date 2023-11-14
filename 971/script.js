function handleNotifications(title, body, icon, roomid) {
    if ('Notification' in window) {
        Notification.requestPermission().then(function(permission) {
            if (permission === 'granted') {
                var notification = new Notification(title, {
                    body: body,
                    icon: icon,
                });

                notification.onclick = function() {
                    console.log('CLICKED ON NOTIFICATION!!!!');
                    var host = window.location.host;
                    var redirectURL = 'http://' + host + '/#/rooms/' + roomid;
                    window.location.href = window.location.href;
                    notification.close();
                };
            } else {
                console.log('Permission for notifications denied');
            }
        }).catch(function(err) {
            console.error('Error requesting permission:', err);
        });
    } else {
        console.log('Notifications not supported in this browser');
    }
}