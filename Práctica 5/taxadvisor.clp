;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Income tax forms advisor from part 3 of "Jess in Action"
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module MAIN

(defmodule MAIN (export ?ALL))

(deftemplate MAIN::user
  (slot income (default 0))
  (slot dependents (default 0)))

(deftemplate MAIN::question
  (slot text)
  (slot type)
  (slot ident))

(deftemplate MAIN::ask
  (slot ident))

(deftemplate MAIN::answer
  (slot ident)
  (slot text))

(deftemplate MAIN::recommendation
  (slot form)
  (slot explanation))

(deffacts MAIN::question-data
  "The questions the system can ask."
  (question (ident income) (type number)
            (text "What was your annual income?"))
  (question (ident interest) (type yes-no)
            (text "Did you earn more than $400 of taxable interest?"))
  (question (ident dependents) (type number)
            (text "How many dependents live with you?"))
  (question (ident childcare) (type yes-no)
            (text "Did you have dependent care expenses?"))
  (question (ident moving) (type yes-no)
            (text "Did you move for job-related reasons?"))
  (question (ident employee) (type yes-no)
            (text "Did you have unreimbursed employee expenses?"))
  (question (ident reimbursed) (type yes-no)
            (text "Did you have reimbursed employee expenses, too?"))
  (question (ident casualty) (type yes-no)
            (text "Did you have losses from a theft or an accident?"))
  (question (ident on-time) (type yes-no)
            (text "Will you be able to file on time?"))
  (question (ident charity) (type yes-no)
            (text "Did you give more than $500 in property to charity?"))
  (question (ident home-office) (type yes-no)
            (text "Did you work in a home office?")))

(defrule MAIN::start
  (declare (salience 10000))
  =>

  (printout t "Type your name and press Enter> ")
  (bind ?name (read))
  (printout t crlf "**********************************" crlf)
  (printout t " Hello, " ?name "." crlf)
  (printout t " Welcome to the tax forms advisor" crlf)
  (printout t " Please answer the questions and" crlf)
  (printout t " I will tell you what tax forms" crlf)
  (printout t " you may need to file." crlf)
  (printout t "**********************************" crlf crlf)
  (focus INTERVIEW RECOMMEND REPORT))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module ask

;(defmodule ask)
(defmodule QUESTIONS (import MAIN ?ALL))

(deffunction QUESTIONS::is-of-type (?answer ?type)
  "Check that the answer has the right form"
  (if (eq ?type yes-no) then
         (or (eq ?answer yes) (eq ?answer no))
   else
	(if (eq ?type number) then
          (numberp ?answer)
        else (> (str-length ?answer) 0))))


(deffunction QUESTIONS::ask-user (?question ?type)
  "Ask a question, and return the answer"
  (printout t ?question " ")
  (if (eq ?type yes-no) then
           (printout t "(yes or no) "))
  (bind ?answer (read))
  (while (not (is-of-type ?answer ?type)) do
         (printout t ?question " ")
         (if (eq ?type yes-no) then
           (printout t "(yes or no) "))
         (bind ?answer (read)))
  ?answer)


   
(defrule QUESTIONS::ask-question-by-id
  "Given the identifier of a question, ask it and assert the answer"
  
  (declare (auto-focus TRUE))
  (question (ident ?id) (text ?text) (type ?type))
  (not (answer (ident ?id)))
  ?ask <- (ask (ident ?id))
  =>
  (bind ?answer (ask-user ?text ?type))
  (assert (answer (ident ?id) (text ?answer)))
  (retract ?ask))


  

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module interview
;(defmodule interview)

(defmodule INTERVIEW (import MAIN ?ALL)(export ?ALL))

(defrule INTERVIEW::request-income
  (declare (salience 100))
  =>
  (assert (ask (ident income))))

(defrule INTERVIEW::request-num-dependents
   (declare (salience 100))
  =>
  (assert (ask (ident dependents))))

(defrule INTERVIEW::assert-user-fact
  (answer (ident income) (text ?i))
  (answer (ident dependents) (text ?d))
  =>
  (assert (user (income ?i) (dependents ?d))))

(defrule INTERVIEW::request-interest-income
  ;; If the total income is less than 50000
  (answer (ident income) (text ?i&:(< ?i 50000)))
  ;; .. and there are no dependents
  (answer (ident dependents) (text ?d&:(eq ?d 0)))
  =>
  (assert (ask (ident interest))))

(defrule INTERVIEW::request-childcare-expenses
  ;; If the user has dependents
  (answer (ident dependents) (text ?t&:(> ?t 0)))        
  =>
  (assert (ask (ident childcare))))

(defrule INTERVIEW::request-employee-expenses
  =>
  (assert (ask (ident employee))))

(defrule INTERVIEW::request-reimbursed-expenses
  ;; If there were unreimbursed employee expenses...
  (answer (ident employee) (text ?t&:(eq ?t yes)))
  =>
  (assert (ask (ident reimbursed))))

(defrule INTERVIEW::request-moving
  =>
  (assert (ask (ident moving))))

(defrule INTERVIEW::request-casualty
  =>
  (assert (ask (ident casualty))))

(defrule INTERVIEW::request-on-time
  =>
  (assert (ask (ident on-time))))

(defrule INTERVIEW::request-charity
  =>
  (assert (ask (ident charity))))

(defrule INTERVIEW::request-home-office
  =>
  (assert (ask (ident home-office))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module recommend
;(defmodule recommend)

(defmodule RECOMMEND (import MAIN ?ALL))

(defrule RECOMMEND::combine-recommendations
  ?r1 <- (recommendation (form ?f) (explanation ?e1))
  ?r2 <- (recommendation (form ?f) (explanation ?e2&:(neq ?e1 ?e2)))
  =>
  (retract ?r2)
  (modify ?r1 (explanation (str-cat ?e1 ?e2))))

(defrule RECOMMEND::form-1040EZ
  (user (income ?i&:(< ?i 50000))
        (dependents ?d&:(eq ?d 0)))
  (answer (ident interest) (text no))
  =>
  (assert (recommendation
           (form "1040EZ")
           (explanation "Income below threshold, no dependents"))))

(defrule RECOMMEND::form-1040A-excess-interest
  (user (income ?i&:(< ?i 50000)))
  (answer (ident interest) (text yes))
  =>
  (assert (recommendation
           (form "1040A")
           (explanation "Excess interest income"))))

(defrule RECOMMEND::form-1040A
  (user (income ?i&:(< ?i 50000))
        (dependents ?d&:(> ?d 0)))
  =>
  (assert (recommendation
           (form "1040A")
           (explanation "Income below threshold, with dependents"))))

(defrule RECOMMEND::form-1040-income-above-threshold
  (user (income ?i&:(>= ?i 50000)))      
  =>
  (assert (recommendation
           (form "1040")
           (explanation "Income above threshold"))))

(defrule RECOMMEND::form-2441
  (answer (ident childcare) (text yes))
  =>
  (assert (recommendation
           (form "2441")
           (explanation "Child care expenses"))))

(defrule RECOMMEND::form-2016EZ
  (answer (ident employee) (text yes))
  (answer (ident reimbursed) (text no))
  =>
  (bind ?expl "Unreimbursed employee expenses")
  (assert
   (recommendation (form "2016EZ") (explanation ?expl))
   (recommendation (form "1040") (explanation ?expl))))

(defrule RECOMMEND::form-2016
  (answer (ident employee) (text yes))
  (answer (ident reimbursed) (text yes))
  =>
  (bind ?expl "Reimbursed employee expenses")
  (assert
   (recommendation (form "2016") (explanation ?expl))
   (recommendation (form "1040") (explanation ?expl))))

(defrule RECOMMEND::form-3903
  (answer (ident moving) (text yes))
  =>
  (bind ?expl "Moving expenses")
  (assert
   (recommendation (form "3903") (explanation ?expl))
   (recommendation (form "1040") (explanation ?expl))))

(defrule RECOMMEND::form-4684
  (answer (ident casualty) (text yes))
  =>
  (bind ?expl "Losses due to casualty or theft")
  (assert
   (recommendation (form "4684") (explanation ?expl))
   (recommendation (form "1040") (explanation ?expl))))

(defrule RECOMMEND::form-4868
  (answer (ident on-time) (text no))
  =>
  (assert
   (recommendation (form "4868") (explanation "Filing extension"))))

(defrule RECOMMEND::form-8283
  (answer (ident charity) (text yes))
  =>
  (bind ?expl "Excess charitable contributions")
  (assert
   (recommendation (form "8283") (explanation ?expl))
   (recommendation (form "1040") (explanation ?expl))))

(defrule RECOMMEND::form-8829
  (answer (ident home-office) (text yes))
  =>
  (bind ?expl "Home office expenses")
  (assert
   (recommendation (form "8829") (explanation ?expl))
   (recommendation (form "1040") (explanation ?expl))))
                         
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Module report

;(defmodule report)

(defmodule REPORT (import MAIN ?ALL))

(defrule REPORT::sort-and-print
  ?r1 <- (recommendation (form ?f1) (explanation ?e))
  (not (recommendation (form ?f2&:(< (str-compare ?f2 ?f1) 0))))
  =>
  (printout t crlf)
  (printout t "*** Please take a copy of form " ?f1 crlf)
  (printout t "Explanation: "  ?e crlf)
  (retract ?r1))


