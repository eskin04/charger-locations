const next = document.querySelector('#next')
const prev = document.querySelector('#prev')

function handleScrollNext (direction) {
    const cards = document.querySelector('.con-cards')
    cards.scrollLeft = cards.scrollLeft += window.innerWidth / 2 > 600 ? window.innerWidth / 2 : window.innerWidth - 100
}
function handleScrollPrev (direction) {
    const cards = document.querySelector('.con-cards')
    cards.scrollLeft = cards.scrollLeft -= window.innerWidth / 2 > 600 ? window.innerWidth / 2 : window.innerWidth - 100
}

const model_url = 'http://localhost:3000/api/models'

fetch(model_url)
    .then(res => res.json())
    .then(data => {
        let html = ''
        let i = 0
        let imgcount = 9
        data.forEach(model => {
            console.log(i%imgcount)
            html += `
            <div class="card">
                        <div class="plugtext">${model.soket_sayisi}</div>
                        <div class="sokettext">Soket</div>
                        <div class="con-img">
                            <img src="../modelpng/${i%imgcount}.png" alt="">
                            <img class="blur" src="../modelpng/${i%imgcount}.png" alt="">
                        </div>
                        <div class="con-text">
                            <div class="h-text">
                                ${model.model_kodu}
                            </div>
                            <div class="h-desc">
                                ${model.model_aciklama}
                            </div>
                            
                        </div>
                    </div>
            `
            i++
        })
        document.getElementById('modelCards').innerHTML = html
    })
    .catch(err => console.log(err))