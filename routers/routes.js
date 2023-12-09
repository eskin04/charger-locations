const router=require('express').Router()
const {stations}=require('../controllers/getstations')
router.get('/stations',stations)

module.exports=router