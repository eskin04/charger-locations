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

module.exports={stations}