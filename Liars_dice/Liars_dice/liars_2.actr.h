;;; Model of Lie-R
;;;
;;;
;;(set-all-baselevels -100 10) ;; time offset and number of references

(add-dm
    ;;bidnumbers (incomplete)
    (bidnumber1 isa bidnumber number 1 nextnumber 2 previous nil)
    (bidnumber2 isa bidnumber number 2 nextnumber 3 previous 1)
    (bidnumber3 isa bidnumber number 3 nextnumber 4 previous 2)
    (bidnumber4 isa bidnumber number 4 nextnumber 5 previous 3)
    (bidnumber5 isa bidnumber number 5 nextnumber 6 previous 4)
    (bidnumber6 isa bidnumber number 6 nextnumber 7 previous 5)
    (bidnumber7 isa bidnumber number 7 nextnumber 8 previous 6)
    (bidnumber8 isa bidnumber number 8 nextnumber 9 previous 7)
    (bidnumber9 isa bidnumber number 9 nextnumber 10 previous 8)
    (bidnumber10 isa bidnumber number 10 nextnumber 11 previous 9)
    (bidnumber11 isa bidnumber number 11 nextnumber 12 previous 10)
    (bidnumber12 isa bidnumber number 12 nextnumber 13 previous 11)
    (bidnumber13 isa bidnumber number 13 nextnumber 14 previous 12)
    (bidnumber14 isa bidnumber number 14 nextnumber 15 previous 13)
    
    ;;bidfaces
    (bidface1 isa bidface face "one" nextface "two" previous "six")
    (bidface2 isa bidface face "two" nextface "three" previous "one")
    (bidface3 isa bidface face "three" nextface "four" previous "two")
    (bidface4 isa bidface face "four" nextface "five" previous "three")
    (bidface5 isa bidface face "five" nextface "six" previous "four")
    (bidface6 isa bidface face "six" nextface "one" previous "five")
    
    (chunk-type isa current-state handone handtwo handthree handfour handfive handsix totaldie bidface bidnumber reasonable)
    
    ;;dummy data that was used for testing
    ;;(dummy-state1 isa current-state handone 5 handtwo 1 handthree 1 handfour 0 handfive 0 handsix 0 totaldie 15 bidface "two" bidnumber 1 reasonable 1)
    
    ;;(dummy-state2 isa current-state handone 1 handtwo 1 handthree 1 handfour 1 handfive 1 handsix 0 totaldie 10 bidface "two" bidnumber 5 reasonable 0)
    
    (start-goal isa goal state start) ;; bidface "two" bidnumber 1 totaldie 15 handone 5 handtwo 1 handthree 1 handfour 0 handfive 0 handsix 0)
)

(set-all-baselevels -100 10)

(p start-hand
    =goal>
        isa goal
        state start
==>
    =goal>
        state got-hand
    +action>
        isa move
        bidface one
        bidnumber 1
        totaldie 1
        handone 1
        handtwo 1
        handthree 1
        handfour 1
        handfive 1
        handsix 1
)

(p start
    =goal>
        isa goal
        state got-hand
    =action>
        isa move
        bidface =bidface
        bidnumber =bidnumber
        totaldie =totaldie
        handone =handone
        handtwo =handtwo
        handthree =handthree
        handfour =handfour
        handfive =handfive
        handsix =handsix
==>
    =goal>
        state retrieving-state
        bidface =bidface
        bidnumber =bidnumber
        totaldie =totaldie
        handone =handone
        handtwo =handtwo
        handthree =handthree
        handfour =handfour
        handfive =handfive
        handsix =handsix

)

;;if current-state in memory with reasonable=1
;;make bid
;;IDEA: make look for not NOT reasonable instead
;;because at first the model will have no experience at all, but the bids at beginning are usually reasonable
(p check-reasonable
    =goal>
        isa goal
        state retrieving-state
        bidface =currentbidface
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six

==>
    +retrieval>
        isa current-state
        bidface =currentbidface
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six
        reasonable 1
    =goal>
        state make-bid
        reasonable 1
)

;if there is no memory of current-state
;; or it is not reasonable, call challenge
(p reasonable-failure

    ?retrieval>
        state error ;;reasonable was not true
==>
    =goal>
        reasonable 0
        state bid-done
    +action>
        isa move
        bidface =bidface
        bidnumber =bidnumber
        challenge "challenge"
    
)
;; INCREASE NUMBER OF BID
;; if face in hand
;; store new bidnumber in retrieval buffer
(p retrieve-next-number
    =goal>
        isa goal
        state retrieve-number
        bidnumber =currentbidnumber
        bidface =currentbidface
==>
    +retrieval>
        isa bidnumber
        previous =currentbidnumber
    =goal>
        state increase-number
)
(p increase-number
    =goal>
        isa goal
        state increase-number
        bidface =bidface
    =retrieval>
        isa bidnumber
        number =num1
==>
    =goal>
        state bid-done
        bidnumber =num1
    +action>
        isa move
        bidnumber =num1
        bidface =bidface
        challenge 0
)
;; if bidface in hand, retrieve next face
;; keep current-state stored in imaginal buffer
(p retrieve-next-face
    =goal>
        isa goal
        state retrieve-face
        bidface =currentbidface
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six
==>
    +imaginal>
        isa current-state
        bidface =currentbidface
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six
        reasonable 1
    -retrieval>
    +retrieval>
        isa bidface
        previous =currentbidface
    =goal>
        state check-new-face
)
;;new face in hand -->=
(p increase-face
    =goal>
        isa goal
        state increase-face
        bidnumber =bidnumber
        inhand 1
    =retrieval>
        isa bidface
        face =face1
==>
    =goal>
        state bid-done
        bidface =face1
    +action>
        isa move
        bidnumber =bidnumber
        bidface =face1
        challenge 0
)
;;if face is six --> means that face will decrease and thus increase number
(p decrease-face-increase-number
    =goal>
        isa goal
        state retrieve-next-face-six
        bidface =currentbidface
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six
==>
    +imaginal>
        isa current-state
        bidface =currentbidface
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six
        reasonable 1
    -retrieval>
    +retrieval>
        isa bidface
        previous =currentbidface
    =goal>
        state check-new-face
)
;;check if the new face is in hand
(p check-new-face
    =goal>
        isa goal
        state check-new-face
    =imaginal>
        isa current-state
        bidface =currentbidface
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six
        reasonable 1
    =retrieval>
        isa bidface
        previous =currentbidface
        face =face1
==>
    =goal>
        state make-bid
        bidface =face1
    =retrieval>
        isa current-state
        bidface =face1
        bidnumber =currentbidnumber
        totaldie =die
        handone =one
        handtwo =two
        handthree =three
        handfour =four
        handfive =five
        handsix =six
        reasonable 1
    -imaginal>
)

;; WHEN BIDFACE IN HAND
;; the corresponding production will fire
(p bidface-one-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "one"
        reasonable 1
    =retrieval>
        isa current-state
        >= handone 1
==>
    =goal>
        state retrieve-number
        inhand 1
)
(p bidface-two-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "two"
        reasonable 1
    =retrieval>
        >= handtwo 1
==>
    =goal>
        inhand 1
        state retrieve-number
)

(p bidface-three-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "three"
        reasonable 1
    =retrieval>
        isa current-state
        >= handthree 1
==>
    =goal>
        inhand 1
        state retrieve-number
)
(p bidface-four-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "four"
        reasonable 1
    =retrieval>
        isa current-state
        >= handfour 1
==>
    =goal>
        inhand 1
        state retrieve-number
)
(p bidface-five-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "five"
        reasonable 1
    =retrieval>
        isa current-state
        >= handfive 1
==>
    =goal>
        inhand 1
        state retrieve-number
)
(p bidface-six-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "six"
        reasonable 1
    =retrieval>
        isa current-state
        >= handsix 1
==>
    =goal>
        inhand 1
        state retrieve-number
)
;; WHEN BIDFACE IS NOT IN HAND
;; the corresponding production will fire
(p bidface-one-not-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "one"
        reasonable 1
    =retrieval>
        isa current-state
        < handone 1
==>
    =goal>
        state retrieve-face
)
(p bidface-two-not-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "two"
        reasonable 1
    =retrieval>
        isa current-state
        < handtwo 1
==>
    =goal>
        state retrieve-face
)
(p bidface-three-not-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "three"
        reasonable 1
    =retrieval>
        isa current-state
        < handthree 1
==>
    =goal>
        state retrieve-face

)
(p bidface-four-not-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "four"
        reasonable 1
    =retrieval>
        isa current-state
        < handfour 1
==>
    =goal>
        state retrieve-face

)
(p bidface-five-not-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "five"
        reasonable 1
    =retrieval>
        isa current-state
        < handfive 1
==>
    =goal>
        state retrieve-face

)
(p bidface-six-not-in-hand
    =goal>
        isa goal
        state make-bid
        bidface "six"
        reasonable 1
    =retrieval>
        isa current-state
        < handsix 1
==>
    =goal>
        state retrieve-next-face-six
    =retrieval>
        bidface "six"

)
(p bid-done
    =goal>
        isa goal
        state bid-done
==>
    -action>
    
    =goal>
        isa goal
        state start
)
(goal-focus start-goal)
