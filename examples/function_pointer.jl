# example of passing a pointer to a julia method to Cxx

using Cxx
__current_compiler__ = Cxx.new_clang_instance()

cxx"""
void evaluate(void (*f)() ){
    f();
}
"""

function evaluate(f)
    # void pointer on f
    f_void_ptr = cfunction(f, Void, ())

    # cast the void pointer into a function pointer
    icxx"""
    typedef void (*fptr)();
    fptr f_fun_ptr = reinterpret_cast<fptr>(reinterpret_cast<long>($f_void_ptr));
    """

    # finally we can do the desired call
    @cxx evaluate(f_fun_ptr);

end

f() = println("hi")
evaluate(f)

g() = println("ho")
evaluate(g)
