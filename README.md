## Launching
make ./interpreter filename
where *filename* is a program written in Matcha Latte Lang.

## Matcha Latte [on oat milk] Lang
*Language like Latte, but different because made with tea instead of coffee and on plant based milk.*

**Important features:**
1.  Types: int, bool, string, void - like Latte
2.  Literals, arithmetics, comparisons - like Latte
3.  Variables, assigment operation - like Latte
4.  Printing: universal function print(var)
5.  while, if - the loop/instruction body is always enclosed in curly brackets, always when it's contained in one line
6.  Functions (can take and return any types present in the language), recursion - like Latte
7.  Passing paramenters by value and by reference
8. Variable shadowing with static binding (local and global variables)
9. Error handling: error message and return.

Interpreter uses a type 'type IM = ReaderT Env (ExceptT InterpreterException (StateT Store IO))'. Locally changing environment (Env) stores a mapping from variables' and functions' names to locations and Store a mapping from locations to values. Expressions are evaluated to a type IM Value where Value is a type representing values available in the language. Blocks, declarations and statements are evaluated to a type IM Env.

The language grammar can be found in src->Lang->matchalatte.cf file.
