
/**
 * author: {{_author_}}
 * created: {{_lua:os.date('%y.%m.%d %H:%M')_}}
 */

package {{_lua:vim.fn.expand("%:p"):sub(vim.fn.expand('%:p'):find('/src/.*/java/'), -1):gsub('/src/.*/java/', ''):gsub('/' .. vim.fn.expand('%:t'), ''):gsub('/', '.')_}};

import com.fasterxml.jackson.annotation.JsonValue;

public enum {{_file_name_}} {

    private final {{_variable_}} value;

    {{_file_name_}}({{_variable_}} value){
        this.value = value;
    }

    @JsonValue
    public {{_variable_}} getValue(){
        return value;
    }
}
