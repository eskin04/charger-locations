const express = require('express')
const router=require('./routers')
const path=require("path")
require('dotenv/config')
const app = express()

//Static files
app.use(express.static(path.join(__dirname,"/public")))
app.get('/maps',(req,res)=>{
    res.sendFile(path.join(__dirname,"/public/maps/map.html"))
})

//Midllewares
app.use(express.json({limit:'50mb',extended:true,parameterLimit:50000}))
app.use('/api',router)
app.listen(process.env.PORT)