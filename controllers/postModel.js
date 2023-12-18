const dbConn=require("../db/mysqlconnect")

const postModel=(req,res)=>{
    dbConn.query("insert into model (model_kodu,model_adi,model_aciklama,soket_id) values (?,?,?,?)",[req.body.model_kodu,req.body.model_adi,req.body.model_aciklama,5],(err,rows)=>{
        if(!err){
            res.redirect('/model')
        }else{
            console.log(err)
        }
    })
}

module.exports={postModel}