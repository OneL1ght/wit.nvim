local M = {}

local config = require("wit.config")
local utils = require("wit.utils")

--- @type table<SearchEngine, string>
M.search_engines = {
	google = "https://www.google.com/search?q=",
	bing = "https://www.bing.com/search?q=",
	duckduckgo = "https://duckduckgo.com/?q=",
	ecosia = "https://www.ecosia.org/search?q=",
	brave = "https://search.brave.com/search?q=",
	perplexity = "https://www.perplexity.ai/search?q=",
}

--- Performs a web search using the configured search engine
--- @param query string The search query to be executed
function M.search(query)
	query = utils.normalize_for_url(query)
	local url = (M.search_engines[config.values.engine] or config.values.engine) .. query
	local open
	if config.values.open:len() > 0 then
		open = config.values.open
	else
		open = M.os_default_open()
	end

	vim.notify("open cmd: " .. open, vim.log.levels.INFO) -- TODO: delete this
	os.execute(open .. '"' .. url .. '"')
end

--- Returns default open command for current OS
function M.os_default_open()
	local is_windows = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1
	local is_macos = vim.fn.has("mac") == 1
	local is_linux = not is_windows and not is_macos

	if is_windows then
		return 'powershell -NoLogo -NoProfile -NonInteractive -Command Start-Process '
	elseif is_macos then
		return 'open '
	elseif is_linux then
		return 'xdg-open '
	else
		vim.notify("Unsupported operating system", vim.log.levels.ERROR)
	end
end

return M
