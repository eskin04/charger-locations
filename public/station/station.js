const stations_url = "http://localhost:3000/api/stations"

function stations(city) {
    fetch(`${stations_url}?city=${city}`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            
        })
        .then(res => res.json())
        .then(data => {
            if(data.length == 0){
                document.getElementById('stations').innerHTML = '<tr><td colspan="7" class="text-center">Veri Bulunamadı</td></tr>'
                return
            }
            let html = ''
            let id = 1
            data.forEach(station => {
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
        .catch(err => console.log(err))
}

stations('')



