const form = document.getElementById('contactForm');
form.addEventListener('submit', function(e) {
    e.preventDefault();

    fetch("https://sy1eax617j.execute-api.us-east-1.amazonaws.com/prod/users",
    {
        method: "POST",
        body: JSON.stringify({
            userID: 23,
            name: document.getElementById("name").value,
            email: document.getElementById("email").value, 
            career: document.getElementById("career").value,
            description: document.getElementById("description").value,
            skills: document.getElementById("skills").value,
            passions: document.getElementById("passions").value,
        })
    })
    .then(function(res){ return res.json(); })
    .then(function(data){ alert( JSON.stringify( data ) ) })
})