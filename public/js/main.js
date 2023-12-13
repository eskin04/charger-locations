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


    // Progress Bar
    $('.pg-bar').waypoint(function () {
        $('.progress .progress-bar').each(function () {
            $(this).css("width", $(this).attr("aria-valuenow") + '%');
        });
    }, {offset: '80%'});


    // Calender
    $('#calender').datetimepicker({
        inline: true,
        format: 'L'
    });


    // Testimonials carousel
    $(".testimonial-carousel").owlCarousel({
        autoplay: true,
        smartSpeed: 1000,
        items: 1,
        dots: true,
        loop: true,
        nav : false
    });


    // Chart Global Color
    Chart.defaults.color = "#6C7293";
    Chart.defaults.borderColor = "#000000";
    google.charts.load('current', {'packages':['corechart', 'bar']});


    // Worldwide Sales Chart
    google.charts.setOnLoadCallback(istasyonpie);
    google.charts.setOnLoadCallback(nufuspie);

    function istasyonpie() {

      var data = google.visualization.arrayToDataTable([
        ['Task', 'Hours per Day'],
        ['Work',     11],
        ['Eat',      2],
        ['Commute',  2],
        ['Watch TV', 2],
        ['Sleep',    7],
        
      ]);

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
        'legend': {
            'textStyle': {
                'color': '#6C7293',
                'fontSize': 12,
                
            },
            'position': 'bottom',

        },
      };

      var chart = new google.visualization.PieChart(document.getElementById('istasyonpie'));

      chart.draw(data, options);
    }

    function nufuspie() {

        var data = google.visualization.arrayToDataTable([
          ['Task', 'Hours per Day'],
          ['Work',     11],
          ['Eat',      2],
          ['Commute',  2],
          ['Watch TV', 2],
          ['Sleep',    7],
          
        ]);
  
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
          'legend': {
              'textStyle': {
                  'color': '#6C7293',
                  'fontSize': 12,
                  
              },
              'position': 'bottom',
  
          },
        };
  
        var chart = new google.visualization.PieChart(document.getElementById('nufuspie'));
  
        chart.draw(data, options);
      }


    // Salse & Revenue Chart
    google.charts.setOnLoadCallback(drawBasic);

    function drawBasic() {

      var data = new google.visualization.DataTable();
      data.addColumn('timeofday', 'Time of Day');
      data.addColumn('number', 'Motivation Level');

      data.addRows([
        [{v: [8, 0, 0], f: '8 am'}, 1],
        [{v: [9, 0, 0], f: '9 am'}, 2],
        [{v: [10, 0, 0], f:'10 am'}, 3],
        [{v: [11, 0, 0], f: '11 am'}, 4],
        [{v: [12, 0, 0], f: '12 pm'}, 5],
        [{v: [13, 0, 0], f: '1 pm'}, 6],
        [{v: [14, 0, 0], f: '2 pm'}, 7],
        [{v: [15, 0, 0], f: '3 pm'}, 8],
        [{v: [16, 0, 0], f: '4 pm'}, 9],
        [{v: [17, 0, 0], f: '5 pm'}, 10],
      ]);

      var options = {
        'backgroundColor': 'transparent',
        'colors': ['#C81313'],
        'legend': {
            'textStyle': {
                'color': '#6C7293',
                'fontSize': 14,
                
            },
            'position': 'bottom',

        },
        
        hAxis: {
          title: 'Time of Day',
          format: 'h:mm a',
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

        },
        vAxis: {
          title: 'Rating (scale of 1-10)',
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


var $body = document.body,
$wrap = document.getElementById('wrap'),

areawidth = window.innerWidth,
areaheight = window.innerHeight,

canvassize = 500,

length = 30,
radius = 5.6,

rotatevalue = 0.035,
acceleration = 0,
animatestep = 0,
toend = false,

pi2 = Math.PI*2,

group = new THREE.Group(),
mesh, ringcover, ring,

camera, scene, renderer;


camera = new THREE.PerspectiveCamera(65, 1, 1, 10000);
camera.position.z = 150;

scene = new THREE.Scene();
// scene.add(new THREE.AxisHelper(30));
scene.add(group);

mesh = new THREE.Mesh(
new THREE.TubeGeometry(new (THREE.Curve.create(function() {},
  function(percent) {

    var x = length*Math.sin(pi2*percent),
      y = radius*Math.cos(pi2*3*percent),
      z, t;

    t = percent%0.25/0.25;
    t = percent%0.25-(2*(1-t)*t* -0.0185 +t*t*0.25);
    if (Math.floor(percent/0.25) == 0 || Math.floor(percent/0.25) == 2) {
      t *= -1;
    }
    z = radius*Math.sin(pi2*2* (percent-t));

    return new THREE.Vector3(x, y, z);

  }
))(), 200, 1.1, 2, true),
new THREE.MeshBasicMaterial({
  color: 0xffffff
  // , wireframe: true
})
);
group.add(mesh);

ringcover = new THREE.Mesh(new THREE.PlaneGeometry(50, 15, 1), new THREE.MeshBasicMaterial({color: 0xd1684e, opacity: 0, transparent: true}));
ringcover.position.x = length+1;
ringcover.rotation.y = Math.PI/2;
group.add(ringcover);

ring = new THREE.Mesh(new THREE.RingGeometry(4.3, 5.55, 32), new THREE.MeshBasicMaterial({color: 0xffffff, opacity: 0, transparent: true}));
ring.position.x = length+1.1;
ring.rotation.y = Math.PI/2;
group.add(ring);

// fake shadow
(function() {
var plain, i;
for (i = 0; i < 10; i++) {
  plain = new THREE.Mesh(new THREE.PlaneGeometry(length*2+1, radius*3, 1), new THREE.MeshBasicMaterial({color: 0xd1684e, transparent: true, opacity: 0.13}));
  plain.position.z = -2.5+i*0.5;
  group.add(plain);
}
})();

renderer = new THREE.WebGLRenderer({
antialias: true
});
renderer.setPixelRatio(window.devicePixelRatio);
renderer.setSize(canvassize, canvassize);
renderer.setClearColor('#d1684e');

$wrap.appendChild(renderer.domElement);

$body.addEventListener('mousedown', start, false);
$body.addEventListener('touchstart', start, false);
$body.addEventListener('mouseup', back, false);
$body.addEventListener('touchend', back, false);

animate();


function start() {
toend = true;
}

function back() {
toend = false;
}

function tilt(percent) {
group.rotation.y = percent*0.5;
}

function render() {

var progress;

animatestep = Math.max(0, Math.min(240, toend ? animatestep+1 : animatestep-4));
acceleration = easing(animatestep, 0, 1, 240);

if (acceleration > 0.35) {
  progress = (acceleration-0.35)/0.65;
  group.rotation.y = -Math.PI/2 *progress;
  group.position.z = 50*progress;
  progress = Math.max(0, (acceleration-0.97)/0.03);
  mesh.material.opacity = 1-progress;
  ringcover.material.opacity = ring.material.opacity = progress;
  ring.scale.x = ring.scale.y = 0.9 + 0.1*progress;
}

renderer.render(scene, camera);

}

function animate() {
mesh.rotation.x += rotatevalue + acceleration;
render();
requestAnimationFrame(animate);
}

function easing(t,b,c,d) {if((t/=d/2)<1)return c/2*t*t+b;return c/2*((t-=2)*t*t+2)+b;}
   
    
})(jQuery);

