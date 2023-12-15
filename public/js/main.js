

(function ($) {
    "use strict";

    // Spinner
    var spinner = function () {
        setTimeout(function () {
            if ($('#spinner').length > 0) {
                $('#spinner').removeClass('show');
            }
        }, 1);
    };
    spinner();
    // Back to top button
    $(window).scroll(function () {
        if ($(this).scrollTop() > 300) {
            $('.back-to-top').fadeIn('slow');
        } else {
            $('.back-to-top').fadeOut('slow');
        }
    });
    $('.back-to-top').click(function () {
        $('html, body').animate({scrollTop: 0}, 150);
        return false;
    });


    // Sidebar Toggler
    $('.sidebar-toggler').click(function () {
        $('.sidebar, .content').toggleClass("open");
        return false;
    });







 



   
    
})(jQuery);

google.charts.load('current', {'packages':['corechart', 'bar']});


// Worldwide Sales Chart


function istasyonpie() {

  var data = google.visualization.arrayToDataTable(
    stationList
  );

  var options = {
    'backgroundColor': 'transparent',
    
    'textStyle': {
        'color': '#6C7293',
        'fontSize': 12,
        
    },
    'titleTextStyle': {
        'color': '#6C7293',
        'fontSize': 12,
    },
    legend: 'none',
    pieSliceText: 'label',
  };

  var chart = new google.visualization.PieChart(document.getElementById('istasyonpie'));

  chart.draw(data, options);
}

function nufuspie() {

    var data = google.visualization.arrayToDataTable(
      cityList
    );

    var options = {
      'backgroundColor': 'transparent',
      
      
      'textStyle': {
          'color': '#6C7293',
          'fontSize': 12,
          
      },
      'titleTextStyle': {
          'color': '#6C7293',
          'fontSize': 12,
      },
      legend: 'none',
      pieSliceText: 'label',
    };

    var chart = new google.visualization.PieChart(document.getElementById('nufuspie'));

    chart.draw(data, options);
  }


// Salse & Revenue Chart

function ModelChart() {

  var data = new google.visualization.DataTable();
  data.addColumn('string', 'Model Adı');
  data.addColumn('number', 'Model Sayısı');

  data.addRows(
    ModelList
 
  );

  var options = {
    'backgroundColor': 'transparent',
    'colors': ['#C81313'],
    'legend': {
        'textStyle': {
            'color': '#6C7293',
            'fontSize': 14,
            
        },
        'position': 'top',

    },
    
    hAxis: {
      title: 'Model Adı',
      viewWindow: {
        min: [7, 30, 0],
        max: [17, 30, 0]
      },
      gridlines: {
        color: 'none'

    },
    'textStyle': {
        'color': '#6C7293',
        'fontSize': 12,
        
    },
    'titleTextStyle': {
        'color': '#6C7293',
        'fontSize': 14,
    },

    },
    vAxis: {
      title: 'Model Sayısı (1-15 arası)',
      gridlines: {
        count: 0
      },
        'textStyle': {
            'color': '#6C7293',
            'fontSize': 12,
        },
        'titleTextStyle': {
            'color': '#6C7293',
            'fontSize': 14,
        },

      
    },
    
  };

  var chart = new google.visualization.ColumnChart(
    document.getElementById('chart_div'));

  chart.draw(data, options);
}

let highPops = 0
let totalpopulation = 0

let cityList = [['Şehir','Nüfus']]

fetch('http://localhost:3000/api/highpop')
.then(res => res.json())
.then(data => {
    console.log(data)
    data.forEach(city => {
        cityList.push([city.iller_ad,city.nufus_23])
        highPops += city.nufus_23
    })
    fetch('http://localhost:3000/api/totalpop')
    .then(res => res.json())
    .then(data => {
        totalpopulation = data[0].toplam
        cityList.push(['Diğer',totalpopulation-highPops])
        google.charts.setOnLoadCallback(nufuspie);
        // 3 basamakta bir virgül koy
        totalpopulation = totalpopulation.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
        document.getElementById('totalPopulation').innerHTML = totalpopulation


    })
    
    


})


let totalStation = 0
let highStation = 0
let stationList = [['Şehir','İstasyon Sayısı']]


fetch('http://localhost:3000/api/highstation')
.then(res => res.json())
.then(data => {
    console.log(data)
    data.forEach(city => {
        stationList.push([city.iller_ad,city.istasyon_sayisi])
        highStation += city.istasyon_sayisi
    })
    fetch('http://localhost:3000/api/totalstation')
    .then(res => res.json())
    .then(data => {
        totalStation = data[0].toplam
        stationList.push(['Diğer',totalStation-highStation])
        google.charts.setOnLoadCallback(istasyonpie);

        document.getElementById('totalStation').innerHTML = totalStation

    })
  })


  let ModelList = []

  fetch('http://localhost:3000/api/lowmodel')
  .then(res => res.json())
  .then(data => {
      console.log(data)
      data.forEach(model => {
          ModelList.push([model.model_kodu,model.sayi])
      })
      console.log(ModelList)
      google.charts.setOnLoadCallback(ModelChart);

  })




