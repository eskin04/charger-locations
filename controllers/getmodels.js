const dbConn=require("../db/mysqlconnect")
const models=(req,res)=>{
    dbConn.query("CALL getModels()",(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

const LowModelStations=(req,res)=>{
    dbConn.query("CALL LowModelStations()",(err,rows)=>{
        if(!err){
            res.json(rows[0])
        }else{
            console.log(err)
        }
    })
}

module.exports={models,LowModelStations}