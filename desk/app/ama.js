document.addEventListener('DOMContentLoaded', function() {
    document.body.addEventListener('htmx:afterRequest', function(event) {

        if (event.detail.requestConfig.verb.toUpperCase() === 'POST' &&
            event.detail.requestConfig.path === '/apps/ama/bio') {
            console.log('Reloading due to POST request to /apps/ama/bio');
            setTimeout(function() {
                window.location.reload();  
            }, 001);
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