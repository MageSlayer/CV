#!/usr/bin/picolisp /usr/lib/picolisp/lib.l

(load "html.l")

# ====================Content==========================================================
(setq lang-current 'en)
(setq lang-current 'ru)

(de lang @
   # получает на вход список с переводами
   # возращает текст согласно текущему lang-current

   (let (p (pass all-args)
         mes NIL
         lng NIL)
      (loop
         (setq mes (cadr p))
         (setq lng (car p))
         (T (= lng lang-current) mes)

         (setq p (cddr p))
         (setq mes NIL)
         (T (not p) NIL)
         )
      mes
      )
   )

(de experience (period, company, position)
   (list 
      (.p (.strong (lang 
                      'ru "Период : " 
                      'en "Period : " ) ) period ) 
      (.p (.strong (lang 
                      'ru "Место работы : " 
                      'en "Company : ") ) company ) 
      (.p (.strong (lang 
                      'ru "Должность : "
                      'en "Position : " ) ) position ) )
 )

(de job-description (x)
   (.p (.strong (lang 
                   'ru "Обязанности : "
                   'en "Responsibilities : " ) ) x ) 
 )

(de projects-gen ( caption . @ )
  (list
     (.p (.strong (or caption (lang
                                 'ru "Проекты : "
                                 'en "Projects : ") ) ) )
     (pass ..list))
 )

(de projects-business @
   (pass projects-gen (lang 
                         'ru "Бизнес-ориентированные проекты : " 
                         'en "Business-oriented projects : " ) )
 )

(de projects-internal @
   (pass projects-gen (lang 
                         'ru "Внутренние проекты : "
                         'en "Internal projects :" ) )
 )

(de projects @
   (pass projects-gen NIL)
 )

(de education (period, establishment, speciality, qualicafication)
   (..table 
      (list 
         (list (.strong (lang 
                           'ru "Период : "
                           'en "Period : " ) ) period )
         (list (.strong (lang 
                           'ru "Название учебного заведения : "
                           'en "Educational institution : ") ) establishment )
         (list (.strong (lang
                           'ru "Специальность : " 
                           'en "Speciality : " ) ) speciality )
         (list (.strong (lang 
                           'ru "Полученная степень (квалификация) : "
                           'en "Qualification : " )) qualicafication ) ) )
 )

(de recommendation (name, telephone, email, position, company)
   (..table
      (list 
         (list (.strong (lang 
                           'ru "Имя : "
                           'en "Name : " ) ) name )
         (list (.strong (lang 
                           'ru "Телефон/факс : " 
                           'en "Phone number : " ) ) telephone )
         (list (.strong "E-mail : "  email ) )
         (list (.strong (lang 
                           'ru "Должность : "
                           'en "Post : ") ) position )
         (list (.strong (lang 
                           'ru "Компания : "
                           'en "Company : " )) company ) ) )
 )

(de job-conditions (kind, work-type, field, business-trips, relocation-time, desired-tech)
   (..table
      (list 
         (list (.strong (lang 
                           'ru "Желаемая форма занятости : "
                           'en "Employment form : ")) kind )
         (list (.strong (lang
                           'ru "Желаемый график работы : "
                           'en "Schedule : " ) ) work-type )
         (list (.strong (lang
                           'ru "Желаемое направление деятельности : " 
                           'en "Activity : " ) ) field )
         (list (.strong (lang 
                           'ru "Готовность к командировкам : "
                           'en "Business trips : " ) ) business-trips )
         (list (.strong (lang
                           'ru "Срок возможного выхода на работу^Jс момента поступления предложения : "
                           'en "Term of appearance at work^Jsince proposition" ) ) relocation-time ) 
         (list (.strong (lang
                           'ru "Предпочтительные технологии : " 
                           'en "Technologies wanted :" ) ) desired-tech ) )
      )
 )

(de dev-lang-experience (x)
   (list (.p (.strong (lang
                         'ru "Опыт программирования : " 
                         'en "Programming experience : " ) ) )
      (..table
         (mapcar '((expr) 
                   (list (.strong (car expr)) (pack (lang
                                                       'ru "с " 'en "since ") (cadr expr) (lang 'ru "г.") ) ) )
            x ) )
      )
 )

(setq txt
   (..html-std
      (.h1 (..attrs '((align center))) 
         (lang 
            'ru "Головань Денис Сергеевич"
            'en "Denis Sergeevich Golovan" ) )
         
      (..table
         (list
            (list
               (..table 
                  (list
                     (list (.strong (lang 'ru "Домашний адрес : " 'en "Home address : "))      
                              (lang 'ru "г. Киев ул. Олевская 5 кв. 201" 'en "Ap.201^J5 Olevska str.^JKyiv^JUkraine") )
                     (list (.strong (lang 'ru "Мобильный телефон : " 'en "Mobile phone : "))   "+38 097 413-38-13")
                     (list (.strong "e-mail, Mail-Agent : ")  (..mailto "denis_golovan@mail.ru" "Job offer"))
                     (list (.strong "e-mail, googletalk : ")  (..mailto "denisgolovan@gmail.com" "Job offer"))
                     (list (.strong "ICQ:")                 "105051989")
                     (list (.strong (lang 'ru "Дата рождения : " 'en "Birthday : "))       "10.10.1981") ) )
               (.img "Golovan.jpg" "фото Головань Д.С.")
               ) ) )
      
      #(.br)
      (.p (lang 
             'ru "Семейное положение : женат, детей нет." 
             'en "Family status : married, no children.") )

      (.p (lang 
             'ru "Желаемая должность : инженер-программист." 
             'en "Wished occupation : program developer.") )
      
      (.br)
      (.h2 (..attrs '((align center))) 
         (lang
            'ru "Опыт работы"
            'en "Gained experience") )
      
      (experience 
         (lang 
            'ru "(июль 2008 по настоящее время)"
            'en "(July 2008 - Until now)")
         (list (.a 
                  "http://www.simcorp.com/" 
                  (lang 
                     'ru "SimCorp Ukraine LLC (г. Киев)"
                     'en "SimCorp Ukraine LLC (Kyiv, Ukraine)" ) ) 
            ", " 
            (lang 
               'ru "отдел Performance Measurement"
               'en "Performance Measurement department" ) )
         (lang
            'ru "старший инженер программист"
            'en "Senior System Development Consultant") )
      
      (job-description
         (lang 
            'ru "Разработка и поддержка функциональности в рамках системы управления инвестициями SimCorp Dimension.^JПлатформа - Dyalog APL v13.0, Oracle database v11g."
            'en "Development and support of functionality for investment management software SimCorp Dimension.^JPlatform - Dyalog APL v13.0, Oracle database v11g."
            ))
      
      (projects-business
         "Multiple investment structures"
         "Spread-based indices implementation"
         "Market value weighted benchmarks implementation"
         "Multiple model portfolios tree type support for Performance Measurement module" )
      
      (projects-internal
         (lang 'ru "дополнительный инструментарий разработчика" 'en "additional developer tool-set")
         (lang 'ru "отладочный инструмент на основе покрытия кода" 'en "code coverage-based investigation tool")
         (lang 'ru "инструментарий поддержки юнит-тестов" 'en "unit test support tools") )
      
      (.br)
      (experience
         (lang 'ru "(май 2007 по июль 2008)" 'en "(May 2007 - July 2008)")
         (lang 'ru "Фрилансер" 'en "Freelancer")
         (lang 'ru "независимый разработчик" 'en "Independent developer") )
      
      (projects
         (lang 
            'ru (pack 
                   "Разработка приложения мобильного составления заказов для системы складского учета «Гермес-Торговля».^J"
                   "Платформа разработки - Linux, Lazarus, SQLite (кросс-компиляция для архитектуры ARM).^J"
                   "Платформа приложения - Windows Mobile 2005 (по заказу ЧП Горюнов)." )
            'en (pack
                   "Development of mobile trade orders application for «Germes-Trade» accounting system.^J"
                   "Development platform - Linux, Lazarus, SQLite (cross-build for ARM architecture).^J"
                   "Application platform - Windows Mobile 2005 (Privately owned enterprise Gorunov).")
            )
         
         (lang
            'ru (pack 
                   "Разработка централизованной системы заказов на базе системы складского учета «Гермес-Торговля».^J" 
                   "Инструменты - SprintDb 3.1, платформа - Windows Mobile 2005 (по заказу ЧП Горюнов)" )
            'en (pack 
                   "Centralized order reserve system development for «Germes-Trade» accounting system.^J"
                   "Development software - SprintDb 3.1, platform - Windows Mobile 2005 (Privately owned enterprise Gorunov)" ) 
            )
         
         (lang
            'ru "Проектирование механической торговой системы на рынке Forex (по заказу ПНТК «Искра», г. Мариуполь)." 
            'en "Mechanical trade system design for Forex market (by request of «Iskra Ltd», Mariupol). ")
         
         (lang 
            'ru (pack
                   "Разработка и внедрение системы обмена sms-сообщениями «Smsgate».^J"
                   "Инструменты - Perl 5.8.8, платформа Linux. Внедрение - «Родовид Банк», г.Киев." )
            'en (pack
                   "Development and deploying sms-message flow system «Smsgate».^J" 
                   "Development software - Perl 5.8.8, platform Linux. Deployed at «Rodovid Bank», Kyiv.")
            )
         )
      
      (.br)
      (experience
         (lang 
            'ru "(апрель 2005г. по май 2007)"
            'en "(April 2005 till May 2007)" )
         (lang 
            'ru "ООО «АзовПром» (г. Мариуполь)"
            'en "«AzovProm» Ltd. (Mariupol)")
         (lang
            'ru "инженер-программист, разработчик баз данных"
            'en "programmer, database developer") )
      
      (job-description
         (lang
            'ru "разработка и внедрение систем учёта энергоснабжения; сопровождение баз данных"
            'en "development and installation of the accounting system of the energy supply; database maintenance.") )
      
      (projects
         (lang
            'ru (pack
                   "Разработка системы распределенного хранения объектов и документов со связями «ИнСОП».^J"
                   "Инструменты - Borland Delphi v7.0, IBExpert v2.0, FireBird v2, FastReport v3.^J"
                   "Ведение проектной документации и документации для разработчиков в WackoWiki r4.2.")
            'en (pack
                   "Development of distribute object and document storing system «InSOP».^J"
                   "Development software - Borland Delphi v7.0, IBExpert v2.0, FireBird v1.5, FastReport v3.^J"
                   "Project and developer documentation maintenance using WackoWiki r4.2.")
            )
         
         (lang
            'ru (pack 
                   "Разработка системы централизованного хранения графических схем со связями «ПромCAD.Каталог».^J"
                   "Схемы хранятся в иерархическом виде, аналогичном принципам файловой системы с возможностью назначения прав пользователям.^J"
                   "Интеграция с графическим редактором «ПромCAD» выполнена в виде набора плагинов. Внедрение на ЗАО «Сервис-Инвест», г. Донецк.^J"
                   "Инструменты - Borland Turbo Delphi, IBExpert v2.0, FireBird v2." )
            'en (pack
                   "Development of centralized graphical schemes and objects storing system «PromCAD.Catalog».^J"
                   "Schemes are stored hierarchically filesystem-like. Every entity can be secured using a set of user rights.^J"
                   "Graphical editor «PromCAD» integration implemented as a set of plug-ins. Deployed at «Service-Invest» Ltd, Donetsk.^J"
                   "Development software – Borland Turbo Delphi, IBExpert v2.0, FireBird v2."
                   )
            )
         
         (lang
            'ru (pack 
                   "Сопровождение и доработка системы учета энергоснабжения «Энергосбыт» на базе Yaffil v1.0.^J" 
                   "Инструменты - Borland Delphi v5.0, IBExpert v2.0. Внедрение на ЗАО «Сервис-Инвест», г. Донецк." )
            'en (pack 
                   "Maintenance and updating of accounting system of the energy supply. Database platform - Yaffil v1.0.^J"
                   "Development software - Borland Delphi v5.0, IBExpert v2.0.")
            )
         )
      
      (.br)
      (experience
         (lang 'ru "(март 2004г. по апрель 2005г.)" 'en "(March 2004 till April 2005)")
         (lang 'ru "ЧП «Маус» (г. Мариуполь)" 'en "Privately owned enterprise «Mouse» (Mariupol)")
         (lang 'ru "ст. инженер тех.отдела, разработчик баз данных." 'en "engineering department chief, database developer.") )
      
      (job-description
         (lang 
            'ru "разработка и внедрение систем складского и бухгалтерского учёта; проектирование, монтаж и администрирование локальных сетей."
            'en "development and installation of accounting and bookkeeping systems; designing, installation and administration of the local data-processing networks") )
      
      (projects 
         (lang
            'ru "Разработка и внедрение базы данных ведения входящей документации (по заказу отдела главного архитектора горисполкома города Мариуполя)."
            'en "Development and installation of the inbox documentation database (by request of the main architect’s department of Mariupol Executive Committee).")
         (lang
            'ru "Установка и настройка мини-АТС Panasonic KXT61610B (по заказу ЗАО «Автосварка»)."
            'en "Installation and setup of mini-ATS Panasonic KXT61610B (by request of close corporation  «Autowelding»).")
         (lang
            'ru "Настройка и администрирование локальной сети на 26 портов на базе  ОС  Windows 2000 Server\\2000\\XP (по заказу Управления городского имущества г. Мариуполя)."
            'en "26 port LAN setup and administering. Used OSes - Windows 2000 Server\\2000\\XP (by request of Mariupol Municipal Property Office).")
         (lang
            'ru "Перевод тех. отдела на электронную систему ведения документации."
            'en "Computer engineering department accounting introduction.")
         (lang
            'ru "Доработка, техническая поддержка, разработка руководства пользователя для системы складского учёта «Гермес-Торговля» (разработчик Дранга Г.В., платформа MS Access97/2000)."
            'en "Updating, technical support, user manual development for the accounting system «Germes-Trade» (chief developer - Dranga G.V., platform - MS Access 97/2000).")
         (lang
            'ru "Внедрение системы складского учёта «Гермес-Торговля», разработка модуля, реализующего связь с кассовым аппаратом (по заказу магазина «Арсенал» г.Мариуполь)."
            'en "«Germes-Trade» accounting system installation, cash register module creation (by request of «Arsenal» shop, Mariupol).")
         (lang
            'ru "Разработка системы складского учёта «Максим-Склад» (по заказу клуба «Максим» г. Мариуполь)"
            'en "«Maxim-Store» accounting system development (by request of the night club «Maxim», Mariupol)")
         )
      
      
      (.br)
      (experience
         (lang 'ru "(март 2003г. по май 2007)" 'en "(March 2003 till May 2007)")
         (lang 'ru "Жовтневое управление труда и социальной защиты населения г. Мариуполя." 'en "Mariupol aldermanry of manpower reserves and social security of citizenry")
         (lang 'ru "старший системный администратор" 'en "senior system administrator") )
      
      (projects
         (lang 
            'ru "Развертывание и администрирование сервера сообщений на базе Wildfire+Miranda+Active Directory."
            'en "Deploying and administrating chat server Wildfire+Miranda+Active Directory.")
         (lang 
            'ru "Ведение документации по настройке сетевой инфраструктуры при помощи MediaWiki."
            'en "Network infrastructure documentation maintenance using MediaWiki.")
         (lang 
            'ru "Решение проблем совместимости DOS баз данных в инфраструктуре MS Active Directory - разработка специализированного резидентного драйвера реального режима. Инструменты - Borland Tasm, RadAsm IDE."
            'en "Solving of DOS databases misbehavior in MS Active Directory infrastructure - development of specialized resident real mode driver. Development software - Borland Tasm, RadAsm IDE.")
         (lang 
            'ru "Разработка и внедрение баз данных для хранения и анализа задолженности предприятий города, ведения выплатных ведомостей. Инструменты - Borland Delphi v7.0, IBExpert v2.0, FireBird v2, FastReport v3."
            'en "Development and deployment of specialized database for analysis and storing Mariupol organizations’ salary debts, database for working with pay lists. Development software - Borland Delphi v7.0, IBExpert v2.0, FireBird v2, FastReport v3.")
         (lang
            'ru "Развертывание и администрирование централизованной антивирусной системы на базе NOD32 LAN Update Server."
            'en "Deploying and administrating centralized antivirus system NOD32 LAN Update Server.")
         (lang
            'ru "Развертывание и администрирование сервера обновлений WSUS для Windows 2000 Server."
            'en "Deploying and administrating Microsoft Windows Server Update Services.")
         (lang
            'ru "Развертывание и администрирование сервера баз данных Pervasive SQL v8.5."
            'en "Deploying and administrating database server Pervasive SQL v8.5.")
         (lang
            'ru "Автоматизация операций обслуживания серверов с использованием WSH."
            'en "Servers’ maintenance automation using WSH.")
         (lang
            'ru "Введение системы аудита печати на базе PCounter."
            'en "Printing auditing system using PCounter.")
         (lang
            'ru "Настройка и администрирование доступа в интернет на базе выделенной линии с использованием прокси-сервера MS ISA Server 2000, Wingate, почтового сервера MDaemon. Оптимизация интернет-траффика за счет настройки прокси-сервера Proxomitron."
            'en "Leased line Internet access setup and administrating using MS ISA Server 2000, Wingate, MDaemon mail server. Internet traffic optimization by means of Proxomitron filtering proxy-server.")
         (lang 
            'ru "Руководство прокладкой и администрирование локальной сети на 55 рабочих мест на базе ОС Novell Netware\\Win2000 Server\\Win2003 Server\\Terminal Server\\WinNT4\\2000\\XP. Повсеместный переход с платформы Win9x на платформу WinNT. Внедрение удалённого администрирования на базе RAdmin v2.1."
            'en "55 port LAN mounting supervision and administrating using following OSes - Novell Netware 5.0\\Windows 2000 Server\\Windows 2003 Server\\WinNT4\\2000\\XP. Total migration to NT-based OSes. Overall remote administration introduction, chosen solution - RAdmin v2.1.")
         (lang
            'ru "Диагностика ошибок аппаратного и программного обеспечения. Выбор и составление заказов на закупку компьютерной техники и комплектующих с учетом потребностей УТСЗН, что позволило сократить расходы на обслуживание. Анализ потребности отделов УТСЗН в компьютерной технике."
            'en "Hardware and software faults diagnostics. Computer hardware selection, taking into account organization requirements, lead to decreased total service expenses. Department computer necessity analysis.")
         (lang
            'ru "Разработка и внедрение специализированных баз данных на основе MS Access+VBA+SQL для автоматизации задач отделов труда, контроля за назначением пенсий, адресной социальной помощи. Настройка устаревших DOS баз данных для работы в сети."
            'en "Development and installation special-purpose databases on the MS Access platform, using VBA+SQL, for task solution automation. Targeted departments - labour department, pension allotment control department, department of the address social pecuniary aid. Outdated DOS databases network administration.")
         (lang
            'ru "Оптимизация документооборота между отделами субсидий и компьютерным отделом на основе LAN."
            'en "Documents circulation optimization between subvention and IT departments using LAN.") )
      
      
      (.br)
      (.h2 (..attrs '((align center))) 
         (lang 'ru "Образование" 'en "Education" ))
         
      (education 
         (lang 'ru "Сентябрь 2002 - Июль 2003" 'en "September 2002 - July 2003")
         (lang 'ru "Приазовский государственный технический университет" 'en "Priazov State Technical University")
         (lang 'ru "Оборудование и технология сварочного производства" 'en "Welding equipment and technology")
         (lang 'ru "Специалист" 'en "Specialist")
         )
      
      (.br)
      (education 
         (lang 'ru "Сентябрь 1998 - июль 2002" 'en "September 1998 - July 2002")
         (lang 'ru "Приазовский государственный технический университет" 'en "Priazov State Technical University")
         (lang 'ru "Оборудование и технология сварочного производства" 'en "Welding equipment and technology")
         (lang 'ru "Бакалавр" 'en "Bachelor")
         )
      
      (.br)
      (education 
         (lang 'ru "Сентябрь 1996 - июль 1998" 'en "September 1996 - July 1998")
         (lang 'ru "Мариупольский технический лицей" 'en "Mariupol technical lyceum")
         (lang 'ru "Курс углублённого изучения математики, физики, иностранного языка" 'en "In-depth study of mathematics, physics, foreign language")
         (lang 'ru "Законченное среднее образование" 'en "Secondary education"))
      
      (.br)
      (.p (.strong (lang 'ru "Дополнительное образование" 'en "Supplementary education")))
      (.p 
         (lang 
            'ru "В 1999 г. закончил 8-месячные курсы разговорного английского языка при институте повышения квалификации ПГТУ." 
            'en "I graduated from 8-month English speaking language course at PSTU in 1999.") )
      
      (.br)
      (.h2 (..attrs '((align center))) 
         (lang 'ru "Рекомендации" 'en "Recommendations"))
      
      (recommendation 
         (lang 'ru "Серенко Александр Никитич" 'en "Serenko Alexander Nikitich")
         "+38 (0629) 33-37-84"
         "-"
         (lang 'ru "зам. зав. кафедрой ОиТСП ПГТУ, профессор, доктор технических наук" 'en "professor, Doctor of Science, PSTU")
         (lang 'ru "Приазовский государственный технический университет" 'en "Priazov State Technical University") )
      
      (.br)
      (.h2 (..attrs '((align center))) 
         (lang 'ru "Желаемые условия работы" 'en "Work Conditions") )
      
      (job-conditions 
         (lang 'ru "Полный рабочий день или удаленная работа" 'en "Full employment or remote work")
         (lang 'ru "Нормированный рабочий день" 'en "standard labour")
         (lang 'ru "Информационные технологии" 'en "Information Technology (IT)")
         (lang 'ru "Да" 'en "Yes")
         (lang 'ru "2-3 недели" 'en "2-3 weeks")
         (lang 'ru "языки программирования - Common Lisp, Clojure, APL, A+, J, KDB" 'en "Programming languages: Common Lisp, Clojure, APL, A+, J, KDB"))
      
      (.br)
      (.p (.strong (lang 'ru "Дополнительная информация :" 'en "Additional information :")))
      (.p (.strong (lang 'ru "Владение языком : " 'en "Foreign language : ")) 
             (lang 
                'ru "Английский технический, advanced level." 
                'en "English technical, advanced level." ) ) 
      
      (.br)
      (dev-lang-experience 
         '(("Dyalog APL" 2008)
           ("Lua/LuaJIT" 2009)
           ("FreePascal/Lazarus" 2007)
           ("Borland Delphi" 1997)
           ("C++ Builder, Borland C++" 1998)
           ("x86 Assembler" 2000)
           ("MS Access" 2003) ) )
      
      (.p 
         (lang 
            'ru (pack
                   "Имею значительный опыт администрирования (с 2007) платформы Linux (дистрибутив CentOS, Gentoo).^J" 
                   "Серверные задачи -  Iptables, Apache (Mantis bugtracking system), Postfix, VNC сервер, Asterisk, OpenVPN, OpenFire." ) 
            'en (pack
                   "I possess advanced knowledge (since mid-2007) in administering Linux platform (CentOS, Gentoo distributive).^J"
                   "Server services -  Iptables, Apache (Mantis bugtracking system), Postfix, VNC server, Asterisk, OpenVPN, OpenFire." ))
         )
      
      (.br)
      (.p (.strong (lang 'ru "Личные характеристики :" 'en "Personal characteristics :")))
      
      (.p 
         (lang 
            'ru "Аналитический склад ума, любознательность помогают при решении нестандартных и производственных задач. Быстрая обучаемость новым прогрессивным технологиям. Высокая надежность, ответственность. Высокая самоорганизованность, самостоятельность и инициативность. Прагматичность, целеустремленность, исполнительность. Высокая работоспособность. Вредных привычек нет. " 
            'en "Analytical turn of mind, intellectual curiosity help to solve non-standard and production problems. Quick learning of new progressive technologies. High reliability and responsibility. High level of self-organization, self-dependence and initiative. Pragmatism, goal-seeking behavior, diligence. High capacity for work. Bad habits absent.") )
      
      (.br)
      (.p (.strong (lang 'ru "Занятия и увлечения :" 'en "Hobbies :")))
      
      (.p 
         (lang 
            'ru "Решение нестандартных инженерных задач, защита программ от нелицензионного копирования, программирование 3D графики, исследование алгоритмов искусственного интеллекта и физического взаимодействия в игровых программах, изучение технологии распределённых вычислений в глобальных и локальных сетях и проблем сетевой безопасности. Интересуюсь технологией управления персоналом на больших производственных предприятиях и влиянием политики на жизнь общества."
            'en "Solving of non-standard engineering problems, software copy-protection, 3D graphics programming, game AI and physical interaction algorithms analysis, study of distribute calculation in global and local networks and problems of network security. I am interested in personnel management technology at large production enterprises and  influence of politics on society life." ) )
      
      (.br)
      (.p 
         (lang 'ru "Дата составления: 03-09-2013" 'en "Compilation date: 03-11-2013"))
      
 ) )
# ====================Content==========================================================
# тест
#(prinl (htmlify txt))
(prinl txt)
(bye)
