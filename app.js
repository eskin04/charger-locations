const express = require('express')
const router=require('./routers')
const path=require("path")
require('dotenv/config')
const app = express()
app.use(express.urlencoded());

//Static files
app.use(express.static(path.join(__dirname,"/public")))
app.get('/maps',(req,res)=>{
    res.sendFile(path.join(__dirname,"/public/maps/map.html"))
})
app.get('/city',(req,res)=>{
    res.sendFile(path.join(__dirname,"/public/city/il.html"))
})
app.get('/station',(req,res)=>{
    res.sendFile(path.join(__dirname,"/public/station/istasyon.html"))
})
app.get('/model',(req,res)=>{
    res.sendFile(path.join(__dirname,"/public/model/model.html"))
})
app.get('/city/:id',(req,res)=>{
    res.sendFile(path.join(__dirname,"/public/city/id/ilid.html"))
})





//Midllewares
app.use(express.json({limit:'50mb',extended:true,parameterLimit:50000}))
app.use('/api',router)
app.listen(process.env.PORT)