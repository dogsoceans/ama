document.addEventListener('DOMContentLoaded', function() {
    document.body.addEventListener('htmx:afterRequest', function(event) {
        const xhr = event.detail.xhr;  // Access the XMLHttpRequest object used by HTMX
        const customHeader = xhr.getResponseHeader('cats');
        const customHeader2 = xhr.getResponseHeader('cats2');
        const customHeader3 = xhr.getResponseHeader('cats3');

        if (customHeader === 'cats') {
            console.log('.refresh triggered');
            setTimeout(function() {
                htmx.trigger('.refresh', 'click');  
            }, 500);
        }

        if (customHeader2 === 'cats2') {
            console.log('.refresh triggered');
            setTimeout(function() {
                htmx.trigger('.refresh', 'click');  
            }, 500);
        }
        if (customHeader3 === 'cats3') {
            console.log('.refresh triggered');
            setTimeout(function() {
                htmx.trigger('.refresh', 'click');  
            }, 500);
        }

    });


        const copyButton = document.getElementById('copyButton');
        if (copyButton) {
            copyButton.addEventListener('click', function() {
                navigator.clipboard.writeText(window.location.href)
                    .then(() => {
                    })
                    .catch(err => {
                        console.error('Error copying URL: ', err);
                        alert('Failed to copy URL.');
                    });
            });
        }
        
});
