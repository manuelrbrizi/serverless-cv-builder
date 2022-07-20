fetch("${API_ENDPOINT}/users/23")
.then(async response => {
    const data = await response.json();

    // check for error response
    if (!response.ok) {
        const error = (data && data.message) || response.status;
        return Promise.reject(error);
    }

    var template = document.getElementById('template').innerHTML;
    console.log(data);
    var params = { name: data.Item.name, email: data.Item.email, career: data.Item.career, description: data.Item.description, skills: data.Item.skills, passions: data.Item.passions }
    var rendered = Mustache.render(template, params);
    document.getElementById('target').innerHTML = rendered;

    element.innerHTML = data?.total;
})
