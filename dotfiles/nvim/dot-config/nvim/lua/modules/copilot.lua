require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  server = {
    type = "binary",
    custom_server_filepath = os.getenv("COPILOT_LS"),
  },
})
require('copilot_cmp').setup()
