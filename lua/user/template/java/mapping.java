    @PostMapping("/{{_variable_}}.do")
    public ResultDto {{_variable_}}(){
        ResultDto result = new ResultDto();
        {{_cursor_}}
        return result;
    }
