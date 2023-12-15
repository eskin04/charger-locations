const citiesUrl = 'http://localhost:3000/api/cities'

function getCities(city) {
    fetch(`${citiesUrl}?city=${city}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            
        })
        .then(res => res.json())
        .then(data => {
          console.log(data)
          if(data.length == 0){
            document.getElementById('cities').innerHTML = '<tr><td colspan="5" class="text-center">Veri Bulunamadı</td></tr>'
            return
          }
          
          let html = ''
            data.forEach(city => {
                html += `<tr>
                <td>${city.plaka}</td>
                <td>${city.iller_ad}</td>
                <td>${city.nufus_23}</td>
                <td >${city.istasyon_sayisi}</td>
                <td>  <button class = "analiz" id="${city.plaka}" onclick="location.href='/city/${city.plaka}'" data-hover="Analiz"><div class="fa fa-solid fa-charging-station"></div></button>
                </td>
            </tr>`
            })
            document.getElementById('cities').innerHTML = html
        })
        .catch(err => console.log(err))
}

getCities('')
