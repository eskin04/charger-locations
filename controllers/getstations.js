const dbConn=require("../db/mysqlconnect")
const stations=(req,res)=>{
    dbConn.query("SELECT * FROM istasyonlar",(err,rows)=>{
        if(!err){
            res.json(rows)
        }else{
            console.log(err)
        }
    })
}

module.exports={stations}