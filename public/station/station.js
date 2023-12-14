const stations_url = "http://localhost:3000/api/stations"

fetch(stations_url)
.then(response => response.json())
.then(data => {
    console.log(data)
    let html = ''
    let id = 1
    data[0].forEach(station => {
        html += `<tr>
        <td>${id}</td>
        <td>${station.istasyon_kodu}</td>
        <td>${station.model_kodu}</td>
        <td>${station.model_adi}</td>
        <td>${station.iller_ad}</td>
        <td>${station.adres}</td>
        <td><button class="${station.aktiflik ==1?'btn-success rounded px-4':'btn-danger rounded px-4 text-decoration-line-through'}">${station.aktiflik == 1? "Aktif" : "Pasif"}</button></td>
        </tr>`
        id++
    })
    document.getElementById('stations').innerHTML = html
})