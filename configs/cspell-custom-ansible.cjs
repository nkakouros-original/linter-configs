function listAnsibleNamespacesAndPlugins() {
  const exec = require('child_process').exec;

  const execSync = require('child_process').execSync;
  const output = execSync(
    "bash -c \"ansible-doc -l -j | jq -r 'keys | map(split(\\\".\\\")) | flatten | unique[]'\"",
    { encoding: 'utf-8' });
  
  words = output.split('\n')
  return { words }
}

module.exports = {
  words: listAnsibleNamespacesAndPlugins().words,
};
