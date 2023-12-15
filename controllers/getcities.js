const dbConn=require("../db/mysqlconnect")
const getCities=(req,res)=>{
    dbConn.query("CALL getCities()",(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

const getCitiesByName=(req,res)=>{
    const city=req.query.city
    dbConn.query("CALL getCitiesByName(?)",[city],(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

const getTotalPopulation=(req,res)=>{
    dbConn.query("CALL getTotalPop()",(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

const highPopCities=(req,res)=>{
    dbConn.query("CALL HighPopCities()",(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

const HighStationCities=(req,res)=>{
    dbConn.query("CALL HighStationCities()",(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

const getCitiesById=(req,res)=>{
    const id=req.params.id
    dbConn.query("CALL getCitiesById(?)",[id],(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}





module.exports={getCities,getCitiesByName,getTotalPopulation,highPopCities,HighStationCities,getCitiesById}