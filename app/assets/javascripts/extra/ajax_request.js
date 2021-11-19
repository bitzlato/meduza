const getVersion = (url, el) => {
  let xhr = new XMLHttpRequest();

  xhr.open('GET', url, false);

  try {
    xhr.send();
    if (xhr.status != 200) {
      console.error(`Ошибка ${xhr.status}: ${xhr.statusText}`);
    } else {
      data = JSON.parse(xhr.response);
      el.html(el.data('prefix') + data['build_date'] + ' ' + data['git_sha']);
    }
  } catch(err) { // для отлова ошибок используем конструкцию try...catch вместо onerror
    console.error(`Запрос (${url}) не удался, с ошибкой`, err);
  }
}

document.addEventListener("turbolinks:load", function() {
  $('[data-api-version]').each( (index, el) => {
    el = $(el)
    getVersion(el.data('url'), el);
  })
});
