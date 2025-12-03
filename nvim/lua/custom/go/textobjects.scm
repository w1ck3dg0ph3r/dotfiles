; inner function textobject
(function_declaration
  body: (block
    .
    "{"
    _+ @function.inner
    "}"))

; method as inner function textobject
(method_declaration
  body: (block
    .
    "{"
    _+ @function.inner
    "}"))

; outer function textobject
(function_declaration) @function.outer

; method as outer function textobject
(method_declaration
  body: (block)?) @function.outer

; any type declaration as class.outer
(type_declaration) @class.outer

; struct declaration as class.inner
(type_declaration
  (type_spec
    (type_identifier)
    (struct_type
      (field_declaration_list
        .
        "{"
        _+ @class.inner
        "}"
      )
    )
  )
)

; interface declaration as class.inner
(type_declaration
  (type_spec
    (type_identifier)
    (interface_type
      .
      "{"
      _+ @class.inner
      "}"
    )
  )
)

; simple type declaration as class.inner
(type_declaration
  (type_spec
    name: (type_identifier)
    type: (type_identifier) @class.inner
  )
)

; type alias declaration as class.inner
(type_declaration
  (type_alias
    name: (type_identifier)
    type: (type_identifier) @class.inner
  )
)

; parameters
(parameter_list
  "," @parameter.outer
  .
  (parameter_declaration) @parameter.inner @parameter.outer)

(parameter_list
  .
  (parameter_declaration) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)

(parameter_declaration
  name: (identifier)
  type: (_)) @parameter.inner

(parameter_list
  "," @parameter.outer
  .
  (variadic_parameter_declaration) @parameter.inner @parameter.outer)

; arguments
(argument_list
  "," @parameter.outer
  .
  (_) @parameter.inner @parameter.outer)

(argument_list
  .
  (_) @parameter.inner @parameter.outer
  .
  ","? @parameter.outer)
