;; extends
(
  (comment) @_start
  (function_declaration) @_end
  (#make-range! "function_block" @_start @_end)
)

(pair) @pair.inner
((pair) @_start . ","? @_end
  (#make-range! "pair.outer" @_start @_end))

