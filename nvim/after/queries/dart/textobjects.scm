(
  (identifier) @_start
  (selector (argument_part (arguments))) @_end
  (#make-range! "call.outer" @_start @_end)
)
(
  (const_object_expression) @_start @_end
  (#make-range! "call.outer" @_start @_end)
)
(
  (identifier)
  (selector (argument_part (arguments))) @_start @_end
  (#make-range! "call.inner" @_start @_end)
)
