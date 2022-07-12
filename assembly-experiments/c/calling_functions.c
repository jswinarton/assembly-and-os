void caller_function()
{
    callee_function(0xdede, 0xfafa, 0xbebe, 0xbebe, 0xbebe, 0xbebe, 0xbebe, 0xbebe);
}

int callee_function(int my_arg, int myarg2, int myarg3, int myarg4, int myarg5, int myarg6, int myarg7, int myarg8)
{
    return my_arg;
}
