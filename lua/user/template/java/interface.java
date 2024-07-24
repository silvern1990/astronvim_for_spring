/**
 * author: {{_author_}}
 * created: {{_lua:os.date('%y.%m.%d %H:%M')_}}
 */

package {{_lua:vim.fn.expand("%:p"):sub(vim.fn.expand('%:p'):find('/src/.*/java/'), -1):gsub('/src/.*/java/', ''):gsub('/' .. vim.fn.expand('%:t'), ''):gsub('/', '.')_}};

public interface {{_file_name_}} {
}
