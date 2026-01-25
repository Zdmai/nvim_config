-- 创建翻译模块
local M = {}

-- 原始翻译函数（稍作修改以接收字符串）
function M.translate_text(text)
	if not text or text == '' then
		vim.notify('请输入要翻译的文本', vim.log.levels.WARN)
		return
	end

	-- 清理 ANSI 序列
	local output = vim.fn.system('yd ' .. vim.fn.shellescape(text))
	output = output:gsub('\27%[[%d;]*[A-Za-z]', '')

	-- 居中窗口配置
	local lines = vim.split(vim.trim(output), '\n')

	-- 计算窗口大小
	local max_line = 0
	for _, line in ipairs(lines) do
		max_line = math.max(max_line, vim.fn.strdisplaywidth(line))
	end

	local width = math.min(max_line + 4, 120)
	local height = math.min(#lines + 2, 40)

	-- 居中计算
	local vim_width = vim.api.nvim_get_option("columns")
	local vim_height = vim.api.nvim_get_option("lines")

	local win_config = {
		relative = "editor",
		row = math.floor((vim_height - height) / 2) - 1,
		col = math.floor((vim_width - width) / 2),
		width = width,
		height = height,
		title = "翻译结果",
		border = "rounded",
		style = "minimal",
	}

	-- 创建窗口
	local buf = vim.api.nvim_create_buf(false, true)
	local win = vim.api.nvim_open_win(buf, true, win_config)

	-- 写入内容
	vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

	-- 设置选项
	vim.bo[buf].buftype = 'nofile'
	vim.bo[buf].modifiable = false
	vim.bo[buf].bufhidden = 'wipe'

	-- 快捷键
	vim.keymap.set('n', 'q', '<Cmd>close<CR>', { buffer = buf, desc = '关闭窗口' })
	vim.keymap.set('n', '<Esc>', '<Cmd>close<CR>', { buffer = buf })

	return { buf = buf, win = win }
end

-- Visual 模式翻译
function M.translate_visual()
	local selected_text = M.get_visual_selection()

	M.translate_text(selected_text)
end

-- 获取 Visual 选择
function M.get_visual_selection()
	local start_pos = vim.api.nvim_buf_get_mark(0, '<')
	local end_pos = vim.api.nvim_buf_get_mark(0, '>')

	if not start_pos or not end_pos then
		return ''
	end

	-- 获取文本
	local lines = vim.api.nvim_buf_get_text(0,
	start_pos[1] - 1, start_pos[2],
	end_pos[1] - 1, end_pos[2] + 1,
	{})

	return table.concat(lines, '\n')
end

-- Normal 模式命令（翻译当前单词）
function M.translate_current_word()
	local word = vim.fn.expand('<cword>')
	M.translate_text(word)
end

-- 设置键映射
function M.setup_keymaps()
	-- Visual 模式映射
	vim.keymap.set('v', '<leader>t', M.translate_visual, { desc = '翻译选中文本' })

	-- Normal 模式映射
	vim.keymap.set('n', '<leader>tw', M.translate_current_word, { desc = '翻译当前单词' })

	-- 命令模式
	vim.api.nvim_create_user_command('Translate', function(opts)
		if opts.args and opts.args ~= '' then
			-- 有参数：翻译参数
			M.translate_text(opts.args)
		elseif opts.range > 0 then
			-- 有范围：翻译选中行
			local lines = vim.api.nvim_buf_get_lines(0, 
			opts.line1 - 1, opts.line2, false)
			M.translate_text(table.concat(lines, '\n'))
		else
			-- 无参数：翻译当前单词
			M.translate_current_word()
		end
	end, {
	range = true,
	nargs = '*',
	desc = '翻译文本'
})
end

return M
