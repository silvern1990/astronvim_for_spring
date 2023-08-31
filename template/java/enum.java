
/**
 * author: {{_author_}}
 * created: {{_lua:os.date('%y.%m.%d %H:%M')_}}
 */

package {{_lua:vim.fn.expand("%:p"):sub(vim.fn.expand('%:p'):find('/src/main/java/'), -1):gsub('/src/main/java/', ''):gsub('/' .. vim.fn.expand('%:t'), ''):gsub('/', '.')_}};

import com.fasterxml.jackson.annotation.JsonValue;

public enum {{_file_name_}} {

    private final int value;

    {{_file_name_}}(int value){
        this.value = value;
    }

    @JsonValue
    public int getValue(){
        return value;
    }
}
