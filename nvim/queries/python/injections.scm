; # language=sql
; sql = "select * from users"
(
(comment) @comment
.
(expression_statement
  (assignment
  	(string
      (string_content) @injection.content
     )
  )
)

(#eq? @comment "# language=sql")
(#set! injection.language "sql")
)


; # language=json
; sql = """
; {
;   "test": "ok"
; }
; """
(
(comment) @comment
.
(expression_statement
  (assignment
  	(string
      (string_content) @injection.content
     )
  )
)

(#eq? @comment "# language=json")
(#set! injection.language "json")
)
