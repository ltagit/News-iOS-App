const express = require('express');
const router = express.Router();
const request = require('request');

    let options = {json: true};

router.post('/', (req, resa) => {
    const tester = req.body.whichguardurl;
    let url = "https://content.guardianapis.com/search?q="+tester+"&api-key=RETRACTED&show-blocks=all";
    console.log("Accessing Search from Guardian.  Query is: ");
    console.log(tester);
    console.log("URL to be accessed is: ");
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
