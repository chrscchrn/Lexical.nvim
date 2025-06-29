local M = {}

local job_id = nil
local lexical_stdout = nil

-- Check if 'lexical' command is available, and install if missing
function M.setup()
  if vim.fn.executable('lexical') == 1 then
    return
  end
  vim.notify("'lexical' not found. Attempting to install via pip from GitHub...", vim.log.levels.INFO)
  local cmd = {'pip', 'install', 'git+https://github.com/chrscchrn/lexical'}
  local result = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    vim.notify("Failed to install 'lexical' via pip. Please install manually: pip install git+https://github.com/chrscchrn/lexical\nError: " .. result, vim.log.levels.ERROR)
  else
    vim.notify("Successfully installed 'lexical'!", vim.log.levels.INFO)
  end
end

-- Start the lexical process if not already running
function M.start_lexical()
  if job_id and vim.fn.jobwait({job_id}, 0)[1] == -1 then
    return job_id
  end
  job_id = vim.fn.jobstart({"lexical", "--stdin"}, {
    on_stdout = function(_, data, _)
      if data then
        M.show_definitions(data)
      end
    end,
    on_stderr = function(_, data, _)
      if data then
        vim.notify("lexical stderr: " .. table.concat(data, "\n"), vim.log.levels.WARN)
      end
    end,
    stdout_buffered = true,
    stderr_buffered = true,
    rpc = false,
  })
  return job_id
end

-- Send a word to lexical
function M.send_word(word)
  M.start_lexical()
  if job_id then
    vim.fn.chansend(job_id, word .. "\n")
  else
    vim.notify("Failed to start lexical process", vim.log.levels.ERROR)
  end
end

-- Show definitions in a floating window
function M.show_definitions(data)
  if not data or #data == 0 then return end
  local lines = {}
  for _, line in ipairs(data) do
    if line ~= '' then table.insert(lines, line) end
  end
  if #lines == 0 then return end
  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  local width = 0
  for _, l in ipairs(lines) do width = math.max(width, #l) end
  local opts = {
    relative = 'cursor',
    row = 1,
    col = 0,
    width = math.min(width + 4, 80),
    height = math.min(#lines, 10),
    style = 'minimal',
    border = 'rounded',
  }
  vim.api.nvim_open_win(buf, false, opts)
end

-- Get word under cursor and send
function M.lookup_word_under_cursor()
  local word = vim.fn.expand('<cword>')
  if word and #word > 0 then
    M.send_word(word)
  else
    vim.notify("No word under cursor", vim.log.levels.INFO)
  end
end

return M

-- Call setup when plugin is loaded
M.setup()
