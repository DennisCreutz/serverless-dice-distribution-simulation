const AWS = require('aws-sdk');
AWS.config.update({ region: 'eu-central-1' });
const ddb = new AWS.DynamoDB({ apiVersion: '2012-08-10' });

exports.batchWriteRollResults = async (rollResultsMap, rolls, die, sides, instanceID, tableName) => {
  const putRequests = [{
    PutRequest: {
      Item: {
        'PK': { 'S': `${die}#${sides}` },
        'RollInstanceID': { 'S': `${instanceID}` },
        'Rolls': { 'N': `${rolls}` }
      }
    }
  }];

  rollResultsMap.forEach((value, key) => {
    putRequests.push({
      PutRequest: {
        Item: {
          'PK': { 'S': `${key}` },
          'RollInstanceID': { 'S': `${instanceID}` },
          'Count': { 'N': `${value}` },
          'Rolls': { 'N': `${rolls}` },
        }
      }
    })
  })

  // Batch write got a limit of 25 puts
  console.log(`Got ${putRequests.length} elements to write.`)
  const chunkedPutRequests = putRequests.reduce((resultArray, item, index) => {
    const chunkIndex = Math.floor(index / 25)

    if (!resultArray[chunkIndex]) {
      resultArray[chunkIndex] = [];
    }

    resultArray[chunkIndex].push(item)

    return resultArray
  }, []);
  console.log(`Executing ${chunkedPutRequests.length} batch write requests...`);

  const promises = [];
  chunkedPutRequests.forEach(chunk => {
    promises.push(ddb.batchWriteItem({
      RequestItems: {
        [tableName]: chunk
      }
    }).promise());
  });

  const dbResults = await Promise.all(promises);
  console.log('DB Result: %s', JSON.stringify(dbResults));
  return dbResults;
}
