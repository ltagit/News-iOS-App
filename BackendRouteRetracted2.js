const express = require('express');
const router = express.Router();
const request = require('request');

/* GET users listing. */
//router.get('/', function(req, res, next) {

 
    let options = {json: true};

router.post('/', (req, resa) => {
    const tester = req.body.whichguardurl;
    let url = "https://content.guardianapis.com/"+tester+"?api-key=RETRACTED&show-blocks=all";
    console.log("Accessing Detailed Sheet of Guardian.  URl to expand is: ");
    console.log(tester);
    console.log("URL of details at: ");
    console.log(url);
    request(url, options, (error, resb, body) => {
        if (error) {
            return  console.log(error)
        };
    
        if (!error && resb.statusCode == 200) {
            console.log(body);
                resa.json(body);
        };
    });
    
  });
module.exports = router;
