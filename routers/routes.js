const router=require('express').Router()
const {stations}=require('../controllers/getstations')
const {getCities}=require('../controllers/getcities')
router.get('/stations',stations)
router.get('/cities',getCities)
module.exports=router