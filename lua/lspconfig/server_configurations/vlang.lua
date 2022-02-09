local status_ok, util = pcall(require, 'lspconfig.util')

return {
  default_config = {
    cmd = { 'vls' },
    filetypes = { 'vlang' },
    root_dir = function(fname)
      return util.root_pattern('v.mod', '.git')(fname)
    end,
  }
}
