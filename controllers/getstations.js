const dbConn=require("../db/mysqlconnect")
const stations=(req,res)=>{
    dbConn.query("CALL getStations()",(err,rows)=>{
        if(!err){
            res.json(rows)
        }else{
            console.log(err)
        }
    })
}

const stationsByCity=(req,res)=>{
    const city=req.query.city
    dbConn.query("CALL getstationsByName(?)",[city],(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

const getTotalStation=(req,res)=>{
    dbConn.query("CALL getTotalStations()",(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

module.exports={stations,stationsByCity,getTotalStation}