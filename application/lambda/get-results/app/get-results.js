const { getTotalResults } = require('./service/dynamodb-service');

const setInstancesAndRolls = (totalResults, result) => {
  if (totalResults.Items && totalResults.Items.length > 0) {
    const uniqueInstances = totalResults.Items.filter((element, index, self) =>
      index === self.findIndex((t) => (
       t.RollInstanceID.S === element.RollInstanceID.S
      ))
    );

    let totalRolls = 0;
    uniqueInstances.forEach(instance => totalRolls += parseInt(instance.Rolls.N));

    result = {
      numberOfInstances: uniqueInstances.length,
      totalRolls,
    };
  }
  return result;
}

function setRelativeDistribution(totalResults, result) {
  let oldSum = -1;
  let relativeDistribution = {};
  totalResults.Items.forEach(element => {
    let thisSum = parseInt(element.Sum.N);
    let thisCount = parseInt(element.Count.N);

    if (thisSum !== oldSum) {
      if (oldSum !== -1) {
        relativeDistribution[oldSum] = relativeDistribution[oldSum] / (result.totalRolls / 100);
      }
      relativeDistribution[thisSum] = 0;
      oldSum = thisSum;
    }
    relativeDistribution[thisSum] += thisCount;
  });
  result.relativeDistribution = relativeDistribution;
  return result;
}

exports.handler = async (event, context) => {
  // Query parameters
  const die = event?.queryStringParameters?.die;
  const diceSides = event?.queryStringParameters?.dicesides;

  // Env parameters
  const tableName = process.env['DYNAMO_DB_NAME'];

  let result = {};
  try {
    if (typeof die === 'undefined' || typeof diceSides === 'undefined') {
      throw new Error('Not all query parameters are defined.')
    }

    const totalResults = await getTotalResults(die, diceSides, tableName);
    console.log(`Total results: ${JSON.stringify(totalResults)}`)

    result = setInstancesAndRolls(totalResults, result);
    result = setRelativeDistribution(totalResults, result);

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
