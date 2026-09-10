
function cw(){
    cat "$(which $1)"
}
compdef cw=which

