
fetch('http://localhost:3000/api/stations')
.then(response => response.json())
.then(data => {
  console.log(data[0][0].lat)
  let id = 1
  for (var i = 1; i<data[0].length; i++) {

    let lat = data[0][i].lat
    let lng = data[0][i].lng
    let hizmet_saati = data[0][i].hizmet_saati
    if(hizmet_saati.includes("|"))
    {
      hizmet_saati = "7/24 açık"
    }
    else{
      hizmet_saati = "Pazartesi-Cuma 08:00-17:00"
    }
    properties.push({
      id: id,
      code: data[0][i].istasyon_kodu,
      city: data[0][i].iller_ad,
      model_name: data[0][i].model_adi,
      model_desc: data[0][i].model_aciklama,
      plug_type: data[0][i].soket_tipi,
      plug_number: data[0][i].soket_sayisi,
      aktiflik: data[0][i].aktiflik == 1? "Aktif" : "Kullanım Dışı",
      address: data[0][i].adres,
      indoor: data[0][i].lokasyon_tipi=0? "İç Mekan" : "Dış Mekan",
      hizmetsaati: hizmet_saati,
      otopark: data[0][i].otopark,
      parksure: data[0][i].park_suresi,
      
      type: data[0][i].aktiflik == 1 ? "charging-station" : "store-slash",
      position: {
        lat: lat,
        lng: lng,
      },
    })
    id++
    

  }
  console.log(properties)
  
})
.catch(err => console.log(err))

async function initMap() {
    
    // Request needed libraries.
    const { Map } = await google.maps.importLibrary("maps");
    const { AdvancedMarkerElement } = await google.maps.importLibrary("marker");
    const center = { lat: 39.3223937, lng: 35.157965 };
    const map = new Map(document.getElementById("map"), {
      zoom: 6.75,
      center,
      mapId: "4504f8b37365c3d0",
    });
  
    for (const property of properties) {
      const AdvancedMarkerElement = new google.maps.marker.AdvancedMarkerElement({
        map,
        content: buildContent(property),
        position: property.position,
        title: property.description,
      });
  
      AdvancedMarkerElement.addListener("click", () => {
        toggleHighlight(AdvancedMarkerElement, property);

      });
      
      
      
    }
  }
  
  var lastHighlightedMarker = null;
  var removeHighlight = null;

  function toggleHighlight(markerView, property) {
    last_table = markerView.content.id;
    console.log('tıklandı')
    if (lastHighlightedMarker) {
        lastHighlightedMarker.content.classList.remove("highlight");
        lastHighlightedMarker.zIndex = null;
      }

      // Tıklanan marker'ı vurgula
      
      if(removeHighlight && removeHighlight==markerView){
        markerView.content.classList.remove("highlight");
        markerView.zIndex = null;
        removeHighlight = null;
        return;
      }
      markerView.content.classList.add("highlight");
      markerView.zIndex = 1;

      // Tıklanan marker'ı önceki vurgulanmış marker olarak kaydet
      lastHighlightedMarker = markerView;
    
  

  }

  function closeHighlight() {
    removeHighlight = lastHighlightedMarker;
    

  }
  
  var last_table = null;

  
  function toggleTable(tableNumber) {
      const id = tableNumber.id;
      console.log(tableNumber.id)
      console.log(last_table)
      console.log(document.getElementById("istasyon"+last_table))
      if(id.includes("istasyon")){
        document.getElementById("istasyon"+last_table).style.display = "block";
        document.getElementById("lokasyon"+last_table).style.display = "none";
        document.getElementById("hizmetler"+last_table).style.display = "none";
      }
      else if(id.includes("lokasyon")){
        document.getElementById("lokasyon"+last_table).style.display = "block";
        document.getElementById("istasyon"+last_table).style.display = "none";
        document.getElementById("hizmetler"+last_table).style.display = "none";
      }
      else if(id.includes("hizmetler")){
        document.getElementById("hizmetler"+last_table).style.display = "block";
        document.getElementById("istasyon"+last_table).style.display = "none";
        document.getElementById("lokasyon"+last_table).style.display = "none";
      }
          
      
    
      
    
  }
  
  function buildContent(property) {
    const content = document.createElement("div");
    content.classList.add("property");
    content.id = property.id;
    content.innerHTML = `
    <div class="icon">
    <i aria-hidden="true" class="fa-solid fa-${property.type}" title="${property.type}"></i>
</div>
<div class="details">
  <div class="btn-container">
  <button onclick = toggleTable(istasyon${property.id})>İstasyon</button>
  <button onclick = toggleTable(lokasyon${property.id})>Lokasyon</button>
  <button onclick = toggleTable(hizmetler${property.id})>Hizmetler</button>
    
    <button onclick = closeHighlight() style="position:absolute;
    right: 10px; top: 15px;" class="fa-solid fa-circle-xmark fa-2xl"></button>


  </div>
  <div class="descs">
    <div id="istasyon${property.id}" style="display:block">
    <table  width='500px' class="table-hover" >
      <tr>
        <th>İstasyon Kodu</th>
        <td>${property.code}</td>
      </tr>
      <tr>
        <th>Model Adı</th>
        <td>${property.model_name}</td>
      </tr>
      <tr>
        <th>Model Açıklaması</th>
        <td>${property.model_desc}</td>
      </tr>
      <tr>
        <th>Soket</th>
        <td>${property.plug_type} / ${property.plug_number} soket mevcut </td>
      </tr>

    </table>
    </div>
    <div id="lokasyon${property.id}" style="display:none">
    <table  width='500px' class="table-hover" >
    <tr>
    <th>Şehir</th>
    <td>${property.city}</td>
  </tr>
    <tr>
      <th>Adres</th>
      <td>${property.address}</td>
    </tr>

    <tr>
      <th>Koordinatlar</th>
      <td>${property.position["lat"]},${property.position["lng"]}</td>
    </tr>
    <tr>
      <th>Lokasyon Tipi</th>
      <td>${property.indoor}</td>
    </tr>

  </table>
  </div>
    <div id="hizmetler${property.id}" style="display:none">
    <table  width='500px' class="table-hover" >
    <tr>
    <th>Durum</th>
    <td>${property.aktiflik}</td>
  </tr>
    <tr>
      <th>Hizmet Günleri</th>
      <td style="width:350px">${property.hizmetsaati}</td>
    </tr>
    <tr>
    <th>Otopark Sayısı</th>
    <td>${property.otopark}</td>
  </tr>
    <tr>
      <th>Park Süresi</th>
      <td>${property.parksure} Dakika</td>
    </tr>


  </table>
    </div>
  </div>
   
</div>
      `;
    return content;
  }

  // getstations.jsden gelen verileri buraya yapıştır
  

  
  const properties = [
    
  
  ];
  
  initMap();

