const AWS = require('aws-sdk');
AWS.config.update({ region: 'eu-central-1' });
const ddb = new AWS.DynamoDB({ apiVersion: '2012-08-10' });

exports.getTotalResults = (die, sides, tableName) => ddb.query({
  TableName: tableName,
  KeyConditionExpression: "#pk = :ds",
  ExpressionAttributeNames:{
    "#pk": "Die-Sides"
  },
  ExpressionAttributeValues: {
    ':ds': {
      S: `${die}#${sides}`
    }
  }
}).promise();
