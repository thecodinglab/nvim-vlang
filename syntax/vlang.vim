if exists('b:current_syntax')
  finish
endif

syn case match

" Modules
syn keyword     vModule             module
syn keyword     vImport             import

hi def link     vModule             Statement
hi def link     vImport             Statement

" Keywords within functions
syn keyword     vStatement          as break continue defer go goto is lock return rlock unsafe
syn keyword     vConditional        if else or match select
syn keyword     vRepeat             for in

hi def link     vStatement          Statement
hi def link     vConditional        Conditional
hi def link     vRepeat             Repeat

" Predefined types
syn keyword     vType               bool string rune map chan voidptr any
syn keyword     vSignedInts         i8 i16 int i64 i128 isize
syn keyword     vUnsignedInts       byte u16 u32 u64 u128 usize
syn keyword     vFloats             f32 f64

hi def link     vType               Type
hi def link     vSignedInts         Type
hi def link     vUnsignedInts       Type
hi def link     vFloats             Type

" Predefined functions and values
syn keyword     vBuiltins           assert sizeof typeof __offsetof
syn keyword     vBuiltins           print println eprint eprintln exit panic print_backtrace
syn keyword     vBuiltins           malloc memdup copy isnil
syn keyword     vBuiltins           panic recover
syn keyword     vConstants          none
syn keyword     vBoolean            true false

hi def link     vBuiltins           Function
hi def link     vConstants          Constant
hi def link     vBoolean            Boolean

" Generics
syn match       vGenericTypeName    /\w\+/ contained
syn region      vGenericDecl        start=/</ end=/>/ contained contains=vGenericTypeName nextgroup=vParamsDecl skipwhite skipnl

hi def link     vGenericTypeName    Type

" Type declarations
syn match       vSimpleTypeName     /\w\+/ contained
syn match       vTypeName           /\w\+/ contained nextgroup=vGenericDecl skipwhite skipnl
syn match       vReferenceOperator  /&/ contained nextgroup=vSimpleTypeName,vTypeName,vReferenceOperator
syn match       vOptionalOperator   /?/ contained nextgroup=vSimpleTypeName,vTypeName,vReferenceOperator

syn match       vTypeDecl           /\<type\|enum\>/ nextgroup=vSimpleTypeName skipwhite skipnl
syn match       vTypeDecl           /\<struct\|union\|interface\>/ nextgroup=vTypeName skipwhite skipnl
syn keyword     vAccessModifiers    const mut shared atomic pub __global

hi def link     vSimpleTypeName     Type
hi def link     vTypeName           Type
hi def link     vReferenceOperator  Operator
hi def link     vOptionalOperator   Operator
hi def link     vTypeDecl           Keyword
hi def link     vAccessModifiers    Keyword

" Variables
syn cluster     vVarType            contains=vSimpleTypeName,vTypeName,vReferenceOperator
syn keyword     vVarModifier        mut nextgroup=vVarName,@vVarType skipwhite skipnl
syn match       vVarName            /\w\+/ contained nextgroup=vVarModifier,@vVarType skipwhite skipnl
syn cluster     vVarDecl            contains=vVarName,vVarModifier

hi def link     vVarModifier        Keyword

" Functions
syn cluster     vReturnValue        contains=vOptionalOperator,vReturnGroup,@vVarType
syn region      vReturnGroup        start=/(/ end=/)/ contained contains=@vReturnValue skipwhite skipnl
syn region      vParamsDecl         start=/(/ end=/)/ contained contains=@vVarDecl nextgroup=@vReturnValue,vReturnGroup skipwhite skipnl
syn region      vReceiverDecl       start=/(/ end=/)/ contained contains=@vVarDecl nextgroup=vFuncName skipwhite skipnl

syn match       vFuncName           /\w\+/ display contained nextgroup=vGenericDecl,vParamsDecl skipwhite skipnl
syn cluster     vFuncHead           contains=vReceiverDecl,vFuncName,vParamsDecl
syn match       vFuncCall           /\w\+\ze\%(\s*<\w\+>\)\?\s*(/ contains=vBuiltins,vGenericDecl
syn match       vFuncDecl           /\<fn\>/ nextgroup=@vFuncHead skipwhite skipnl

hi def link     vReceiverModifier   Keyword
hi def link     vFuncName           Function
hi def link     vFuncCall           Function
hi def link     vFuncDecl           Keyword

" Operators
syn match       vVarArgs            /\.\.\./
syn match       vRange              /\.\./
syn match       vOptional           /?/
" match single-char operators:            -  +  *  /  %  ~  &  |  ^  !  <  >  =
" and corresponding two-char operators:   -= += *= /= %= ~= &= |= ^= != <= >= ==
syn match       vOperator           /[-+*\/~&|^!<>=]=\?/
" match multi-char operators:             <<  >>  >>>
" and corresponding three-char operators: <<= >>= >>>=
syn match       vOperator           /\%(<<\|>>\|>>>\)=\?/
" remaining operators:                    := && || <- ++ --
syn match       vOperator           /:=\|&&\|||\|<-\|++\|--/

hi def link     vVarArgs            Operator
hi def link     vRange              Operator
hi def link     vOptional           Operator
hi def link     vOperator           Operator

" Preprocessor
syn match       vMacro              /@\%(FN\|METHOD\|MOD\|STRUCT\|FILE\|LINE\|COLUMN\|VEXE\|VEXEROOT\|VHASH\|VMOD_FILE\|VMODROOT\)/
syn match       vPreConditional     /$\%(if\|else\)/
syn match       vPreProc            /#\%(include\|flag\)/
syn match       vPreProc            /$\%(embed_file\|tmpl\|env\)/

hi def link     vMacro              Macro
hi def link     vPreConditional     PreCondit
hi def link     vPreProc            PreProc

" Comments
syn keyword     vTodo               contained TODO FIXME XXX BUG
syn cluster     vCommentGroup       contains=vTodo

syn region      vComment            start='//' end='$' contains=@vCommentGroup,@Spell
syn region      vComment            start='/\*' end='\*/' contains=@vCommentGroup,@Spell,vComment

hi def link     vComment            Comment
hi def link     vTodo               Todo

" Escapes
syn match       vEscapeChar         display contained /\\[abfnrtv\\'"`]/
syn match       vEscapeOct          display contained /\\[0-7]\{1,3}/
syn match       vEscapeHex          display contained /\\x\x\{2}/
syn match       vEscapeUnicode      display contained /\\u\x\{4}/
syn match       vEscapeBigUnicode   display contained /\\U\x\{8}/
syn match       vEscapeError        display contained /\\[^0-7xuUabfnrtv\\'"`]/

hi def link     vEscapeChar         Special
hi def link     vEscapeOct          Special
hi def link     vEscapeHex          Special
hi def link     vEscapeUnicode      Special
hi def link     vEscapeBigUnicode   Special
hi def link     vEscapeError        Error

" Characters
syn cluster     vCharacterGroup     contains=vEscapeChar,vEscapeOct,vEscapeHex,vEscapeUnicode,vEscapeBigUnicode,vEscapeError
syn region      vCharacter          start=+`+ end=+`+ contains=@vCharacterGroup

hi def link     vCharacter          Character

" Strings
syn match       vStringVar          display contained /\$[0-9A-Za-z\._]*\([(][^)]*[)]\)\?/
syn match       vStringVar          display contained /\${[^}]*}/
syn cluster     vStringGroup        contains=@vCharacterGroup,vStringVar
syn region      vString             start=/"/ skip=/\\\\\|\\"/ end=/"/ contains=@vStringGroup,@Spell 
syn region      vString             start=/'/ skip=/\\\\\|\\'/ end=/'/ contains=@vStringGroup,@Spell 
syn region      vRawString          start=/r"/ end=/"/ contains=@Spell
syn region      vRawString          start=/r'/ end=/'/ contains=@Spell

hi def link     vStringVar          Special
hi def link     vString             String
hi def link     vRawString          String

" Regions
syn region      vParen              start=/(/ end=/)/ transparent
syn region      vBlock              start=/{/ end=/}/ transparent

" Integers
syn match       vDecInt             /\<-\=\(0\|[1-9]_\?\(\d\|\d\+_\?\d\+\)*\)\%([Ee][-+]\=\d\+\)\=\>/
syn match       vDecError           /\<-\=\(_\(\d\+_*\)\+\|\([1-9]\d*_*\)\+__\(\d\+_*\)\+\|\([1-9]\d*_*\)\+_\+\)\%([Ee][-+]\=\d\+\)\=\>/
syn match       vHexInt             /\<-\=0x_\?\(\x\+_\?\)\+\>/
syn match       vHexError           /\<-\=0x_\?\(\x\+_\?\)*\(\([^ \t0-9A-Fa-f_)]\|__\)\S*\|_\)\>/
syn match       vOctInt             /\<-\=0o\?_\?\(\o\+_\?\)\+\>/
syn match       vOctError           /\<-\=0[0-7oO_]*\(\([^ \t0-7oOxX_/)\]\}\:;]\|[oO]\{2,\}\|__\)\S*\|_\|[oOxX]\)\>/
syn match       vBinInt             /\<-\=0b_\?\([01]\+_\?\)\+\>/
syn match       vBinError           /\<-\=0b_\?[01_]*\([^ \t01_)]\S*\|__\S*\|_\)\>/

hi def link     vDecInt             Integer
hi def link     vDecError           Error
hi def link     vHexInt             Integer
hi def link     vHexError           Error
hi def link     vOctInt             Integer
hi def link     vOctError           Error
hi def link     vBinInt             Integer
hi def link     vBinError           Error
hi def link     Integer             Number

" Floating point
syn match       vFloat              /\<-\=\d\+\.\d*\%([Ee][-+]\=\d\+\)\=\>/
syn match       vFloat              /\<-\=\.\d\+\%([Ee][-+]\=\d\+\)\=\>/

hi def link     vFloat              Float

" Inline assembly
syn include     @vAsm               syntax/asm.vim
syn region      vAsmBlock           start=/{/ end=/}/ matchgroup=vAsmBlock contained contains=@vAsm

syn keyword     vAsmArchitecture    i386 amd64 arm64 contained nextgroup=vAsmBlock skipwhite skipnl
syn keyword     vAsmModifiers       volatile contained nextgroup=vAsmModifiers,vAsmArchitecture skipwhite skipnl
syn keyword     vAsmDecl            asm nextgroup=vAsmModifiers,vAsmArchitecture skipwhite skipnl

hi def link     vAsmModifiers       Statement
hi def link     vAsmDecl            Statement

" Attributes
syn keyword     vAttributes         contained deprecated unsafe_fn console heap debug manualfree typedef live inline flag ref_only windows_stdcall direct_array_access
syn keyword     vAttributes         contained required json skip
syn match       vAttribute          /\%(^\|\s\+\)\[[^\]]\+]\%(\s+\|$\)/ contains=vAttributes,vString
