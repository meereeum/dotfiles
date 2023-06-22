// Configure CodeMirror Keymap

require([
  'nbextensions/vim_binding/vim_binding',   // depends your installation
], function() {
  // Map jk to <Esc>
  CodeMirror.Vim.map("jk", "<Esc>", "insert");
  CodeMirror.Vim.map("kj", "<Esc>", "insert");
});


var rto = 360; // default is 30s
console.log('NB: increase require timeout to ' + rto + ' seconds');
window.requirejs.config({waitSeconds:rto});
