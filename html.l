# модуль для преобразования разметки на lisp в html

# +добавить таблицы
# +добавить перечисления без номеров

(setq html-tags
   '(.head .body .br .p .strong .ul .li .h1 .h2 .table .tr .td))

(de flatten (l)
   # избавиться от вложенности
   (mapcan '((x) x) l)
 )

(de all-args @
   # возвращает все переданные аргументы в виде списка
   (let (res '())
      (while (args)
         (setq res (cons (next) res)))
      (reverse res))
   )

(de concat @
   # объединяет все элементы в один список
   (apply conc (mapcar '((x) (if (lst? x) x (list x))) (pass all-args)))
 )

(de tag? (x)
   (and (pair x) 
      (= (car x) 'tag) )
 )

(de ntag? (x)
   (not (tag? x))
 )

(de ..attrs @
   (cons
      'attrs (pass all-args))
 )

(de attrs? (x)
   # проверяет является ли аргумент ассоциативным массивом/аттрибутами
   (and (pair x)
      (= (car x) 'attrs))           # помеченные аттрибутами
 )

(de nattrs? (x)
   (not (attrs? x))
 )

(de tag-attrs (tags)
   (if (not (attrs? tags))
      (quit "Only attrs params supported"))

   (let (a (cadr tags))
      (glue " " 
         (mapcar '((p) (list (sym (car p)) "=\"" (car (cdr p)) "\"")) a) ))
 )

(de tag-start (tag attrs)
   (if attrs
      (pack "<" tag " " (tag-attrs attrs) ">")
      (pack "<" tag ">"))
 )

(de tag-end (tag)
   (pack "</" tag ">")
 )

(de tag-name (tag-sym)
   # возращает имя тэга как строки
   (let (name (chop (sym tag-sym)))
      (pack (nth name 2))
      )
   )

(de str-replace (s-chopped,what,to)
   # функция замены подстрок
   # ожидает что строка s уже порублена (chop)
   
   (let (to-chopped (chop to)
         what-chopped (chop what)
         pattern (append (cons '@A what-chopped) '(@Z))
         Str s-chopped )
      (use (@A @Z)                        
         (while (match pattern Str)
            (setq Str '())
            (setq Str (append Str @A))
            (setq Str (append Str to-chopped))
            (setq Str (append Str @Z)))
         )
      Str )
 )

(de str-hex (s)
   # преобразует пробелы в код с процентами
   (pack (str-replace (chop s) " " "%20"))
 )

(de ->> f
   # a macro similar to threading macro in Clojure
   (let (val (eval (car f))
         cf (cdr f))
      (loop
         (T (not cf) val) 
         (setq val (apply (caar cf) (cons val (cdar cf))))
         (setq cf (cdr cf))
         )
      val
      )
 )

#(-> 1
#   (+ 2 3)
#   (* 10)
#   (pack "sdf"))

(de tag-str-sanitize (s)
   # изменение служебных символов на символы html
   # полный список, похоже, здесь - http://www.htmlhelp.com/reference/html40/entities/special.html
   (let (sl (chop s))
      (pack (->> sl
               (str-replace "&" "&amp;")
               (str-replace "<" "&lt;")
               (str-replace ">" "&gt;") 
               (str-replace "^J" "<br>") ) )
      ) )

(de tag-sanitize (subtags)
   # подготовка тэгов для публикации в html

  (let 
     (subtags-list (if (pair subtags)
                       subtags 
                       (list subtags))  # преобразуем в список, если subtags - просто строка
      
       sanitized (mapcar '((tag) 
                           (if (str? tag) 
                              (tag-str-sanitize tag)
                              tag
                              ) )
                    subtags-list )
       result (if (pair subtags)        # если на вход была подана просто строка, то возращаем тоже строку
                 sanitized
                 (car sanitized) ) )
     result ) 
 )


(de tag-long (tag-sym, attrs, subtags)
   (let (name (tag-name tag-sym))
      (list 'tag                         # помечаем как тэг
         (tag-start name attrs)
         (if (tag? subtags)
            subtags
            (tag-sanitize subtags))
         (tag-end name) ) 
   ))

(de tag-func-local (@tag-sym)
   (curry (@tag-sym)
      @ (let (args1 (pass all-args)
              attrs (car (filter attrs? args1))
              subtags (filter nattrs? args1))
           #(pretty attrs)
           (tag-long '@tag-sym attrs subtags) ) ) 
 )

(de tag-short (tag-sym attrs)
   (list 'tag  # помечаем как тэг
      (pack "<" (tag-name tag-sym) 
               (and attrs (pack " " (tag-attrs attrs))) "/>" ) ) 
 )

(de ..list @
   # функция для удобного создания маркированного списка
   (tag-long '.ul NIL 
      (mapcar '((tag) (tag-long '.li NIL tag)) (pass all-args))
      )
 )

(de ..table-row (row)
   # функция для создания строки значений таблицы
   (tag-long '.tr NIL 
      (mapcar '((cell) (tag-long '.td NIL cell)) row))
 )

(de ..table (rows, options)
   # функция для удобного создания таблиц
   # options - аттрибуты таблицы (ассоциативный список)
   
   (tag-long '.table NIL 
      (mapcar '((row) (..table-row row)) rows)
      )
 )

(de tag-locals-create ()
   (list 'let
      (flatten          
         (mapcar '((tag) (list tag (list 'tag-func-local (cons 'quote tag)))) html-tags) 
         ))
 )

(de tag-funcs-export ()
   # создает все функции разметки 
   (eval
      (cons 'prog
         (mapcar '((tag) (list 'setq tag (list 'tag-func-local (cons 'quote tag)))) html-tags) ) )
 )
(tag-funcs-export)

# все функции-тэги написанные вручную должны описаны после tag-funcs-export

(de html-postprocess (tags)
   (mapcar '((tag) 
             (cond
                ((tag? tag) (html-postprocess (cdr tag)))
                ((pair tag) (html-postprocess tag))
                (T tag) )
             ) tags)
   )

(de .html @
   # функция "сборки" html
   # рекурсивно проходится по всем спискам и выдает одну строку на выходе
   
   (let (subtags (pass all-args))
      (pack 
         (html-postprocess (list (tag-long '.html NIL subtags))) ) )
 )

(de .meta (attrs)
   (tag-short '.meta attrs)
 )

(de .img (url,alttext)
   (tag-short '.img (..attrs (list (list 'src url) (list 'alt alttext))))
   )

(de .a (url,anchor)
   (tag-long '.a (..attrs (list (list 'href url) (list 'rel "nofollow"))) anchor)
   )

(de ..mailto (email,subject)
   (.a (pack "mailto:" email (and subject (pack "?subject=" (str-hex subject)))) email)
 )

# использование специальной функции для преобразования
(de htmlify (t)
   (let (l (tag-locals-create) # создать локальным функции по именам тэгов
         l2 (append l (cons (cons 'list t))) # добавим текст как аргумент
         ) 
         (pack (eval l2))))             # выполним и сразу получим результат
