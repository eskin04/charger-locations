const router=require('express').Router()
const {stations,stationsByCity,getTotalStation}=require('../controllers/getstations')
const {getCities,getCitiesByName,getTotalPopulation,highPopCities,HighStationCities,getCitiesById}=require('../controllers/getcities')
const {models,LowModelStations}=require('../controllers/getmodels')
const {getWeatherById}=require('../controllers/getWeather')
const {postModel}=require('../controllers/postModel')
router.get('/stations',stations)
router.get('/cities',getCities)
router.get('/models',models)
router.post('/stations',stationsByCity)
router.post('/cities',getCitiesByName)
router.get('/totalpop',getTotalPopulation)
router.get('/highpop',highPopCities)
router.get('/highstation',HighStationCities)
router.get('/totalstation',getTotalStation)
router.get('/lowmodel',LowModelStations)
router.get('/cities/:id',getCitiesById)
router.get('/weather/:id',getWeatherById)
router.post('/model',postModel)
module.exports=router