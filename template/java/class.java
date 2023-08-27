/**
 * author: {{_author_}}
 * created: {{_lua:os.date('%y.%m.%d %H:%M')_}}
 */

package {{_lua:vim.fn.expand("%:p"):sub(vim.fn.expand('%:p'):find('/src/main/java/'), -1):gsub('/src/main/java/', ''):gsub('/' .. vim.fn.expand('%:t'), ''):gsub('/', '.')_}};

public class {{_file_name_}} {

{{_cursor_}}

}
