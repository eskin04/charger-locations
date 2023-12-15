const dbConn=require("../db/mysqlconnect")
const getWeatherById=(req,res)=>{
    const id=req.params.id
    dbConn.query("CALL getWeatherById(?)",[id],(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

module.exports={getWeatherById}