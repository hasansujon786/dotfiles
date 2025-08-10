;; extends
((pair (_) @_pair.inner) @_start . ","? @_end
  (#make-range! "_pair.outer" @_start @_end))
