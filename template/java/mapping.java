    @PostMapping("/{{_variable_}}.do")
    public ResultVO {{_variable_}}(){
        ResultVO resultVO = new ResultVO();

        {{_cursor_}}
        return resultVO;
    }
