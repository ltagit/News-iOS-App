const express = require('express');
const router = express.Router();
const request = require('request');
const googleTrends = require('google-trends-api');

    let options = {json: true};
router.post('/', (req, resa) => {
    const tester = req.body.whichurl;
    var test1 = req.body.whichurl;
    console.log(tester);
    if (test1 == "")
    {
        test1 = "Coronavirus"
    }

    googleTrends.interestOverTime({keyword: test1, startTime:new Date('2019-06-01')})
    .then(function(results){
        resa.send(results);
    })
    .catch(function(err){
      console.error(err);
    });
    

    //  resa.json(results);

  });
module.exports = router;
