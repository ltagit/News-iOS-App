const express = require('express');
const router = express.Router();
const request = require('request');


    let url = "https://content.guardianapis.com/search?orderby=newest&show-fields=starRating,headline,thumbnail,short-url&api-key=RETRACTED";
    let options = {json: true};
    console.log("Accessing Guardian World: ");
    router.get('/', function(req, res, next) {
        request(url, options, (error, resa, body) => {
            if (error) {
                return  console.log(error)
            };
        
            if (!error && resa.statusCode == 200) {
                    res.json(body);

            };
        });
       
      });


module.exports = router;
