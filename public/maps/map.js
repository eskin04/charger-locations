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

  function toggleHighlight(markerView, property) {
    
    if (lastHighlightedMarker) {
        lastHighlightedMarker.content.classList.remove("highlight");
        lastHighlightedMarker.zIndex = null;
      }

      // Tıklanan marker'ı vurgula
      markerView.content.classList.add("highlight");
      markerView.zIndex = 1;

      // Tıklanan marker'ı önceki vurgulanmış marker olarak kaydet
      lastHighlightedMarker = markerView;
    
  

  }

  function closeHighlight() {
    lastHighlightedMarker.content.classList.remove("highlight");
    lastHighlightedMarker.zIndex = null;
  }
  function toggleTable(tableNumber) {
    for (var i = 1; i <= 3; i++) {
      var tableId = 'table' + i;
      var table = document.getElementById(tableId);
      if (i === tableNumber) {
        table.style.display = (table.style.display === 'none' || table.style.display === '') ? 'block' : 'none';
      } else {
        table.style.display = 'none';
      }
    }
  }
  
  function buildContent(property) {
    const content = document.createElement("div");
  
    content.classList.add("property");
    content.innerHTML = `
    <div class="icon">
    <i aria-hidden="true" class="fa-solid fa-${property.type}" title="${property.type}"></i>
</div>
<div class="details">
  <div class="btn-container">
  <button onclick = toggleTable(1)>İstasyon</button>
  <button onclick = toggleTable(2)>Lokasyon</button>
  <button onclick = toggleTable(3)>Hizmetler</button>
    
    <i onclick = closeHighlight() style="position:absolute;
    right: 10px; top: 10px;" class="fa-solid fa-circle-xmark fa-2xl"></i>


  </div>
  <div class="descs">
    <div id="table1">
    <table  width='500px' class="table-hover" >
      <tr>
        <th>istasyon kodu</th>
        <td>${property.code}</td>
      </tr>
      <tr>
        <th>şehir</th>
        <td>${property.city}</td>
      </tr>
      <tr>
        <th>model adı</th>
        <td>${property.model_name}</td>
      </tr>
      <tr>
        <th>model açıklaması</th>
        <td>${property.model_desc}</td>
      </tr>
      <tr>
        <th>soket tipi</th>
        <td>${property.plug_type} ${property.plug_number}</td>
      </tr>
      <tr>
        <th>Aktiflik</th>
        <td>${property.aktiflik}</td>
      </tr>
    </table>
    </div>
    <div id="table2" style="display:none">
    <table  width='500px' class="table-hover" >
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
    <div id="table3" style="display:none">
    <table  width='500px' class="table-hover" >
    <tr>
      <th>Hizmet Saatleri</th>
      <td>${property.hizmetsaati}</td>
    </tr>
    <tr>
    <th>Otopark</th>
    <td>${property.otopark}</td>
  </tr>
    <tr>
      <th>Park Süresi</th>
      <td>${property.parksure}</td>
    </tr>


  </table>
    </div>
  </div>
   
</div>
      `;
    return content;
  }
  
  const properties = [
    {
      code: "TR-ADA-002",
      city: "Adana",
      model_code: "ABBTER184SS",
      model_name: "ABB Terra 184",
      model_desc: "ABB Terra 184",
      plug_type: "CCS",
      plug_number: 2,
      indoor: "No",
      hizmetsaati: "pazartesi-cuma 08:00-18:00",
      otopark: 20,
      parksure: 2000,
      aktiflik: "Active",
      address: "Yıldırım Beyazıt Mah. Kozan Cad. No:755/A, Sarıçam/Adana",
      type: "charging-station",

      position: {
        lat: 39.9223937,
        lng: 32.857965,
      },
    },

    {
      address: "Yıldırım Beyazıt Mah. Kozan Cad. No:755/A, Sarıçam/Adana",
      code: "TR-ADA-004",
      hizmetsaati: "pazartesi-cuma 08:00-18:00",
      type: "car",
      otopark: 20,
      parksure: 2000,
      aktiflik: "Active",
      position: {
        lat: 37.50024109655184,
        lng: -122.38528451834352,
      },
    },


  
  ];
  
  initMap();