const form = document.getElementById('contactForm');
form.addEventListener('submit', function(e) {
        e.preventDefault();
        const payload = new FormData(form);
          fetch('https://9uyxm5giti.execute-api.us-east-1.amazonaws.com/prod', {
                    method: 'POST',
                    mode: 'cors',
                    body: payload,
                    headers: new Headers({
                                'Content-Type': 'application/json',
                                'Access-Control-Allow-Origin': '*',
                                'Access-Control-Allow-Methods': 'OPTIONS,POST,GET'
                            })
          })
            .then(res => res.json())
            .then(data => console.log(data))
            .catch(err => console.log(err));
})
