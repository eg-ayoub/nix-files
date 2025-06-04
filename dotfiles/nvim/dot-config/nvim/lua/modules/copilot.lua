require('copilot').setup({
  suggestion = { enabled = false },
  panel = { enabled = false },
  server = {
    type = "binary",
    custom_server_filepath = os.getenv("COPILOT_LS"),
  },
})
require('CopilotChat').setup()
require('copilot_cmp').setup()
