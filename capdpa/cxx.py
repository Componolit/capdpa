
import clang.cindex
import IR

class InvalidNodeError: pass

TypeMap = {
        clang.cindex.TypeKind.BOOL      : "boolean",
        clang.cindex.TypeKind.UCHAR     : "unsigned_char",
        clang.cindex.TypeKind.USHORT    : "unsigned_short",
        clang.cindex.TypeKind.UINT      : "unsigned_int",
        clang.cindex.TypeKind.ULONG     : "unsigned_long",
        clang.cindex.TypeKind.SCHAR     : "signed_char",
        clang.cindex.TypeKind.WCHAR     : "wide_char",
        clang.cindex.TypeKind.SHORT     : "short",
        clang.cindex.TypeKind.INT       : "int",
        clang.cindex.TypeKind.LONG      : "long",
        clang.cindex.TypeKind.LONGLONG  : "long_long",
        clang.cindex.TypeKind.FLOAT     : "C_float",
        clang.cindex.TypeKind.DOUBLE    : "double",
        clang.cindex.TypeKind.LONGDOUBLE: "long_double"
        }

class CXX:

    def __init__(self, header):
        self.index = clang.cindex.Index.create()
        self.translation_unit = self.index.parse(header, ["-x", "c++"])

    def __print_layer(self, cursor):
        print(str(cursor.kind) + " (" + cursor.displayname + "): " + str([cursor.kind for cursor in cursor.get_children()]))

    def __print_tree(self, cursor, indent):
        print(" " * indent + (cursor.displayname or "UNNAMED") + " (" + str(cursor.kind) + ")")
        for c in cursor.get_children():
            self.__print_tree(c, indent + 2)

    def __convert_class(self, cursor):
        if cursor.kind != clang.cindex.CursorKind.CLASS_DECL:
            raise InvalidNodeError
        return IR.Class(
                name = cursor.displayname,
                children = self.__convert_children(cursor.get_children()))

    def __convert_function(self, cursor):
        return IR.Function(
                name = cursor.spelling,
                symbol = "",
                parameters = self.__convert_arguments(cursor.get_children()),
                return_type = self.__convert_type(cursor.result_type))

    def __convert_constructor(self, cursor):
        return IR.Constructor(
                symbol = "",
                parameters = self.__convert_arguments(cursor.get_children()))

    def __resolve_name(self, cursor):
        identifier = []
        while cursor.kind != clang.cindex.CursorKind.TRANSLATION_UNIT:
            identifier.append(cursor.spelling)
            cursor = cursor.semantic_parent
        return list(reversed(identifier))

    def __convert_type(self, type_cursor):
        ptr = 0;
        while type_cursor.kind == clang.cindex.TypeKind.POINTER:
            ptr += 1
            type_cursor = type_cursor.get_pointee()
        if type_cursor.kind ==  clang.cindex.TypeKind.UNEXPOSED:
            return IR.Type_Reference(name = IR.Identifier(self.__resolve_name(type_cursor.get_declaration())), pointer = ptr)
        elif type_cursor.kind ==  clang.cindex.TypeKind.VOID:
            return IR.Type_Reference(name = IR.Identifier(["void"]), pointer = ptr) if ptr else None
        elif type_cursor.kind ==  clang.cindex.TypeKind.TYPEDEF:
            return IR.Type_Reference(name = IR.Identifier([type_cursor.spelling]), pointer = ptr)
        elif type_cursor.kind in TypeMap.keys():
            return IR.Type_Reference(name = IR.Identifier([self.project, TypeMap[type_cursor.kind]]), pointer = ptr)
        else:
            raise NotImplementedError("Unsupported type: {} (from {})".format(str(type_cursor.kind), type_cursor.spelling))

    def __convert_arguments(self, cursors):
        argv = []
        argc = 1
        for cursor in cursors:
            if cursor.kind == clang.cindex.CursorKind.PARM_DECL:
                ptype = self.__convert_type(cursor.type)
                if cursor.displayname:
                    argv.append(IR.Variable(name = cursor.displayname, ctype = ptype))
                else:
                    argv.append(IR.Variable(name = "arg" + str(argc), ctype = ptype))
                argc += 1
        return argv

    def __convert_member(self, cursor):
        return IR.Variable(name = cursor.displayname, ctype = self.__convert_type(cursor.type))

    def __convert_constant(self, cursor):
        if cursor.kind != clang.cindex.CursorKind.ENUM_CONSTANT_DECL:
            raise InvalidNodeError
        return IR.Constant(
                name = cursor.displayname,
                value = cursor.enum_value)

    def __convert_enum(self, cursor):
        return IR.Enum(
                    name = cursor.displayname,
                    children = [self.__convert_constant(constant) for constant in cursor.get_children()])

    def __convert_namespace(self, cursor):
        if cursor.kind != clang.cindex.CursorKind.NAMESPACE:
            raise InvalidNodeError
        return IR.Namespace(
                name = cursor.displayname,
                children = self.__convert_children(cursor.get_children())
                )

    def __convert_typedef(self, cursor):
        children = list(cursor.get_children())
        if children:
            resolved = self.__convert_type(children[0].type)
        else:
            resolved = self.__convert_type(cursor.type.get_canonical())
        return IR.Type_Definition(cursor.type.spelling, resolved)

    def __convert_children(self, cursors):
        children = []
        public = True
        for cursor in cursors:
            if cursor.kind == clang.cindex.CursorKind.CXX_ACCESS_SPEC_DECL:
                public = list(cursor.get_tokens())[0].spelling == "public"
            elif public:
                if cursor.kind == clang.cindex.CursorKind.NAMESPACE:
                    children.append(self.__convert_namespace(cursor))
                elif cursor.kind == clang.cindex.CursorKind.CLASS_DECL:
                    children.append(self.__convert_class(cursor))
                elif cursor.kind == clang.cindex.CursorKind.ENUM_DECL:
                    if cursor.displayname:
                        children.append(self.__convert_enum(cursor))
                    else:
                        [children.append(self.__convert_constant(constant)) for constant in cursor.get_children()]
                elif cursor.kind == clang.cindex.CursorKind.TYPEDEF_DECL:
                    children.append(self.__convert_typedef(cursor))
                elif cursor.kind == clang.cindex.CursorKind.CXX_METHOD:
                    children.append(self.__convert_function(cursor))
                elif cursor.kind == clang.cindex.CursorKind.FIELD_DECL:
                    children.append(self.__convert_member(cursor))
                elif cursor.kind == clang.cindex.CursorKind.TYPEDEF_DECL:
                    children.append(self.__convert_typedef(cursor))
                elif cursor.kind == clang.cindex.CursorKind.CONSTRUCTOR:
                    children.append(self.__convert_constructor(cursor))
                else:
                    raise ValueError("Conversion of {} not implemented".format(cursor.kind))
        return children

    def ToIR(self, project):
#        self.__print_tree(self.translation_unit.cursor, 0)
        self.project = project
        if self.translation_unit.cursor.kind != clang.cindex.CursorKind.TRANSLATION_UNIT:
            raise InvalidNodeError
        return IR.Namespace(
                name=project,
                children = self.__convert_children(self.translation_unit.cursor.get_children())
                )
