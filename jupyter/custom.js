// configure CodeMirror keymap

require([
  'nbextensions/vim_binding/vim_binding',   // depends your installation
], function() {
  // Map jk to <Esc>
  CodeMirror.Vim.map("jk", "<Esc>", "insert");
  CodeMirror.Vim.map("kj", "<Esc>", "insert");
});

// leave more time for extensions to load
// via https://github.com/ipython-contrib/jupyter_contrib_nbextensions/issues/1195
var rto = 360; // default is 30s
window.requirejs.config({waitSeconds:rto});
