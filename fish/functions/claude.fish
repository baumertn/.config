function claude_caveman --description "Run Claude with bash in caveman mode"
    env SHELL=/bin/bash claude "/caveman" $argv
end

function claude_bash --description "Run Claude with bash"
    env SHELL=/bin/bash claude $argv
end
