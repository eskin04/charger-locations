const istasyonSayUrl = 'http://localhost:3000/api/cities'

fetch(istasyonSayUrl)
.then(response => response.json())
.then(data => {
  console.log(data)
  
  let html = ''
    data.forEach(city => {
        html += `<tr>
        <td>${city.plaka}</td>
        <td>${city.iller_ad}</td>
        <td>${city.nufus_23}</td>
        <td >${city.istasyon_sayisi}</td>
        <td>  <button class = "analiz" id="${city.plaka}" data-hover="Analiz"><div class="fa fa-solid fa-charging-station"></div></button>
        </td>
    </tr>`
    })
    document.getElementById('cities').innerHTML = html
})