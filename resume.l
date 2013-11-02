#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

# добавить таблицы
# добавить перечисления без номеров

# ====================Content==========================================================
(de experience (period, company, position)
   (list 
      ('.p (.strong "Период : ") period)
      ('.p (.strong "Место работы : ") company)
      ('.p (.strong "Должность : ") position))
 )

(de job-description (x)
   (list
      ('.p (.strong "Обязанности : ") x))
 )

(de projects @
  (list
     ('.p (.strong "Проекты : "))
     (pass ..list))
 )

(setq txt
   (quote
      (.html
         (.meta '((http-equiv "Content-Type")
                  (content "text/html; charset=utf-8" )))
         (.body
            
            (.h1 '((align center)) "Головань Денис Сергеевич")

            (.p "Домашний адрес: г. Киев ул. Олевская 5 кв. 201")
            (.p "мобильный телефон: 	+38 097 413-38-13")
            (.p "e-mail, Mail-Agent:	 denis_golovan@mail.ru")
            (.p "e-mail, googletalk:	 denisgolovan@gmail.com")
            (.p "ICQ: 	105051989")
            (.p "Дата рождения: 	10.10.1981")

            #(.br)
            (.p "Семейное положение: женат, детей нет.")

            (.br)
            (.h2 '((align center)) "Опыт работы")

            (experience 
               "(июль 2008 по настоящее время)"
               "SimCorp Ukraine LLC (г. Киев), отдел Performance Measurement" 
               "старший инженер программист" )

            (job-description
               "Разработка и поддержка функциональности в рамках системы управления инвестициями SimCorp Dimension.^JПлатформа - Dyalog APL v13.0, Oracle database v11g."
               )

            (projects
               "Multiple investment structures"
               "Spread-based indices implementation"
               "Market value weighted benchmarks implementation"
               "Multiple model portfolios tree type support for Performance Measurement module")

            (.br)
            (experience
               "(май 2007 по июль 2008)"
               "Фрилансер"
               "независимый разработчик")

            (projects
               (pack 
                  "Разработка приложения мобильного составления заказов для системы складского учета «Гермес-Торговля».^J"
                  "Платформа разработки - Linux, Lazarus, SQLite (кросс-компиляция для архитектуры ARM).^J"
                  "Платформа приложения - Windows Mobile 2005 (по заказу ЧП Горюнов)." )
               
               (pack 
                  "Разработка централизованной системы заказов на базе системы складского учета «Гермес-Торговля».^J" 
                  "Инструменты - SprintDb 3.1, платформа - Windows Mobile 2005 (по заказу ЧП Горюнов)")

               "Проектирование механической торговой системы на рынке Forex (по заказу ПНТК «Искра», г. Мариуполь)." 

               (pack
                  "Разработка и внедрение системы обмена sms-сообщениями «Smsgate».^J"
                  "Инструменты - Perl 5.8.8, платформа Linux. Внедрение - «Родовид Банк», г.Киев.")
 )
            )
         ) 
      )
)
# ====================Content==========================================================

(setq html-tags
   '(.html .head .body .p .br .strong .ul .li .h1 .h2))

(de flatten (l)
   # избавиться от вложенности
   (mapcan '((x) x) l)
 )

(de attrs? (x)
   # проверяет является ли аргумент ассоциативным массивом/аттрибутами
   (and (pair x) (pair (car x)) T)
 )

(de nattrs? (x)
   (not (attrs? x))
 )

(de tag-attrs (tags)
   (glue " " 
      (mapcar '((p) (list (sym (car p)) "=\"" (car (cdr p)) "\"")) tags))
 )

(de tag-start (tag attrs)
   (if attrs
      (pack "<" tag " " (tag-attrs attrs) ">")
      (pack "<" tag ">"))
 )

(de tag-end (tag)
   (pack "</" tag ">")
 )

(de all-args @
   # возвращает все переданные аргументы в виде списка
   (let (res '())
      (while (args)
         (setq res (cons (next) res)))
      (reverse res))
   )

(de tag-name (tag-sym)
   # возращает имя тэга как строки
   (let (name (chop (sym tag-sym)))
      (pack (nth name 2))
      )
   )

(de str-replace (s-chopped,what,to)
   # функция замены символа на строку
   # ожидает что строка уже порублена (chop)
   
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

(de tag-str-sanitize (s)
   # изменение служебных символов на символы html
   (let (sl (chop s))
      (pack (str-replace sl "^J" "<br>"))
      )
   )

(de tag-sanitize (subtags)
   # подготовка тэгов для публикации в html

   (let 
      (subtags-list (if (pair subtags)
                       subtags 
                       (list subtags))  # преобразуем в список, если subtags - просто строка
      
       sanitized (mapcar '((tag) 
                           (if (str? tag) 
                              (tag-str-sanitize tag)
                              tag ) )
                    subtags-list )
       
       result (if (pair subtags)        # если на вход была подана просто строка, то возращаем тоже строку
                 sanitized
                 (car sanitized) ) )
      result 
 ) )

(de tag-long (tag-sym, attrs, subtags)
   (let (name (tag-name tag-sym))
      (pack 
         (tag-start name attrs) 
         (tag-sanitize subtags)
         (tag-end name) ) )
 )

(de tag-func-local (@tag-sym)
   (curry (@tag-sym)
      @ (let (args1 (pass all-args)
              attrs (car (filter attrs? args1))
              subtags (filter nattrs? args1))
           (tag-long '@tag-sym attrs subtags))) 
 )

(de tag-short (tag-sym attrs)
   (pack "<" (tag-name tag-sym) " " (tag-attrs attrs) " />")
 )

(de .meta (attrs)
   (tag-short '.meta attrs)
 )

(de ..list @
   # функция для удобного создания маркированного списка
   (tag-long '.ul NIL 
      (mapcar '((tag) (tag-long '.li NIL tag)) (pass all-args))
      )
 )

(de tag-locals-create ()
   (list 'let
      (flatten          
         (mapcar '((tag) (list tag (list 'tag-func-local (cons 'quote tag)))) html-tags) 
         ))
 )

(de htmlify (t)
   (let (l (tag-locals-create) # создать локальным функции по именам тэгов
         l2 (append l (cons (cons 'list t))) # добавим текст как аргумент
         ) 
         (pack (eval l2))))             # выполним и сразу получим результат

# тест
(prinl (htmlify txt))
(bye)

