local document = require("image/utils/document")

return document.create_document_integration({
  name = "gindiff",
  -- debug = true,
  default_options = {
    clear_in_insert_mode = false,
    download_remote_images = true,
    only_render_image_at_cursor = false,
    filetypes = { "gin-diff" },
  },
  query_buffer_images = function(buffer)
    local buf = buffer or vim.api.nvim_get_current_buf()
    local images = {}

    local function get_inline_images(i, line)
      local start_col, end_col = string.find(line, "img:")
      if start_col ~= nil then
        local path = string.sub(line, end_col + 1, -1)
        local image = {
          node = nil,
          range = { start_row = i, end_row = i + 1, start_col = 0, end_col = string.len(line) },
          url = path,
        }
        print(vim.inspect(image))
        table.insert(images, image)
      end
    end

    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, true)
    for i, line in ipairs(lines) do
      get_inline_images(i, line)
    end

    return images
  end,
})
