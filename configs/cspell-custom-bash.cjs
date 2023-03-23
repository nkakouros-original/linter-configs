function listBashBuiltinsAndCommands() {
  const execSync = require('child_process').execSync;
  const output = execSync("bash -c 'compgen -A builtin -A command'", { encoding: 'utf-8' });
  
  words = output.split('\n')
  return { words }
}

module.exports = {
  words: listBashBuiltinsAndCommands().words,
};
