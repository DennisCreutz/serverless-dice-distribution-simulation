const { rollDie } = require('./service/dice-service');
const { batchWriteRollResults } = require('./service/dynamodb-service');

exports.handler = async (event, context) => {
  console.log(context);

  // Env parameters
  const tableName = process.env["DYNAMO_DB_NAME"];

  // Query parameters
  const die = event?.queryStringParameters?.die;
  const diceSides = event?.queryStringParameters?.dicesides;
  const rolls = event?.queryStringParameters?.rolls;

  const awsRequestId = context.awsRequestId;
  const result = {
    instanceID: awsRequestId,
    rolls
  };

  try {
    // Normally you should check for invalid inputs (e.g. '-1')
    if (typeof die === 'undefined' || typeof diceSides === 'undefined' || typeof rolls === 'undefined') {
      throw new Error('Not all query parameters are defined.')
    }

    console.log(`Starting to roll ${die} die with ${diceSides} sides a total of ${rolls} times.`)
    const rollResults = rollDie(diceSides, rolls, die);
    console.log(rollResults);

    // Write to database
    console.log(`Start to write roll results to ${tableName} table...`)
    const dbResults = await batchWriteRollResults(rollResults, rolls, die, diceSides, awsRequestId, tableName)

    // Stringify doesn't like maps
    result.rollResults = [...rollResults];
    return {
      statusCode: 200,
      body: JSON.stringify(result)
    }
  } catch (e) {
    console.error(e);
    return {
      statusCode: 500,
      body: JSON.stringify({ message: e.message })
    }
  }
}
