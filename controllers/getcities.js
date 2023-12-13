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

module.exports={getCities}