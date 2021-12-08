const MIN_DICE_NUMBER = 1;

const rollDice = sides => Math.floor(
 Math.random() * (sides - MIN_DICE_NUMBER) + MIN_DICE_NUMBER
)

exports.rollDie = (sides, rolls, die) => {
  let result = new Map();

  for(let i = 0; i < rolls; i++){
    let sum = 0;
    for(let j = 0; j < die; j++){
      sum += rollDice(sides);
    }
    const currentSumVal = result.get(sum);
    result.set(sum, currentSumVal === undefined ? 1 : currentSumVal + 1);
  }

  return result;
}
